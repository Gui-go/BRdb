
data "google_secret_manager_secret_version" "brcomputetfgcpsecretrpw" {
  secret = "rstudio-passwd"
  version = "latest"
}

data "google_secret_manager_secret_version" "brcomputetfgcpsecretgitprivsshk" {
  secret = "github-private-ssh-key"
  version = "latest"
}

resource "google_compute_instance" "brcomputetfgcpvm" {
  name         = "computeinstance-${var.svc_name}"
  machine_type = var.machine_type
  zone         = var.zone
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
    #   image = "projects/YOUR_PROJECT_ID/global/images/YOUR_IMAGE_NAME"
    image = "ubuntu-2204-jammy-v20240927"
    }
  }
  network_interface {
    network = var.network_name
    access_config {
      // Allocate a new IP address
    }
  }
  dynamic "guest_accelerator" {
    for_each = var.gpu_enabled ? [1] : []
    content {
      type  = var.gpu_type
      count = 1
    }
  }
  scheduling {
    preemptible       = false
    automatic_restart = true
    on_host_maintenance = "TERMINATE"
  }
  metadata = {
    "install-nvidia-driver" = var.gpu_enabled ? "true" : "false"
    "user-data"             = file("${path.module}/init_test.sh")
  }
  service_account {
    email  = google_service_account.vm_service_account.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "google_service_account" "vm_service_account" {
  account_id   = "${var.svc_name}-serviceaccount"
  display_name = "Service account for VM to access GCS"
}

resource "google_project_iam_member" "vm_storage_access" {
  project = var.proj_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.vm_service_account.email}"
}

