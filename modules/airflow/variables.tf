
variable "compartment_ocid" {
  description = "Compartment's OCID where VCN will be created. "
}

variable "availability_domains" {
  description = "The Availability Domain of the instance. "
  default     = []
}

variable "display_name" {
  description = "The name of the instance. "
  default     = ""
}

variable "subnet_id" {
  description = "The OCID of the Shell subnet to create the VNIC for public access. "
  default     = ""
}

variable "shape" {
  description = "Instance shape to use for master instance. "
  default     = "VM.Standard2.1"
}

variable "flex_shape_ocpus" {
  description = "Flex Instance shape OCPUs"
  default = 1
}

variable "flex_shape_memory" {
  description = "Flex Instance shape Memory (GB)"
  default = 6
}

variable "label_prefix" {
  description = "To create unique identifier for multiple clusters in a compartment."
  default     = ""
}

variable "assign_public_ip" {
  description = "Whether the VNIC should be assigned a public IP address. Default 'false' do not assign a public IP address. "
  default     = true
}

variable "ssh_authorized_keys" {
  description = "Public SSH keys path to be included in the ~/.ssh/authorized_keys file for the default user on the instance. "
  default     = ""
}

variable "ssh_private_key" {
  description = "The private key path to access instance. "
  default     = ""
}

variable "image_id" {
  description = "The OCID of an image for an instance to use. "
  default     = ""
}

variable "vm_user" {
  description = "The SSH user to connect to the master host."
  default     = "opc"
}

variable "airflow_name" {
  description = "Airflow Database User Name."
}

variable "airflow_password" {
  description = "Airflow Database User Password."
}

variable "airflow_database" {
  description = "Airflow Database Name."
}

variable "airflow_admin" {
  description = "Airflow Admin User."
}

variable "airflow_admin_pass" {
  description = "Airflow Admin User Password."
}

variable "admin_username" {
    description = "Username of the MDS admin account"
}


variable "admin_password" {
    description = "Password for the admin user for MDS"
}

variable "mds_ip" {
    description = "Private IP of the MDS Instance"
}

variable "airflow_version" {
  description = "Airflow version to use"
  default     = "2.5.0"
}

variable "airflow_email" {
  description = "Airflow's admin email address"
}


locals {
  compute_flexible_shapes = [
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex",
    "VM.Standard.A1.Flex",
    "VM.Optimized3.Flex",
    "VM.Standard3.Flex",
    "VM.Standard4.Flex"
  ]
}

locals {
  is_flexible_node_shape = contains(local.compute_flexible_shapes, var.shape)
}
