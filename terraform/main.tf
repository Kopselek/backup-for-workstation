resource "google_storage_bucket" "backup_bucket" {
  for_each      = local.bucket_names
  name          = each.value
  location      = "EU"
  force_destroy = true

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30
    }
  }
}


resource "google_storage_bucket_iam_member" "backup_bucket_viewer" {
  for_each = local.bucket_names
  bucket   = google_storage_bucket.backup_bucket[each.key].name
  role     = "roles/storage.objectViewer"
  member   = "user:${each.key}"
}

resource "google_storage_bucket_iam_member" "backup_bucket_creator" {
  for_each = local.bucket_names
  bucket   = google_storage_bucket.backup_bucket[each.key].name
  role     = "roles/storage.objectCreator"
  member   = "user:${each.key}"
}
