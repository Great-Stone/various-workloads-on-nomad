#!/bin/sh
mkdir -p /home/vagrant/mysql-backup
finename=mysqldump-$(date "+%Y-%m-%d-%H-%M-%S").db
mysqldump -u root -prooooot -h 172.28.128.4 handson > /home/vagrant/mysql-backup/${finename}
aws s3 cp /home/vagrant/mysql-backup/${finename} s3://gs-mysql-dump/ --acl public-read
