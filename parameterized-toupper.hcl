job "r2-parameterized-toUpper" {
  datacenters = ["dc1"]

  type = "batch"

  parameterized {
    payload = "optional"
  }

  group "parameterized-toUpper" {
    count = 1
    task "toUpper" {
      driver = "raw_exec"
      template {
        data = <<EOH
#!/bin/sh
#create table animals (animal varchar(100));
animal=$(echo $(cat local/payload.txt) | tr '[:lower:]' '[:upper:]')
sleep 10
mysql -h 172.28.128.4 -u root -prooooot -D handson -e "insert into animals values (\""${animal}"\")"
        EOH

        destination = "/home/vagrant/batch/func.sh"
      }
      config {
        command = "/home/vagrant/batch/func.sh"
      }
      dispatch_payload {
        file = "payload.txt"
      }
      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
