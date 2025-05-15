resource "google_cloud_run_v2_service" "kokenwiki" {
  name                 = "kokenwiki"
  project              = var.project_id
  location             = var.region
  invoker_iam_disabled = true
  deletion_protection  = false
  template {
    service_account = google_service_account.kokenwiki-cloudrun.email
    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [google_sql_database_instance.kokenwiki.connection_name]
      }
    }
    containers {
        image = "gcr.io/google-samples/hello-app:1.0"

      ports {
        container_port = 3000
      }

      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }

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
        value = "development"
      }
      env {
        name = "RAILS_LOG_TO_STDOUT"
        value = "true"
      }
    }
  }
  lifecycle {
    ignore_changes = [
        template[0].containers[0].image,
    ]
  }
}
