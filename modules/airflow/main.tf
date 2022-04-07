## DATASOURCE
# Init Script Files

locals {
  dependencies_script    = "~/install_dependencies.sh"
  airflow_install_script = "~/install_airflow.sh"
  security_script        = "~/configure_local_security.sh"
  create_airflow_db      = "~/create_airflow_db.sh"
  airflow_deploy_script  = "~/deploy_airflow.sh"
  fault_domains_per_ad   = 3
}


data "template_file" "install_dependencies" {
  template = file("${path.module}/scripts/install_dependencies.sh")
  vars = {
    user                  = var.vm_user
  }
}

data "template_file" "install_airflow" {
  template = file("${path.module}/scripts/install_airflow.sh")
  vars = {
    airflow_version       = var.airflow_version,
    user                  = var.vm_user
  }
}

data "template_file" "deploy_airflow" {
  template = file("${path.module}/scripts/deploy_airflow.sh")

  vars = {
    airflow_admin_password = var.airflow_admin_pass
    airflow_admin          = var.airflow_admin
    airflow_email          = var.airflow_email
    mds_ip                 = var.mds_ip
    airflow_name           = var.airflow_name
    airflow_database       = var.airflow_database
    airflow_password       = var.airflow_password
  }
}

data "template_file" "configure_local_security" {
  template = file("${path.module}/scripts/configure_local_security.sh")
}

data "template_file" "create_airflow_db" {
  template = file("${path.module}/scripts/create_airflow_db.sh")
  vars = {
    admin_password      = var.admin_password
    admin_username      = var.admin_username
    airflow_password    = var.airflow_password
    mds_ip              = var.mds_ip
    airflow_name        = var.airflow_name
    airflow_database    = var.airflow_database
  }
}


resource "oci_core_instance" "Airflow" {
  compartment_id      = var.compartment_ocid
  display_name        = "${var.label_prefix}${var.display_name}"
  shape               = var.shape
  availability_domain = var.availability_domains[0] 
  fault_domain        = "FAULT-DOMAIN-1" 

  dynamic "shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      memory_in_gbs = var.flex_shape_memory
      ocpus = var.flex_shape_ocpus
    }
  }


  create_vnic_details {
    subnet_id        = var.subnet_id
    display_name     = "${var.label_prefix}${var.display_name}"
    assign_public_ip = var.assign_public_ip
    hostname_label   = "${var.display_name}"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
  }

  source_details {
    source_id   = var.image_id
    source_type = "image"
  }

  provisioner "file" {
    content     = data.template_file.install_dependencies.rendered
    destination = local.dependencies_script

    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

    }
  }

  provisioner "file" {
    content     = data.template_file.install_airflow.rendered
    destination = local.airflow_install_script

    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

    }
  }

  provisioner "file" {
    content     = data.template_file.configure_local_security.rendered
    destination = local.security_script

    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

    }
  }

 provisioner "file" {
    content     = data.template_file.create_airflow_db.rendered
    destination = local.create_airflow_db

    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

    }
  }

  provisioner "file" {
    content     = data.template_file.deploy_airflow.rendered
    destination = local.airflow_deploy_script

    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

    }
  }

   provisioner "remote-exec" {
    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

    }

    inline = [
       "chmod +x ${local.dependencies_script}",
       "sudo ${local.dependencies_script}",
       "chmod +x ${local.airflow_install_script}",
       "sudo ${local.airflow_install_script}",
       "chmod +x ${local.create_airflow_db}",
       "sudo ${local.create_airflow_db}",
       "chmod +x ${local.airflow_deploy_script}",
       "sudo ${local.airflow_deploy_script}",
       "chmod +x ${local.security_script}",
       "sudo ${local.security_script}"
    ]

   }

  timeouts {
    create = "10m"

  }
}
