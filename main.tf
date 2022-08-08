// Instance_types data source for instance_type
data "alicloud_instance_types" "default" {
  cpu_core_count = var.cpu_core_count
  memory_size    = var.memory_size
}

// Zones data source for availability_zone
data "alicloud_zones" "default" {
  available_instance_type = data.alicloud_instance_types.default.instance_types[0].id
}

// If there is not specifying vpc_id, the module will launch a new vpc
resource "alicloud_vpc" "vpc" {
  count      = var.vpc_id == "" ? 1 : 0
  cidr_block = var.vpc_cidr
  name       = var.vpc_name == "" ? var.example_name : var.vpc_name
}

// According to the vswitch cidr blocks to launch several vswitches
resource "alicloud_vswitch" "vswitches" {
  count             = length(var.vswitch_ids) > 0 ? 0 : length(var.vswitch_cidrs)
  vpc_id            = var.vpc_id == "" ? join("", alicloud_vpc.vpc.*.id) : var.vpc_id
  cidr_block        = var.vswitch_cidrs[count.index]
  availability_zone = data.alicloud_zones.default.zones[count.index % length(data.alicloud_zones.default.zones)]["id"]
  name = var.vswitch_name_prefix == "" ? format(
    "%s-%s",
    var.example_name,
    format(var.number_format, count.index + 1),
    ) : format(
    "%s-%s",
    var.vswitch_name_prefix,
    format(var.number_format, count.index + 1),
  )
}

resource "alicloud_nat_gateway" "default" {
  count      = var.new_nat_gateway == true ? 1 : 0
  vpc_id     = var.vpc_id == "" ? join("", alicloud_vpc.vpc.*.id) : var.vpc_id
  name       = var.example_name
  nat_type   = var.nat_type
  vswitch_id = length(var.vswitch_ids) > 0 ? split(",", join(",", var.vswitch_ids))[count.index % length(split(",", join(",", var.vswitch_ids)))] : length(var.vswitch_cidrs) < 1 ? "" : split(",", join(",", alicloud_vswitch.vswitches.*.id))[count.index % length(split(",", join(",", alicloud_vswitch.vswitches.*.id)))]
}

resource "alicloud_eip" "default" {
  count     = var.new_nat_gateway == true ? 1 : 0
  bandwidth = 10
}

resource "alicloud_eip_association" "default" {
  count         = var.new_nat_gateway == true ? 1 : 0
  allocation_id = alicloud_eip.default[0].id
  instance_id   = alicloud_nat_gateway.default[0].id
}

resource "alicloud_snat_entry" "default" {
  count             = var.new_nat_gateway == false ? 0 : length(var.vswitch_ids) > 0 ? length(var.vswitch_ids) : length(var.vswitch_cidrs)
  snat_table_id     = alicloud_nat_gateway.default[0].snat_table_ids
  source_vswitch_id = length(var.vswitch_ids) > 0 ? split(",", join(",", var.vswitch_ids))[count.index % length(split(",", join(",", var.vswitch_ids)))] : length(var.vswitch_cidrs) < 1 ? "" : split(",", join(",", alicloud_vswitch.vswitches.*.id))[count.index % length(split(",", join(",", alicloud_vswitch.vswitches.*.id)))]
  snat_ip           = alicloud_eip.default[0].ip_address
  depends_on        = [alicloud_eip_association.default]
}

resource "alicloud_cs_kubernetes" "k8s" {
  count = var.k8s_number

  name = var.k8s_name_prefix == "" ? format(
    "%s-%s",
    var.example_name,
    format(var.number_format, count.index + 1),
    ) : format(
    "%s-%s",
    var.k8s_name_prefix,
    format(var.number_format, count.index + 1),
  )
  master_vswitch_ids    = length(var.vswitch_ids) > 0 ? split(",", join(",", var.vswitch_ids)) : length(var.vswitch_cidrs) < 1 ? [] : split(",", join(",", alicloud_vswitch.vswitches.*.id))
  worker_vswitch_ids    = length(var.vswitch_ids) > 0 ? split(",", join(",", var.vswitch_ids)) : length(var.vswitch_cidrs) < 1 ? [] : split(",", join(",", alicloud_vswitch.vswitches.*.id))
  master_instance_types = var.master_instance_types
  worker_instance_types = var.worker_instance_types
  worker_number         = var.k8s_worker_number
  node_cidr_mask        = var.node_cidr_mask
  enable_ssh            = var.enable_ssh
  install_cloud_monitor = var.install_cloud_monitor
  cpu_policy            = var.cpu_policy
  proxy_mode            = var.proxy_mode
  password              = var.password
  pod_cidr              = var.k8s_pod_cidr
  service_cidr          = var.k8s_service_cidr
  version               = var.k8s_version
  dynamic "addons" {
    for_each = var.cluster_addons
    content {
      name   = lookup(addons.value, "name", var.cluster_addons)
      config = lookup(addons.value, "config", var.cluster_addons)
    }
  }
  depends_on = [alicloud_snat_entry.default]
}