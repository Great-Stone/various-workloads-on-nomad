#! /bin/bash

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y \
    unzip \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    openjdk-11-jdk \
    mysql-client \
    golang-go \
    ufw

sudo ufw allow 22
sudo ufw allow 3306
sudo ufw allow 8502
sudo ufw allow 8080
sudo ufw allow 8888
sudo ufw allow 4646
sudo ufw allow 4647
sudo ufw allow 4648
sudo ufw allow 8500
sudo ufw allow 8301
sudo ufw allow 8300
sudo ufw --force enable

sudo echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
sudo echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
sudo echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf

sudo sysctl -p

echo "*****    Install AWS     *****"
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install

echo "*****    Install Docker     *****"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

echo "*****    Download Consul on ARM    *****"
export version=1.8.2
# if [ ! -f /usr/local/bin/consul ]; then
if consul version | grep ${version} > /dev/null; then
    consul version
else
    cd /tmp
    wget https://releases.hashicorp.com/consul/${version}/consul_${version}_linux_amd64.zip
    unzip consul_${version}_linux_amd64.zip
    sudo mv consul /usr/local/bin/
    consul -v
fi

echo "*****    Install Consul on ARM    *****"
sudo groupadd --system consul
sudo useradd -s /sbin/nologin --system -g consul consul

sudo mkdir -p /var/lib/consul
sudo chown -R consul:consul /var/lib/consul
sudo chmod -R 775 /var/lib/consul

sudo mkdir /etc/consul.d
sudo chown -R consul:consul /etc/consul.d

echo "*****    Create and run consul service   *****"
#kill -9 `ps -ef | grep 'consul' | awk '{print $2}'`
sudo systemctl stop consul
sudo bash -c 'rm -rf /etc/systemd/system/consul.service'
cat << "EOF" | sudo tee -a /etc/systemd/system/consul.service
[Unit]
Description=Consul Service Discovery Agent
Documentation=https://www.consul.io/
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=consul
Group=consul
ExecStart=/usr/local/bin/consul agent \
	-datacenter=dc1 \
    -node=client \
    -client=0.0.0.0 \
    -bind=172.28.128.4 \
    -encrypt=h65lqS3w4x42KP+n4Hn9RtK84Rx7zP3WSahZSyD5i1o= \
	-data-dir=/var/lib/consul \
	-config-dir=/etc/consul.d \
	-retry-join=172.28.128.3 \
    -grpc-port=8502

ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT
TimeoutStopSec=5
Restart=on-failure
SyslogIdentifier=consul

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable consul
sudo systemctl start consul

echo "*****    Nomad    *****"
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update

sudo apt-get install nomad -y
sudo systemctl unmask nomad
sudo systemctl enable nomad

sudo mv /tmp/nomad.d/* /etc/nomad.d/
sudo mkdir -p /home/vagrant/mysql
sudo systemctl restart nomad