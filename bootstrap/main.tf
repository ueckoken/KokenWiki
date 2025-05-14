terraform {
  required_version = ">= 1.11.0"
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Service account for Terraform
resource "google_service_account" "terraform" {
  account_id   = "kokenwiki-terraform"
  display_name = "Terraform Runner Service Account on Github Actions"
}

locals {
  roles = [
    "roles/iam.serviceAccountUser",
    "roles/iam.serviceAccountTokenCreator",
    "roles/cloudsql.editor",
    "roles/secretmanager.admin",
    "roles/iam.serviceAccountCreator",
    "roles/run.developer",
    "roles/artifactregistry.admin",
    "roles/editor"
  ]
}

resource "google_project_iam_member" "terraform" {
  project = var.project_id
  role = each.value
  member = "serviceAccount:${google_service_account.terraform.email}"
  for_each = toset(local.roles)
}

resource "google_storage_bucket" "terraform_state" {
  name                        = "kokenwiki-terraform-state"
  location                    = var.region
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
}

locals {
  apis = [
    "iamcredentials.googleapis.com",
    "sqladmin.googleapis.com",
  ]
}

resource "google_project_service" "apis" {
  project = var.project_id
  service = each.value
  for_each = toset(local.apis)
}

provider "google" {
  alias = "for_database"
  region = "us-central1"
  project = var.project_id
}