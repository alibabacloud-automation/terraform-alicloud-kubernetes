// Provider specific configs
provider "alicloud" {
  version                 = ">=1.60.0"
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/kubernetes"
}

resource "alicloud_cs_kubernetes" "k8s" {
  availability_zone     = local.zone_id
  name                  = var.k8s_name
  vswitch_ids           = local.vswitch_ids
  new_nat_gateway       = var.new_nat_gateway
  master_disk_category  = var.master_disk_category
  worker_disk_category  = var.worker_disk_category
  master_disk_size      = var.master_disk_size
  worker_disk_size      = var.worker_disk_size
  password              = var.ecs_password
  pod_cidr              = var.k8s_pod_cidr
  service_cidr          = var.k8s_service_cidr
  enable_ssh            = true
  install_cloud_monitor = true

  master_instance_types = local.master_instance_types
  worker_instance_types = local.worker_instance_types
  worker_numbers        = var.k8s_worker_numbers
}

