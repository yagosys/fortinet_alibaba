package consumerLibrary

import (
	"os"
	"sync"
	"time"

	sls "github.com/aliyun/aliyun-log-go-sdk"
	"github.com/go-kit/kit/log"
	"github.com/go-kit/kit/log/level"
	"go.uber.org/atomic"
	lumberjack "gopkg.in/natefinch/lumberjack.v2"
)

type ConsumerWorker struct {
	consumerHeatBeat   *ConsumerHeatBeat
	client             *ConsumerClient
	workerShutDownFlag *atomic.Bool
	shardConsumer      sync.Map // map[int]*ShardConsumerWorker
	do                 func(shard int, logGroup *sls.LogGroupList) string
	waitGroup          sync.WaitGroup
	Logger             log.Logger
}

func InitConsumerWorker(option LogHubConfig, do func(int, *sls.LogGroupList) string) *ConsumerWorker {
	logger := logConfig(option)
	consumerClient := initConsumerClient(option, logger)
	consumerHeatBeat := initConsumerHeatBeat(consumerClient, logger)
	consumerWorker := &ConsumerWorker{
		consumerHeatBeat:   consumerHeatBeat,
		client:             consumerClient,
		workerShutDownFlag: atomic.NewBool(false),
		//shardConsumer:      make(map[int]*ShardConsumerWorker),
		do:     do,
		Logger: logger,
	}
	consumerClient.createConsumerGroup()
	return consumerWorker
}

func (consumerWorker *ConsumerWorker) Start() {
	consumerWorker.waitGroup.Add(1)
	go consumerWorker.run()
}

func (consumerWorker *ConsumerWorker) StopAndWait() {
	level.Info(consumerWorker.Logger).Log("msg", "*** try to exit ***")
	consumerWorker.workerShutDownFlag.Store(true)
	consumerWorker.consumerHeatBeat.shutDownHeart()
	consumerWorker.waitGroup.Wait()
	level.Info(consumerWorker.Logger).Log("msg", "consumer worker stopped", "consumer name", consumerWorker.client.option.ConsumerName)
}

func (consumerWorker *ConsumerWorker) run() {
	level.Info(consumerWorker.Logger).Log("msg", "consumer worker start", "worker name", consumerWorker.client.option.ConsumerName)
	defer consumerWorker.waitGroup.Done()
	go consumerWorker.consumerHeatBeat.heartBeatRun()

	for !consumerWorker.workerShutDownFlag.Load() {
		heldShards := consumerWorker.consumerHeatBeat.getHeldShards()
		lastFetchTime := time.Now().UnixNano() / 1000 / 1000

		for _, shard := range heldShards {
			if consumerWorker.workerShutDownFlag.Load() {
				break
			}
			shardConsumer := consumerWorker.getShardConsumer(shard)
			if shardConsumer.getConsumerIsCurrentDoneStatus() == true {
				shardConsumer.consume()
			} else {
				continue
			}
		}
		consumerWorker.cleanShardConsumer(heldShards)
		TimeToSleepInMillsecond(consumerWorker.client.option.DataFetchIntervalInMs, lastFetchTime, consumerWorker.workerShutDownFlag.Load())

	}
	level.Info(consumerWorker.Logger).Log("msg", "consumer worker try to cleanup consumers", "worker name", consumerWorker.client.option.ConsumerName)
	consumerWorker.shutDownAndWait()
}

func (consumerWorker *ConsumerWorker) shutDownAndWait() {
	for {
		time.Sleep(500 * time.Millisecond)
		count := 0
		consumerWorker.shardConsumer.Range(
			func(key, value interface{}) bool {
				count++
				consumer := value.(*ShardConsumerWorker)
				if !consumer.isShutDownComplete() {
					consumer.consumerShutDown()
				} else if consumer.isShutDownComplete() {
					consumerWorker.shardConsumer.Delete(key)
				}
				return true
			},
		)
		if count == 0 {
			break
		}
	}

}

func (consumerWorker *ConsumerWorker) getShardConsumer(shardId int) *ShardConsumerWorker {
	consumer, ok := consumerWorker.shardConsumer.Load(shardId)
	if ok {
		return consumer.(*ShardConsumerWorker)
	}
	consumerIns := initShardConsumerWorker(shardId, consumerWorker.client, consumerWorker.do, consumerWorker.Logger)
	consumerWorker.shardConsumer.Store(shardId, consumerIns)
	return consumerIns

}

func (consumerWorker *ConsumerWorker) cleanShardConsumer(owned_shards []int) {

	consumerWorker.shardConsumer.Range(
		func(key, value interface{}) bool {
			shard := key.(int)
			consumer := value.(*ShardConsumerWorker)

			if !Contain(shard, owned_shards) {
				level.Info(consumerWorker.Logger).Log("msg", "try to call shut down for unassigned consumer shard", "shardId", shard)
				consumer.consumerShutDown()
				level.Info(consumerWorker.Logger).Log("msg", "Complete call shut down for unassigned consumer shard", "shardId", shard)
			}

			if consumer.isShutDownComplete() {
				isDeleteShard := consumerWorker.consumerHeatBeat.removeHeartShard(shard)
				if isDeleteShard {
					level.Info(consumerWorker.Logger).Log("msg", "Remove an assigned consumer shard", "shardId", shard)
					consumerWorker.shardConsumer.Delete(shard)
				} else {
					level.Info(consumerWorker.Logger).Log("msg", "Remove an assigned consumer shard failed", "shardId", shard)
				}
			}
			return true
		},
	)
}

// This function is used to initialize the global log configuration
func logConfig(option LogHubConfig) log.Logger {
	var logger log.Logger

	if option.LogFileName == "" {
		if option.IsJsonType {
			logger = log.NewJSONLogger(log.NewSyncWriter(os.Stdout))
		} else {
			logger = log.NewLogfmtLogger(log.NewSyncWriter(os.Stdout))
		}
	} else {
		if option.IsJsonType {
			logger = log.NewLogfmtLogger(initLogFlusher(option))
		} else {
			logger = log.NewJSONLogger(initLogFlusher(option))
		}
	}
	switch option.AllowLogLevel {
	case "debug":
		logger = level.NewFilter(logger, level.AllowDebug())
	case "info":
		logger = level.NewFilter(logger, level.AllowInfo())
	case "warn":
		logger = level.NewFilter(logger, level.AllowWarn())
	case "error":
		logger = level.NewFilter(logger, level.AllowError())
	default:
		logger = level.NewFilter(logger, level.AllowInfo())
	}
	logger = log.With(logger, "time", log.DefaultTimestampUTC, "caller", log.DefaultCaller)
	return logger
}

func initLogFlusher(option LogHubConfig) *lumberjack.Logger {
	if option.LogMaxSize == 0 {
		option.LogMaxSize = 10
	}
	if option.LogMaxBackups == 0 {
		option.LogMaxBackups = 10
	}
	return &lumberjack.Logger{
		Filename:   option.LogFileName,
		MaxSize:    option.LogMaxSize,
		MaxBackups: option.LogMaxBackups,
		Compress:   option.LogCompass,
	}
}
