#!/bin/bash

# Ausgabe nach stdout während der Skriptausführung.
set -xv

SSH=$PWD/../openssh-portable-ncot/build/bin/ssh
SSHD=$PWD/../openssh-portable-ncot/build/sbin/sshd
SSHKEYGEN=$PWD/../openssh-portable-ncot/build/bin/ssh-keygen

if [ ! -e "node01/.ssh/id_ed25519" ]
then
    $SSHKEYGEN -t ed25519 -f node01/.ssh/id_ed25519 -N ''
    cat node01/.ssh/id_ed25519.pub > node02/.ssh/authorized_keys
    echo "Port 12001" > node01/.ssh/sshd_config
    echo "PidFile $PWD/node01/.ssh/sshd.pid" >> node01/.ssh/sshd_config
    echo "AuthorizedKeysFile $PWD/node01/.ssh/authorized_keys" >> node01/.ssh/sshd_config
fi
if [ ! -e "node02/.ssh/id_ed25519" ]
then
    $SSHKEYGEN -t ed25519 -f node02/.ssh/id_ed25519 -N ''
    cat node02/.ssh/id_ed25519.pub > node03/.ssh/authorized_keys
    echo "Port 12002" > node02/.ssh/sshd_config
    echo "PidFile $PWD/node02/.ssh/sshd.pid" >> node02/.ssh/sshd_config
    echo "AuthorizedKeysFile $PWD/node02/.ssh/authorized_keys" >> node02/.ssh/sshd_config
fi
if [ ! -e "node03/.ssh/id_ed25519" ]
then
    $SSHKEYGEN -t ed25519 -f node03/.ssh/id_ed25519 -N ''
    cat node03/.ssh/id_ed25519.pub > node01/.ssh/authorized_keys
    echo "Port 12003" > node03/.ssh/sshd_config
    echo "PidFile $PWD/node03/.ssh/sshd.pid" >> node03/.ssh/sshd_config
    echo "AuthorizedKeysFile $PWD/node03/.ssh/authorized_keys" >> node03/.ssh/sshd_config
fi

# Knoten mit sshd starten.
$SSHD -f node01/.ssh/sshd_config -h $PWD/node01/.ssh/id_ed25519
$SSHD -f node02/.ssh/sshd_config -h $PWD/node02/.ssh/id_ed25519
$SSHD -f node03/.ssh/sshd_config -h $PWD/node03/.ssh/id_ed25519

sleep 1

pkill -F node01/.ssh/sshd.pid
pkill -F node02/.ssh/sshd.pid
pkill -F node03/.ssh/sshd.pid
