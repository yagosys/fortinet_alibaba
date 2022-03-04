package main

import (
	"io/ioutil"
	"log"
	"net/http"
	"fmt"
	"os"
	"net/url"
	"time"
)

func main() {

	//creating the proxyURL
	//proxyStr := "http://119.3.33.95:6007"
	if os.Getenv("http_proxy") =="" || os.Getenv("url")=="" {
		panic("no http_proxy or url env , pleaset set both http_proxy and url")
	}
	proxyStr:=os.Getenv("http_proxy")
	fmt.Println("using proxy %s",proxyStr)
	proxyURL, err := url.Parse(proxyStr)
	if err != nil {
		log.Println(err)
	}

	//creating the URL to be loaded through the proxy
	//urlStr := "http://httpbin.org/get"
	urlStr := os.Getenv("url")
	fmt.Println("try to retrive information from url",urlStr)
	url, err := url.Parse(urlStr)
	if err != nil {
		log.Println(err)
	}

	//adding the proxy settings to the Transport object
	transport := &http.Transport{
		Proxy: http.ProxyURL(proxyURL),
	}

	//adding the Transport object to the http Client
	client := &http.Client{
		Transport: transport,
	}

	//generating the HTTP GET request
	t1 :=time.Now()
	request, err := http.NewRequest("GET", url.String(), nil)
	if err != nil {
		log.Println(err)
	}

	//calling the URL
	response, err := client.Do(request)
	if err != nil {
		log.Println(err)
	}

	//getting the response
	data, err := ioutil.ReadAll(response.Body)
	if err != nil {
		log.Println(err)
	}
	t2 :=time.Now()
	//printing the response
	log.Println(string(data))
	log.Println((t1.UnixNano()/1000000))
	log.Println((t2.UnixNano()/1000000))
	log.Println("the time took to fetch this url")
	log.Println(t2.UnixNano()/1000000-t1.UnixNano()/1000000)
}
