#!/bin/bash
#set -x

export AIRFLOW_HOME=/opt/airflow
AIRFLOW_VERSION=${airflow_version}
PYTHON_VERSION="$(python --version | cut -d " " -f 2 | cut -d "." -f 1-2)"
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${airflow_version}/constraints-$PYTHON_VERSION.txt"
python3 -m pip install "apache-airflow==${airflow_version}" --constraint "$CONSTRAINT_URL"


cat <<EOT1 >> /etc/systemd/system/airflow-webserver.service
[Unit]
Description=Airflow webserver daemon
After=network.target

[Service]
EnvironmentFile=/etc/sysconfig/airflow
User=airflow
Group=airflow
Type=simple
ExecStart=/usr/local/bin/airflow webserver --pid /var/run/airflow/airflow-webserver.pid
Restart=on-failure
RestartSec=5s
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOT1

cat <<EOT2 >> /etc/systemd/system/airflow-scheduler.service
[Unit]
Description=Airflow webserver daemon
After=network.target

[Service]
EnvironmentFile=/etc/sysconfig/airflow
User=airflow
Group=airflow
Type=simple
ExecStart=/usr/local/bin/airflow scheduler 
Restart=always
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOT2

echo "Airflow ${airflow_version} Installed !"
