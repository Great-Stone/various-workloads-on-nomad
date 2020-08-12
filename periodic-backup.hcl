job "r2-periodic-backup" {
  datacenters = ["dc1"]
  type        = "batch"

  periodic {
    cron             = "*/20 * * * * * ?"
    prohibit_overlap = true
    time_zone        = "Asia/Seoul"
  }

  group "periodic-backup" {
    count = 1
    task "periodic-backup" {
      driver = "raw_exec"
      env {
        AWS_CONFIG_FILE = "/root/.aws/config"
      }
      template {
        data = <<EOH
#!/bin/sh
echo "**** check aws *****"
cat $AWS_CONFIG_FILE
cat $AWS_SHARED_CREDENTIALS_FILE
mkdir -p ./mysql-backup
finename=mysqldump-$(date "+%Y-%m-%d-%H-%M-%S").db
mysqldump -u root -prooooot -h 172.28.128.4 handson > ./mysql-backup/${finename}
/usr/local/bin/aws s3 cp ./mysql-backup/${finename} s3://gs-mysql-dump/
        EOH

        destination = "dump-mysql.sh"
      }
      config {
        command = "dump-mysql.sh"
      }
      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}
