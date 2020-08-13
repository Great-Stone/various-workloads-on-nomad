job "r2-ui-java" {
  datacenters = ["dc1"]

  type = "service"

  group "java-process" {
    count = 1

    task "ui" {
      driver = "java"
      config {
        jar_path    = "local/nomad-snapshots-r2-0.0.1-SNAPSHOT.jar"
        jvm_options = ["-Xmx2048m", "-Xms256m"]
      }
      resources {
        cpu    = 500
        memory = 500
        network {
          port "http" {
            static = 8080
          }
        }
      }
      env {
        MYSQL_HOST = "jdbc:mysql://172.28.128.4:3306/handson?useSSL=false"
      }
      service {
        name = "ui-java"
        tags = ["java", "ui", "check"]

        check {
          type  = "http"
          interval = "10s"
          timeout  = "2s"
          path = "/"
          port  = "http"
        }
      }
      logs {
        max_files     = 10
        max_file_size = 10
      }
      artifact {
        source = "https://jar-tkaburagi.s3-ap-northeast-1.amazonaws.com/nomad-snapshots-r2-0.0.1-SNAPSHOT.jar"
      }
    }
  }
}
