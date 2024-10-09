
resource "google_storage_bucket" "tfgcprawbucket" {
  name          = "${var.svc_name}-rawbucket"
  project       = var.proj_id
  location      = var.location
  storage_class = "COLDLINE" # NEARLINE COLDLINE ARCHIVE
  logging {
    log_bucket        = google_storage_bucket.logging_bucket.name
    log_object_prefix = "logs/"
  }
  labels = {
    environment = var.svc_name
    project     = var.proj_id
    owner       = var.tag_owner
  }
}

resource "google_storage_bucket" "tfgcpcleanbucket" {
  name          = "${var.svc_name}-cleanbucket"
  project       = var.proj_id
  location      = var.location
  storage_class = "STANDARD"
  logging {
    log_bucket        = google_storage_bucket.logging_bucket.name
    log_object_prefix = "logs/"
  }
  labels = {
    environment = var.svc_name
    project     = var.proj_id
    owner       = var.tag_owner
  }
}

resource "google_storage_bucket" "logging_bucket" {
  name          = "${var.svc_name}-logbucket"
  project       = var.proj_id
  location      = var.location
  storage_class = "STANDARD"
  labels = {
    environment = var.svc_name
    project     = var.proj_id
    owner       = var.tag_owner
  }
}
