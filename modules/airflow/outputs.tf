output "id" {
  value = oci_core_instance.Airflow.id
}

output "public_ip" {
  value = oci_core_instance.Airflow.public_ip
}


output "airflow_admin" {
  value = var.airflow_admin
}

output "airflow_admin_pass" {
  value = var.airflow_admin_pass
}

