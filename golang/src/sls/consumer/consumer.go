package consumer

import (
	"fmt"
	"os"
	"os/signal"
	"syscall"

	sls "github.com/aliyun/aliyun-log-go-sdk"
	consumerLibrary "github.com/aliyun/aliyun-log-go-sdk/consumer"
	"github.com/go-kit/kit/log/level"

	"github.com/fortinet_alibaba/golang/src/sls/util"
)

// README :
// This is a very simple example of pulling data from your logstore and printing it for consumption.

func StartConsumer() {
	option := consumerLibrary.LogHubConfig{
		Endpoint:          util.Endpoint,
		AccessKeyID:       util.AccessKeyID,
		AccessKeySecret:   util.AccessKeySecret,
		Project:           util.ProjectName,
		Logstore:          util.LogStoreName,
		ConsumerGroupName: util.ConsumerGroupName,
		ConsumerName:      util.ConsumerName,
		// This options is used for initialization, will be ignored once consumer group is created and each shard has been started to be consumed.
		// Could be "begin", "end", "specific time format in time stamp", it's log receiving time.
		CursorPosition: consumerLibrary.END_CURSOR,
	}

	consumerWorker := consumerLibrary.InitConsumerWorker(option, process)
	ch := make(chan os.Signal)
	signal.Notify(ch, syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT, syscall.SIGUSR1, syscall.SIGUSR2)
	consumerWorker.Start()
	if _, ok := <-ch; ok {
		level.Info(consumerWorker.Logger).Log("msg", "get stop signal, start to stop consumer worker", "consumer worker name", option.ConsumerName)
		consumerWorker.StopAndWait()
	}
}

// Fill in your consumption logic here, and be careful not to change the parameters of the function and the return value,
// otherwise you will report errors.
func process(shardId int, logGroupList *sls.LogGroupList) string {
	fmt.Println(shardId, logGroupList)
	return ""
}
