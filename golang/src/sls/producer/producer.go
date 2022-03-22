package producer

import (
	"fmt"
	"os"
	"os/signal"
	"sync"
	"time"

	"github.com/fortinet_alibaba/golang/src/sls/util"
	"github.com/aliyun/aliyun-log-go-sdk/producer"
)

func ProduceLog() {
	producerConfig := producer.GetDefaultProducerConfig()
	producerConfig.Endpoint = util.Endpoint
	producerConfig.AccessKeyID = util.AccessKeyID
	producerConfig.AccessKeySecret = util.AccessKeySecret
	producerInstance := producer.InitProducer(producerConfig)
	var project=util.ProjectName
	var logstore=util.LogStoreName
	ch := make(chan os.Signal)
	signal.Notify(ch, os.Kill, os.Interrupt)
	producerInstance.Start()
	var m sync.WaitGroup
	for i := 0; i < 10; i++ {
		m.Add(1)
		go func() {
			defer m.Done()
			for i := 0; i < 1000; i++ {
				// GenerateLog  is producer's function for generating SLS format logs
				// GenerateLog has low performance, and native Log interface is the best choice for high performance.
				log := producer.GenerateLog(uint32(time.Now().Unix()), map[string]string{"content": "test", "content2": fmt.Sprintf("%v", i)})
				err := producerInstance.SendLog(project, logstore, "topic", "127.0.0.1", log)
				if err != nil {
					fmt.Println(err)
				}
			}
		}()
	}
	m.Wait()
	fmt.Println("Send completion")
	if _, ok := <-ch; ok {
		fmt.Println("Get the shutdown signal and start to shut down")
		producerInstance.Close(60000)
	}
}
