#!/bin/bash
# CentOS Network Configuration Script
sudo nmcli device modify ens33 ipv4.addresses 172.22.218.51/24
sudo nmcli device modify ens33 ipv4.gateway 172.22.218.2
sudo nmcli device modify ens33 ipv4.dns 172.22.218.10
sudo nmcli device modify ens33 ipv4.method manual
sudo nmcli device up ens33
echo "Network configured successfully!"
