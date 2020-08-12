job "r2-mysql-v5-7-28" {
  datacenters = ["dc1"]

  type = "service"

  group "mysql-group" {
    count = 1

    volume "mysql-vol" {
      type = "host"
      read_only = false
      source = "mysql-vol"
    }

    task "mysql-task" {
      driver = "docker"

      volume_mount {
        volume = "mysql-vol"
        destination = "/var/lib/mysql"
        read_only = false
      }

      config {
        image = "mysql:5.7.28"
        port_map {
          db = 3306
        }
      }
      env {
        MYSQL_ROOT_PASSWORD = "rooooot"
      }
      resources {
        cpu = 500
        memory = 1024

        network {
          mbits = 10
          port "db" {
            static = 3306
          }
        }
      }

      service {
        tags = ["mysql", "db"]

        check {
          type  = "tcp"
          port  = "db"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
