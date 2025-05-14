resource "google_service_account" "kokenwiki-cloudrun" {
  account_id   = "kokenwiki-cloudrun"
  display_name = "Kokenwiki Cloud Run Service Account"
}

resource "google_project_iam_member" "kokenwiki-cloudrun-iam" {
  project = var.project_id
  role = "roles/cloudsql.client"
  member = "serviceAccount:${google_service_account.kokenwiki-cloudrun.email}"
}

resource "google_secret_manager_secret_iam_member" "kokenwiki" {
  secret_id = google_secret_manager_secret.kokenwiki-master-key.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.kokenwiki-cloudrun.email}"
}

resource "google_service_account" "kokenwiki-deployer" {
  project      = var.project_id
  account_id   = "kokenwiki-deployer"
  display_name = "Kokenwiki Deployer Service Account for GitHub Actions"
}

resource "google_project_iam_member" "kokenwiki-deployer" {
    project = var.project_id
    role = "roles/run.developer"
    member = "serviceAccount:${google_service_account.kokenwiki-deployer.email}"
}

resource "google_iam_workload_identity_pool" "workload_identity_pool" {
  project                     = var.project_id
  workload_identity_pool_id = "kokenwiki-actions"
  display_name              = "Kokenwiki GitHub Actions"
  description               = "Workload Identity Pool for GitHub Actions"
}

locals {
    repository = "ueckoken/KokenWiki"
}

resource "google_iam_workload_identity_pool_provider" "workload_identity_pool_provider" {
  project = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.workload_identity_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "kokenwiki-oidc"
  display_name                       = "Name of provider"
  description                        = "GitHub Actions identity pool provider"
  attribute_condition                = <<EOT
    attribute.repository == "${local.repository}"
EOT
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.aud"        = "assertion.aud"
    "attribute.repository" = "assertion.repository"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "workload_identity_deployer" {
  service_account_id = google_service_account.kokenwiki-deployer.id
  role = "roles/iam.workloadIdentityUser"
  member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.workload_identity_pool.name}/attribute.repository/${local.repository}"
}
