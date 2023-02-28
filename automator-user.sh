#!/bin/bash

function generateKeys {
    ssh-keygen -t rsa -b 2048 -C automator -f $1 -N ""
}

SERVER=$1
echo $SERVER
if [ -z "$SERVER" ];then
    echo "Server $SERVER for create user @automator isn't specify";
    exit 0;
fi


KEY=$2
if [ -z "$KEY" ];then
    echo "Private key path for user \"automator\" not specifyied, Creating new pair in current directory ";
    KEY=./automator
    generateKeys $KEY
    KEY="$KEY"
fi

if [ ! -f "$KEY" ];then
    echo "Private key isn't exists, generate new in specified path"
    generateKeys $KEY
fi

PUBLIC_KEY=`cat $KEY.pub`

echo "Try to connect $SERVER"
ssh $SERVER "useradd -m -G sudo automator && su -c \"mkdir -p ~/.ssh && chown -R automator:automator ~/.ssh && chmod 700 ~/.ssh && echo $PUBLIC_KEY > ~/.ssh/authorized_keys\" automator || userdel automator"
echo "All done!"
