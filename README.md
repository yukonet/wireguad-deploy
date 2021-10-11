# Wireguard setup scripts
These scripts helps with Wireguard software deploying.

## What these scripts do?
These scripts help with configuring small wireguard servers.
You should only download them and run and you will have ready VPN server.

## What the difference?
**shell-wg.sh** - it is the easiest way to setup Wireguard on the server for 1 user. Just download script, make it executable and run. 
After installation you will receive a QR-code wich you whould scan and your VPN connectin is ready.


**ansible-wg.yaml** - it is ansible playbook which will install and setup Wireguard, lightweight monitoring tool on the server, Web-UI from the repository (https://github.com/ngoduykhanh/wireguard-ui), and hide Web-UI behind NGINX with SSL and Basic-HTTP authorization. After installation you will have VPN server which allows easy create and administrate users from Web-UI admin panel.

## How to use?

You should have server with installed clear Ubuntu 20.04 OS on it.

#### **shell-wg.sh**

- Download the script:
``` wget https://raw.githubusercontent.com/yukonet/wireguad-deploy/35f05cc0d5baee8375b2486769bbf004998f0218/shell-wg.sh ```

- Make it executable:
```chmod +x shell-wg.sh```

- Check which interface you should use for outgoing connections
``` ip a```

- Run
```./shell-wg.sh```

At the end of installation you should receive a QR-code with user`s config file, just scan it with your Wireguard app.

#### **ansible-wg.yaml**

- Download the file:
``` wget https://raw.githubusercontent.com/yukonet/wireguad-deploy/35f05cc0d5baee8375b2486769bbf004998f0218/ansible-wg.yaml```

- Create new ansible hosts file with your server`s IP address(es):
```echo your_server_ip_address > hosts ```

- Check which interface you should use for outgoing connections (run command on the remote VPN server)
```ip a```

- Copy you public SSH key to the remote server:
```ssh-copy-id root@your_server_ip_address```

- Run the script:
```ansible-playbook ansible-wg.yaml -i hosts```

- Paste your interface name and directory (or just use default if it suits for you) when script will ask.
