#!/bin/bash

# Ausgabe nach stdout während der Skriptausführung.
set -xv

SSHD=/home/tdkuehnel/Projekte/src/openssh-portable-opt/sbin/sshd
SSHKEYGEN=/home/tdkuehnel/Projekte/src/openssh-portable-opt/bin/ssh-keygen

if [ ! -e "node01/.ssh/id_ed25519" ]
then
    $SSHKEYGEN -t ed25519 -f node01/.ssh/id_ed25519 -N ''
    cat node01/.ssh/id_ed25519.pub > node02/.ssh/authorized_keys
    echo "Port 12001" > node01/.ssh/sshd_config
    echo "AuthorizedKeysFile $PWD/node01/.ssh/authorized_keys" >> node01/.ssh/sshd_config
fi
if [ ! -e "node02/.ssh/id_ed25519" ]
then
    $SSHKEYGEN -t ed25519 -f node02/.ssh/id_ed25519 -N ''
    cat node02/.ssh/id_ed25519.pub > node03/.ssh/authorized_keys
    echo "Port 12002" > node02/.ssh/sshd_config
    echo "AuthorizedKeysFile $PWD/node02/.ssh/authorized_keys" >> node01/.ssh/sshd_config
fi
if [ ! -e "node03/.ssh/id_ed25519" ]
then
    $SSHKEYGEN -t ed25519 -f node03/.ssh/id_ed25519 -N ''
    cat node03/.ssh/id_ed25519.pub > node01/.ssh/authorized_keys
    echo "Port 12003" > node03/.ssh/sshd_config
    echo "AuthorizedKeysFile $PWD/node03/.ssh/authorized_keys" >> node01/.ssh/sshd_config
fi

# Knoten mit sshd starten.
$SSHD -f node01/.ssh/sshd_config -d -h $PWD/node01/.ssh/id_ed25519
