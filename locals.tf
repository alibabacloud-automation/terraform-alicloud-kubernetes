locals {
  vswitch_name_regex        = var.vswitch_name_regex != "" ? var.vswitch_name_regex : var.filter_with_name_regex
  vswitch_tags              = length(var.vswitch_tags) > 0 ? var.vswitch_tags : var.filter_with_tags
  vswitch_resource_group_id = var.vswitch_resource_group_id != "" ? var.vswitch_resource_group_id : var.filter_with_resource_group_id
  vswitch_ids               = length(var.vswitch_ids) > 0 ? var.vswitch_ids : local.vswitch_name_regex != "" || length(local.vswitch_tags) > 0 || local.vswitch_resource_group_id !="" ? data.alicloud_vswitches.this.ids : []
  master_instance_types     = length(var.master_instance_types) > 0 ? var.master_instance_types : [data.alicloud_instance_types.this.instance_types[0].id]
  worker_instance_types     = length(var.worker_instance_types) > 0 ? var.worker_instance_types : [data.alicloud_instance_types.this.instance_types[0].id]
  zone_id                   = data.alicloud_vswitches.this.vswitches.0.zone_id
}


// Instance_types data source for instance_type
data "alicloud_instance_types" "this" {
  availability_zone = local.zone_id
  cpu_core_count    = var.cpu_core_count
  memory_size       = var.memory_size
}

data "alicloud_vswitches" "this" {
  name_regex        = local.vswitch_name_regex
  tags              = local.vswitch_tags
  resource_group_id = local.vswitch_resource_group_id
}
