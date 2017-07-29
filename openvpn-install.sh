#!/usr/bin/env bash
HERE=$(cd $(dirname $0) ; pwd)

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <public_ip> <ssh_key.sh>"
  exit 1
fi
set -e
remote_host=$1
ssh_key_path=$2

echo "Transferring the script to the remote server..."
scp -i ${ssh_key_path} -r $HERE/remote.sh ${remote_host}:/tmp

echo "Executing the script on the remote server..."
ssh -i ${ssh_key_path} -t -t  ${remote_host} "sudo bash /tmp/remote.sh"

echo "Downloading the client setting/security files..."
scp -i ${ssh_key_path} -r ${remote_host}:'/tmp/client_files/*' $HERE/

echo "All Done! Now use $HERE/client.conf to configure your OpenVPN Client."
