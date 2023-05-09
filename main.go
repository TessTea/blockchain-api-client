package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/TessTea/blockchain-api-client/config"
)

// const (
// 	host = "https://polygon-rpc.com/"
// )

type Request struct {
	Jsonrpc string        `json:"jsonrpc"`
	Method  string        `json:"method"`
	Params  []interface{} `json:"params,omitempty"`
	ID      int           `json:"id"`
}

func main() {

	config.LoadConfigs("./config.yml")

	currentConfig := config.GetConfigs()
	polygonUrl := currentConfig.Polygon.Url
	appHost := currentConfig.App.Host
	appPort := currentConfig.App.Port

	fmt.Println(currentConfig.Polygon.Url)

	r := gin.Default()

	r.GET("/block/number", func(c *gin.Context) {
		blockNumberRequest := Request{
			Jsonrpc: "2.0",
			Method:  "eth_blockNumber",
			ID:      2,
		}
		blockNumber, err := sendRequest(blockNumberRequest, polygonUrl)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Error getting block number"})
			return
		}
		c.JSON(http.StatusOK, gin.H{"blockNumber": blockNumber})
	})

	r.GET("/block/:number", func(c *gin.Context) {
		blockNumber := c.Param("number")
		blockByNumberRequest := Request{
			Jsonrpc: "2.0",
			Method:  "eth_getBlockByNumber",
			Params:  []interface{}{blockNumber, true},
			ID:      2,
		}
		block, err := sendRequest(blockByNumberRequest, polygonUrl)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Error getting block by number"})
			return
		}
		c.JSON(http.StatusOK, gin.H{"block": block})
	})

	r.Run(fmt.Sprintf("%v:%v", appHost, appPort))
}

func sendRequest(request Request, host string) (interface{}, error) {
	requestBody, err := json.Marshal(request)
	if err != nil {
		return nil, err
	}

	resp, err := http.Post(host, "application/json", bytes.NewBuffer(requestBody))
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	var jsonResponse map[string]interface{}
	err = json.Unmarshal(body, &jsonResponse)
	if err != nil {
		return nil, err
	}

	return jsonResponse["result"], nil
}
