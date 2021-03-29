job "05-api-go" {
  datacenters = ["hashistack"]
  namespace = "msa"

  type = "service"

  group "front" {
    count = 1
    task "go" {
      driver = "raw_exec"
      env {
        GOPATH = "${NOMAD_TASK_DIR}/workspace"
        GOCACHE = "${NOMAD_TASK_DIR}/cache"
        APPPATH = "${NOMAD_TASK_DIR}/workspace/src/hello"
      }
      template {
data = <<EOF
#!/bin/sh
echo "***** start EVN *****"
mkdir -p ${APPPATH}
mkdir ./cache
cp ./local/front-api.go ${APPPATH}/
cd ${APPPATH}
echo "***** start go ****"
/usr/bin/go get
/usr/bin/go run front-api.go
EOF
        destination = "local/start.sh"
      }
      config {
        command = "local/start.sh"
      }
      artifact {
        source = "https://raw.githubusercontent.com/Great-Stone/various-workloads-on-nomad/master/front-api.go"
      }
      resources {
        network {
          port "http" {
            static = 8888
          }
        }
      }
      service {
        name = "msa-front-go"
        tags = ["go", "api"]

        check {
          type  = "tcp"
          interval = "10s"
          timeout  = "2s"
          port  = "http"
        }
      }
    }
  }
}
