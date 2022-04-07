#!/bin/bash



mysqlsh --user ${admin_username} --password=${admin_password} --host ${mds_ip} --sql -e "CREATE DATABASE ${airflow_database};"
mysqlsh --user ${admin_username} --password=${admin_password} --host ${mds_ip} --sql -e "CREATE USER ${airflow_name} identified by '${airflow_password}';"
mysqlsh --user ${admin_username} --password=${admin_password} --host ${mds_ip} --sql -e "GRANT ALL PRIVILEGES ON ${airflow_database}.* TO ${airflow_name};"


cat <<EOT >> /etc/sysconfig/airflow
AIRFLOW_HOME=/opt/airflow
AIRFLOW__CORE__SQL_ALCHEMY_CONN="mysql+mysqlconnector://${airflow_name}:${airflow_password}@${mds_ip}/${airflow_database}"
AIRFLOW__CORE__SQL_ALCHEMY_SCHEMA="${airflow_database}"
EOT

echo "Airflow MDS User created !"


