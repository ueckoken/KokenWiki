resource "google_cloud_run_v2_service" "kokenwiki" {
  name                 = "kokenwiki"
  project              = var.project_id
  location             = var.region
  invoker_iam_disabled = true
  deletion_protection  = false
  template {
    containers {
        image = "gcr.io/google-samples/hello-app:1.0"

      env {
        name = "RAILS_MASTER_KEY"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.kokenwiki-master-key.id
            version = "latest"
          }
        }
      }
      env {
        name  = "RAILS_ENV"
        value = "production"
      }
    }
    service_account = google_service_account.kokenwiki-cloudrun.email
  }
}