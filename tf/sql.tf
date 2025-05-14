resource "google_sql_database_instance" "kokenwiki" {
    database_version = "MYSQL_8_0"
    settings {
      deletion_protection_enabled = true
      disk_autoresize = false
      tier = "db-f1-micro"
    }
}