locals {
  bucket_names = { for user in var.gcp_users : user => format("backup-%s", replace(user, "/@.*/", "")) }
}
