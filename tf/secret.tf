resource "google_secret_manager_secret" "kokenwiki-master-key" {
  secret_id = "kokenwiki-master-key"
  replication {
    auto {}
  }
}

data "google_secret_manager_secret_version" "kokenwiki-master-key" {
  secret  = google_secret_manager_secret.kokenwiki-master-key.id
  version = "latest"
}