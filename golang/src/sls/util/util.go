package util

import (
	sls "github.com/aliyun/aliyun-log-go-sdk"
	"os"
)

// When you use the file under example, please configure the required variables here.
// Project define Project for test
var (
	ProjectName     = os.Getenv("SLS_PROJECT")
	Endpoint        = os.Getenv("SLS_ENDPOINT")
	LogStoreName    = os.Getenv("SLS_LOGSTORE")
	AccessKeyID     = os.Getenv("SLS_AK_ID")
	AccessKeySecret = os.Getenv("SLS_AK_KEY")
	Client          sls.ClientInterface
)

// You can get the variable from the environment variable, or fill in the required configuration directly in the init function.
func init() {
	ProjectName = os.Getenv("SLS_PROJECT")
	AccessKeyID = os.Getenv("SLS_AK_ID")
	AccessKeySecret = os.Getenv("SLS_AK_KEY")
	Endpoint = os.Getenv("SLS_ENDPOINT") // just like cn-hangzhou.log.aliyuncs.com
	LogStoreName =os.Getenv("SLS_LOGSTORE") 

	Client = sls.CreateNormalInterface(Endpoint, AccessKeyID, AccessKeySecret, "")
}
