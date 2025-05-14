terraform {
  required_version = ">= 1.11.0"
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
  backend "gcs" {
    bucket = "kokenwiki-terraform-state"
    prefix = "terraform/state"
  }
}

locals {
  impersonate_service_account = "kokenwiki-terraform@uec-koken.iam.gserviceaccount.com"
}

provider "google" {
  alias   = "impersonation"
  project = var.project_id
  region  = var.region
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

data "google_service_account_access_token" "terraform" {
  provider               = google.impersonation
  target_service_account = local.impersonate_service_account
  scopes = [
    "userinfo-email",
    "cloud-platform",
  ]
  lifetime = "120s"
}

provider "google" {
  alias        = "for_database"
  project      = var.project_id
  access_token = data.google_service_account_access_token.terraform.access_token
}
