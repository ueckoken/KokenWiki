resource "google_artifact_registry_repository" "kokenwiki" {
  project       = var.project_id
  location      = var.region
  repository_id = "kokenwiki"
  description   = "KokenWiki"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_member" "kokenwiki" {
  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.kokenwiki.name
  role       = "roles/artifactregistry.admin"
  member     = "serviceAccount:${google_service_account.kokenwiki-cloudrun.email}"
}

resource "google_artifact_registry_repository_iam_member" "kokenwiki-deployer" {
  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.kokenwiki.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.kokenwiki-deployer.email}"
}