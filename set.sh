#!/bin/bash

apt update
apt install curl -y
apt install wireguard -y
apt install qrencode -y
#Create server keys
wg genkey | tee /etc/wireguard/server.priv | wg pubkey > /etc/wireguard/server.pub
#Create user keys
wg genkey | tee /etc/wireguard/client.priv | wg pubkey > /etc/wireguard/client.pub
#Create server config file
echo -e "[Interface]\nPrivateKey = server_private\nAddress = 10.0.0.1/24\nPostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE; echo 1 > /proc/sys/net/ipv4/ip_forward\nPostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ens3 -j MASQUERADE; echo 0 > /proc/sys/net/ipv4/ip_forward\nListenPort = 51820\n\n" > /etc/wireguard/wg0.conf
echo -e "[Peer]\nPublicKey = client_public\nAllowedIPs = 10.0.0.2/32" >> /etc/wireguard/wg0.conf
echo Enter name of WAN interface
read WAN
sleep 1
sed -i "s/ens3/$WAN/gi" /etc/wireguard/wg0.conf
SERVER_PRIV=`cat /etc/wireguard/server.priv`
sed -i "s|server_private|$SERVER_PRIV|gi" /etc/wireguard/wg0.conf
CLIENT_PUB=`cat /etc/wireguard/client.pub`
sed -i "s|client_public|$CLIENT_PUB|gi" /etc/wireguard/wg0.conf
#Create client config file
echo -e "[Interface]\nPrivateKey = client_private\nAddress = 10.0.0.2/32\nDNS = 1.1.1.1\n\n" > /etc/wireguard/client.conf
echo -e "[Peer]\nPublicKey = server_public\nAllowedIPs = 0.0.0.0/0\nEndpoint = my_ip:51820" >> /etc/wireguard/client.conf
MY_IP=`curl ifconfig.me`
SERVER_PUB=`cat /etc/wireguard/server.pub`
CLIENT_PRIV=`cat /etc/wireguard/client.priv`
sed -i "s|client_private|$CLIENT_PRIV|gi" /etc/wireguard/client.conf
sed -i "s|server_public|$SERVER_PUB|gi" /etc/wireguard/client.conf
sed -i "s/my_ip/$MY_IP/gi" /etc/wireguard/client.conf
#Generate QR-code
qrencode -t ansiutf8 < /etc/wireguard/client.conf
systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0
