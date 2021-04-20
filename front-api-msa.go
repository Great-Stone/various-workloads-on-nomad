package main

import (
    "net/http"
    "github.com/labstack/echo"
    b64 "encoding/base64"
    "bytes"
    "fmt"
)

func main() {
    e := echo.New()
    e.GET("/animal/:name", invokeFunc)
    e.Logger.Fatal(e.Start(":8888"))
}

func invokeFunc(c echo.Context) error{
    animal := c.Param("name")
    fmt.Println(animal)
	animal64 := b64.StdEncoding.EncodeToString([]byte(animal))
	
	var jsonStr = []byte(`{"Payload":"` + animal64 + `"}`)
    url := "http://172.28.128.11:4646/v1/job/04-parameterized-toUpper/dispatch?namespace=msa"
    req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonStr))
    req.Header.Set("Content-Type", "application/json")
    

    client := &http.Client{}
    resp, err := client.Do(req)
    if err != nil {
        panic(err)
    }
    defer resp.Body.Close()

    return err
}
