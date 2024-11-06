module "wrapper" {
  source = "../"

  for_each = var.items

  api_key                  = try(each.value.api_key, var.defaults.api_key)
  min_required_permissions = try(each.value.min_required_permissions, var.defaults.min_required_permissions, false)
  reconfigure              = try(each.value.reconfigure, var.defaults.reconfigure, false)
  system_bucket_name       = try(each.value.system_bucket_name, var.defaults.system_bucket_name, "na")
}
