output "ssh_private_key" {
  value = local.private_key_to_show
  sensitive = true
}

output "airflow_public_ip" {
  value = module.airflow.public_ip
}

output "airflow_db_user" {
  value = var.airflow_name
}

output "airflow_db_password" {
  value = var.airflow_password
  sensitive = true
}

output "airflow_admin" {
  value = module.airflow.airflow_admin
}

output "airflow_admin_pass" {
  value = module.airflow.airflow_admin_pass
  sensitive = true
}

output "mds_instance_ip" {
  value = module.mds-instance.private_ip
}

output "airflow_url" {
   value = join("", ["http://", module.airflow.public_ip, ":8080"])
}
