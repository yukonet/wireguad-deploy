#!/usr/bin/python

import sys

client_name = str(sys.argv[1])


CLIENT_PRIV_KEY = ""
CLIENT_DNS_IP = "1.1.1.1, 1.0.0.1"
CLIENT_PRIV_IP = str(sys.argv[2])
SERVER_PUB_IP = "5.187.6.95"
SERVER_PUB_KEY = ""
ALLOWED_IP = "0.0.0.0/0"

f = open("/etc/wireguard/clients/" +  client_name + ".key", "r")
CLIENT_PRIV_KEY = f.read()
f.close()

f = open("/etc/wireguard/publickey", "r")
SERVER_PUB_KEY = f.read()
f.close()



config = "[Interface]\nPrivateKey = " + CLIENT_PRIV_KEY + "Address = " + CLIENT_PRIV_IP + "/24\nDNS = " + CLIENT_DNS_IP + "\n\n" + "[Peer]\nPublicKey = " + SERVER_PUB_KEY + "AllowedIPs = " + ALLOWED_IP + "\nEndpoint = " + SERVER_PUB_IP +":51820"

#print(config)

f = open("/etc/wireguard/clients/" +  client_name + ".conf", "w")
f.write(config)
f.close()

