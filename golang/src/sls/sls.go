package main

import (
	"fmt"

	"github.com/fortinet_alibaba/golang/src/sls/util"
	"github.com/fortinet_alibaba/golang/src/sls/project"
	"github.com/fortinet_alibaba/golang/src/sls/logstore"
)

func main() {
	fmt.Println(util.Client)
	project.CreateProject()
	logstore.CreateLogStore()
}
