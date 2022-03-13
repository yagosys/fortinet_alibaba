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
	if (os.Getenv("SLS_AK_ID") =="") || (os.Getenv("SLS_AK_KEY") == "") || (os.Getenv("SLS_PROJECT") == "") || (os.Getenv("SLS_LOGSTORE") =="") || (os.Getenv("SLS_CG") =="") || (os.Getenv("SYSLOG_PROTOCOL")=="") || (os.Getenv("SYSLOG_SERVER_PORT") == "")  {
		printUsage()
		return
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
	} else {
		fmt.Sprintf("SYSLOG SERVER %v Connected with Protocol %v", syslogHostPort,syslogProtocol)
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

func printUsage() {
  fmt.Println(
`
Usage: 
----------------------------------
export SLS_ENDPOINT=YOURENDPINT
export SLS_AK_ID="your AK id on alibaba cloud"
export SLS_AK_KEY="your AK key on alibaba cloud"
export SLS_PROJECT="your project name"
export SLS_LOGSTORE="your log store name"
export SLS_CG="your consumer group name"
export SLS_ConsumerName="your consumer name"
export SYSLOG_PROTOCOL="udp or tcp"
export SYSLOG_SERVER_PORT="your server IP/hostbname and port , eg localhost:10514"
export SYSLOG_SEARCH_STRING="."	`)
}
