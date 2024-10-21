module "wrapper" {
  source = "../"

  for_each = var.items

  api_key     = try(each.value.api_key, var.defaults.api_key)
  reconfigure = try(each.value.reconfigure, var.defaults.reconfigure, false)
}
