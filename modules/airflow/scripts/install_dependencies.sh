#!/bin/bash
#set -x

sudo dnf install -y gcc python3-devel openssl-devel rust mysql-shell
sudo dnf install -y python39 python39-pip
python3.9 -m pip install --upgrade pip
python3.9 -m pip install setuptools_rust
python3.9 -m pip install wheel
python3.9 -m pip install mysql-connector-python

mkdir ~${user}/.mysqlsh
cp /usr/share/mysqlsh/prompt/prompt_256pl+aw.json ~${user}/.mysqlsh/prompt.json
echo '{
    "history.autoSave": "true",
    "history.maxSize": "5000"
}' > ~${user}/.mysqlsh/options.json
chown -R ${user} ~${user}/.mysqlsh

adduser airflow -d /opt/airflow -m 

dnf remove -y python3-docutils python39-docutils

echo "Dependencies installed !"
