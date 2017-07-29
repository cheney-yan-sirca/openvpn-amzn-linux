# Purpose

The purpose of this project is to create a one-button script to construct a OpenVPN server on Amazon Linux for personal use.

For other platforms, you may want to use [script for ubuntu/debian/centos](https://github.com/Nyr/openvpn-install)

# Prerequisite

* You have already got an Amazon EC2 instance running, assuming the IP is `<SERVER_IP>`
* You have setup the security group of the EC2 instance correctly
  * `TCP port 22 `is open to your desktop (where this script will run)
  * `OpenVPN port UDP 1194` is open to 0.0.0.0 (OpenVPN service will be open to all Internet), or open to your desktop's public ip if you want the server to be accessible to you only.
  * You have the key file (ssh-key.pem) used to login to the EC2 instance. Assuming the key file path is `</path/to/key.pem>`
# Server Installation

Run the script and follow the assistant:

```bash
git clone $$$TODO### && cd openvpn-amzn-linux && bash openvpn-install.sh <SERVER_IP> </path/to/key.pem>
```  

# Client setup
Your client setup file will be under `openvpn-amzn-linux` directory.
I am using [tunnelblick](https://www.tunnelblick.net/). It is just a matter of dragging the client.conf file to the client window.


# Customization

This script is hard coded to use UDP 1194 only. Go ahead to modify the script so it can be customized. Create PR if you like this project and want to improve it.

# Donation

If I have saved your time so you can sit and enjoy a coffee, don't bother buy me one, too!  [PayPal](#TODO)