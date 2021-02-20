#/bin/bash

# $1 - clients name (uniq) 
# $2 - clints private IP (without mask, uniq)
sudo mkdir -p /etc/wireguard/clients; wg genkey | sudo tee /etc/wireguard/clients/$1.key | wg pubkey | sudo tee /etc/wireguard/clients/$1.key.pub

python create_config.py $1 $2

qrencode -t ansiutf8 < /etc/wireguard/clients/$1.conf


pubkey=$(cat /etc/wireguard/clients/$1.key.pub)

wg set  peer $pubkey allowed-ips 10.0.0.10
