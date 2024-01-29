locals {
  subscription = var.instance_charge_type == "PostPaid" ? {} : var.subscription
}