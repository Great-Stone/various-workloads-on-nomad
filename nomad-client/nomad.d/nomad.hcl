name = "node01"
datacenter = "dc1"
data_dir = "/var/lib/nomad"

bind_addr = "0.0.0.0"

consul {
  address = "127.0.0.1:8500"
}

client {
  enabled = true
  servers = ["172.28.128.3:4647"]
  network_interface = "eth1"
  host_volume "mysql-vol" {
    path = "/home/vagrant/mysql"
    read_only = false
  }
  meta {
    "Name" = "client-1"
  }
  options = {
    "driver.raw_exec.enable" = "1"
  }
  chroot_env {
    "/root/.aws" = "/root/.aws"
  }
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}

advertise {
  http = "172.28.128.4:4646"
  rpc  = "172.28.128.4:4647"
  serf = "172.28.128.4:4648"
}