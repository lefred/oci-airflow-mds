#!/bin/bash
#set -x

dnf reinstall -y python39-six
dnf reinstall -y python3-six
dnf install -y oci-utils

firewall-cmd --zone=public --permanent --add-port=8080/tcp
firewall-cmd --reload

mkdir /var/run/airflow
chown airflow /var/run/airflow
chown -R airflow /opt/airflow


systemctl daemon-reload
systemctl start airflow-webserver.service
systemctl start airflow-scheduler.service
systemctl enable airflow-webserver.service
systemctl enable airflow-scheduler.service
sed -i  's/executor = SequentialExecutor/executor = LocalExecutor/' /opt/airflow/airflow.cfg
systemctl restart airflow-scheduler.service
systemctl restart airflow-webserver.service


echo "Local Security Granted !"
