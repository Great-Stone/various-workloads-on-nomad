data_dir = "/var/lib/nomad"

bind_addr = "0.0.0.0"

consul {
  address = "127.0.0.1:8500"
}

server {
  enabled          = true
  bootstrap_expect = 1
}

advertise {
  http = "172.28.128.3"
  rpc  = "172.28.128.3"
  serf = "172.28.128.3"
}