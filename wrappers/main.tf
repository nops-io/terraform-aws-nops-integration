module "wrapper" {
  source = "../"

  for_each = var.items

  api_key            = try(each.value.api_key, var.defaults.api_key)
  nops_principal     = try(each.value.nops_principal, var.defaults.nops_principal, "202279780353")
  nops_url           = try(each.value.nops_url, var.defaults.nops_url, "https://app.nops.io/")
  reconfigure        = try(each.value.reconfigure, var.defaults.reconfigure, false)
  system_bucket_name = try(each.value.system_bucket_name, var.defaults.system_bucket_name)
}
