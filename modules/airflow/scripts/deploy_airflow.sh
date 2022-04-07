#!/bin/bash
#set -x

export AIRFLOW_HOME=/opt/airflow
export AIRFLOW__CORE__SQL_ALCHEMY_CONN="mysql+mysqlconnector://${airflow_name}:${airflow_password}@${mds_ip}/${airflow_database}"
export AIRFLOW__CORE__SQL_ALCHEMY_SCHEMA="${airflow_database}"

/usr/local/bin/airflow db init

/usr/local/bin/airflow users  create --role Admin --username ${airflow_admin} --email ${airflow_email} --firstname Admin --lastname Admin --password '${airflow_admin_password}'


echo "Airflow Database Initialized and Admin user created !"
