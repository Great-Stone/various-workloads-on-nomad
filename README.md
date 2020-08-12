![](demo-diagram.png )


## Set-up

* Create a S3 Bucket
* Replace `s3://mysql-dump-tkaburagi/` to your bucket name in the `dump-mysql.sh` and `init.sh`.
* Run Nomad on localhost
    * An example of [the server config](https://github.com/tkaburagi/nomad-configs/blob/master/nomad-local-config-server-cluster.hcl)
    * An example of [the client config](https://github.com/tkaburagi/nomad-configs/blob/master/nomad-local-config-client-1.hcl)
* Replace `172.20.10.4(for Docker MySQL IP)` to your network in all files.
* `watch -d -t -n 1 'echo Inside MySQL && mysql -h 172.20.10.4 -u root -D handson -e "select * from animals"'`
* Monitoring Terminals
    * `watch -t -d -n 1 'echo "Nomad Job Status" && nomad job status | rev | cut -c 26- | rev'`
    * `watch -d -t -n 1 'echo AWS S3 Bucket && aws s3 ls mysql-dump-tkaburagi  --region ap-northeast-1'`
    * `watch -d -t -n 1 'echo Inside MySQL && mysql -h 172.20.10.4 -u root -D handson -e "select * from animals"'`

## Demo
* `nomad job run mysql.hcl`
    * when the first time,
       * `mysql -h ${MYSQL_HOST} -u root -prooooot -D handson -e "drop table if exists animals"`
       * `mysql -h ${MYSQL_HOST} -u root -prooooot -D handson -e "create table animals (animal varchar(100));"`
* `nomad job run ui-java.hcl`
   * Open the browser. `http://127.0.0.1:8080/`
* `./insert-dog.sh`
* `nomad job run parameterized-toupper.hcl`
* `echo "cat" | nomad job dispatch r2-parameterized-toUpper -`
* `nomad job run front-api-go.hcl`
* `curl 127.0.0.1:8888/animal/pig`
* `nomad job run periodic-backup.hcl`
* `nomad job run periodic-curl.hcl`

## Clean-up
* `./init.sh`
