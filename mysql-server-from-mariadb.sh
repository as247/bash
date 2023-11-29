#!/bin/bash
sudo apt purge mariadb-*
sudo apt purge mysql-*
sudo rm -r /usr/share/mysql/
sudo rm -r /etc/mysql/
sudo rm -r /lib/systemd/system/mysql.service
sudo apt install mysql-server
