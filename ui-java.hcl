job "r2-ui-java" {
  datacenters = ["dc1"]

  type = "service"

  group "ui-java" {
    count = 1

    task "ui-java" {
      driver = "java"
      env {
        MYSQL_HOST = "jdbc:mysql://172.28.128.4:3306/handson?useSSL=false"
      }
      artifact {
        source = "https://jar-tkaburagi.s3-ap-northeast-1.amazonaws.com/nomad-snapshots-r2-0.0.1-SNAPSHOT.jar"
      }
      config {
        jar_path    = "local/nomad-snapshots-r2-0.0.1-SNAPSHOT.jar"
        jvm_options = ["-Xmx1024m", "-Xms256m"]
      }
      resources {
        cpu    = 500
        // memory = 1000
        network {
          port "http" {
            static = 8080
          }
        }
      }
      service {
        tags = ["java", "ui"]

        check {
          type  = "http"
          interval = "10s"
          timeout  = "2s"
          path = "/"
          port  = "http"
        }
      }
    }
  }
}
