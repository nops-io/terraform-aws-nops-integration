module "wrapper" {
  source = "../"

  for_each = var.items

  api_key         = try(each.value.api_key, var.defaults.api_key)
  compute_copilot = try(each.value.compute_copilot, var.defaults.compute_copilot, true)
  essentials      = try(each.value.essentials, var.defaults.essentials, true)
  reconfigure     = try(each.value.reconfigure, var.defaults.reconfigure, false)
  wafr            = try(each.value.wafr, var.defaults.wafr, true)
}
