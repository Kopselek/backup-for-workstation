terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.35.0"
    }
  }
}

provider "google" {
  project     = var.gcp_project_id
  credentials = file(var.gcp_credentials)
  region      = "europe-central2"
}
