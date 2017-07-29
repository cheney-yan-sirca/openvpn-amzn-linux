#!/usr/bin/env bash
yum install -y openvpn-2.4.3 git
rm -rf /tmp/easy-rsa
git clone https://github.com/OpenVPN/easy-rsa /tmp/easy-rsa
cp -r /tmp/easy-rsa/easyrsa3 /etc/openvpn/easy-rsa
open_vpn_doco_path=$(find /usr/share/doc -maxdepth 1 -name 'openvpn*' -type d |xargs)
cp $open_vpn_doco_path/sample/sample-config-files/server.conf /etc/openvpn/

# This script does not matter much!
cat > /etc/openvpn/easy-rsa/vars <<EOF
export KEY_COUNTRY="US"
export KEY_PROVINCE="NY"
export KEY_CITY="New York"
export KEY_ORG="Organization Name"
export KEY_EMAIL="administrator@example.com"
export KEY_CN=cn.example.com
export KEY_NAME=server
export KEY_OU=server
EOF

cd /etc/openvpn/easy-rsa
./easyrsa --batch init-pki
./easyrsa --batch build-ca nopass
./easyrsa --batch gen-dh
./easyrsa --batch build-server-full server nopass
./easyrsa --batch build-client-full client nopass # the only one client named "client"

cp pki/ca.crt pki/private/ca.key pki/dh.pem pki/issued/server.crt pki/private/server.key  /etc/openvpn
# Generate key for tls-auth
openvpn --genkey --secret /etc/openvpn/ta.key

cat > /etc/openvpn/server.conf <<EOF
port 1194
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key  # This file should be kept secret
ifconfig-pool-persist ipp.txt
keepalive 10 120
tls-auth ta.key 0 # This file is secret
cipher AES-256-CBC
persist-key
persist-tun
status openvpn-status.log
verb 3
explicit-exit-notify 1
server 10.8.0.0 255.255.255.0
dh dh.pem
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
user nobody
group nobody
EOF

service openvpn restart
rm -rf /tmp/client_files
mkdir /tmp/client_files
server_ip=$(curl ifconfig.co)
cd /etc/openvpn/easy-rsa
cp pki/ca.crt pki/issued/client.crt pki/private/client.key $open_vpn_doco_path/sample/sample-config-files/client.conf /etc/openvpn/ta.key /tmp/client_files
sed -i "s/remote my-server-1 /remote ${server_ip} /" /tmp/client_files/client.conf
chown -R ec2-user /tmp/client_files