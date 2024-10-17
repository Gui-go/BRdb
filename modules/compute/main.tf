
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
    "user-data"             = <<-EOF
      #!/bin/bash

      sudo apt update -y
      sudo apt install tree -y
      sudo apt install -y docker.io
      sudo systemctl start docker
      sudo systemctl enable docker

      sudo docker pull rocker/geospatial
      sudo docker run -d \
        -p 8787:8787 \
        --name rstudio \
        -e ROOT=true \
        -e USER=rstudio \
        -e PASSWORD=${data.google_secret_manager_secret_version.brcomputetfgcpsecretrpw.secret_data} \
        --user root \
        rocker/geospatial

      sleep 5

      sudo docker exec -t rstudio bash -c '

        sudo apt update -y
        sudo apt install tree -y

        mkdir -p ~/.ssh
        echo -e "${data.google_secret_manager_secret_version.brcomputetfgcpsecretgitprivsshk.secret_data}" > ~/.ssh/id_rsa
        chmod 600 ~/.ssh/id_rsa

        touch ~/.ssh/known_hosts
        ssh-keyscan -H github.com > ~/.ssh/known_hosts
        chmod 600 ~/.ssh/known_hosts

        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_rsa
        git config --global user.email "guilhermeviegas1993@gmail.com"
        git config --global user.name "Gui-go"

        git clone git@github.com:Gui-go/BRdb.git /home/rstudio/BRdb/
        git config --global --add safe.directory /home/rstudio/BRdb/

        chown -R rstudio:rstudio /home/rstudio/

      '

      mkdir -p /home/guilhermeviegas1993/clean_data
      sudo gsutil -m cp -r gs://${var.cleanbucket_name}/* /home/guilhermeviegas1993/clean_data/      
      sudo docker cp /home/guilhermeviegas1993/clean_data/. rstudio:/home/rstudio/clean_bucket/
      
      echo "VM init finished!"

    EOF    
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

