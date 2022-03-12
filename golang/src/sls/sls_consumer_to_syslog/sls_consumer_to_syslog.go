package main

import (
	"fmt"
	"os"
	"os/signal"
	"syscall"
	"log/syslog"
	"regexp"
	sls "github.com/aliyun/aliyun-log-go-sdk"
	consumerLibrary "github.com/aliyun/aliyun-log-go-sdk/consumer"
	"github.com/go-kit/kit/log/level"
)

// README :
// This is a very simple example of pulling data from your logstore and send to syslog server localhost:10514

func main() {
	option := consumerLibrary.LogHubConfig{
		Endpoint:         os.Getenv("SLS_ENDPOINT"),
		AccessKeyID:      os.Getenv("SLS_AK_ID") ,
		AccessKeySecret:  os.Getenv("SLS_AK_KEY") ,
		Project:          os.Getenv("SLS_PROJECT"),
		Logstore:         os.Getenv("SLS_LOGSTORE"),
		ConsumerGroupName: os.Getenv("SLS_CG"),
		ConsumerName:     os.Getenv("SLS_ConsumerName"),
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
	syslogProtocol:=os.Getenv("SYSLOG_PROTOCOL")
	syslogHostPort:=os.Getenv("SYSLOG_SERVER_PORT")
	searchString :=os.Getenv("SYSLOG_SEARCH_STRING")
	if searchString == "" {
		searchString ="."
	}
	sysLog, err :=syslog.Dial(syslogProtocol,syslogHostPort,
		syslog.LOG_WARNING|syslog.LOG_DAEMON, "demoslssyslog")
	if err  !=nil {
		fmt.Println(err)
	}
	for _,logGroup := range logGroupList.LogGroups {
		for _,log := range logGroup.Logs {
			for _,content := range log.Contents {
				if *content.Key=="content" {
					regexp,_ := regexp.Compile(searchString)
					value:=regexp.FindString(*content.Value)
					if value !="" {
					fmt.Fprintf(sysLog,"%v:%v",shardId,*content.Value)
					}
				}
			}
		}
	}
	return ""
}

func init() {
  fmt.Println(
`
PLEASE SET BELOW ENVIROMENT VARIBLE FIRST
----------------------------------
project_name="YOURPROJECTNAME"
logstore_name="YOURLOGSTORENAME"
consumer_group="YOURCONSUMER_GROUPNAME"
export SLS_ENDPOINT=YOURENDPINT
export SLS_AK_ID=$(grep access-id ~/.aliyunlogcli | cut -d ' ' -f 3)
export SLS_AK_KEY=$(grep access-key ~/.aliyunlogcli | cut -d ' ' -f 3)
export SLS_PROJECT=$project_name
export SLS_LOGSTORE=$logstore_name
export SLS_CG=$consumer_group
export SLS_ConsumerName=$consumer_group
export SYSLOG_PROTOCOL=udp
export SYSLOG_SERVER_PORT=localhost:10514
export SYSLOG_SEARCH_STRING="."	`)
}
