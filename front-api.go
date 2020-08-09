package main

import (
    "net/http"
    // "github.com/labstack/echo"
    b64 "encoding/base64"
    "bytes"
)

func main() {
    e := echo.New()
    e.GET("/animal/:name", invokeFunc)
    e.Logger.Fatal(e.Start(":8888"))
}

func invokeFunc(c echo.Context) error{
	animal := c.Param("name")
	animal64 := b64.StdEncoding.EncodeToString([]byte(animal))
	
	var jsonStr = []byte(`{"Payload":"` + animal64 + `"}`)
	url := "http://127.0.0.1:4646/v1/job/r2-parameterized-toUpper/dispatch"
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
