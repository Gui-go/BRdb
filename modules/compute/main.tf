
data "google_secret_manager_secret_version" "brcomputetfgcpsecretrpw" {
  secret = "rstudio-passwd"
  version = "latest"
}

data "google_secret_manager_secret_version" "brcomputetfgcpsecretgitprivsshk" {
  secret = "github-private-ssh-key"
  version = "latest"
}

resource "google_compute_instance" "brcomputetfgcpvm" {
  name         = "${var.proj_name}-vm"
  machine_type = var.machine_type
  zone         = var.zone
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
  metadata = {
    "user-data" = <<-EOF
      #!/bin/bash

      sudo apt update -y

      sudo apt install -y docker.io
      sudo systemctl start docker
      sudo systemctl enable docker

      sudo docker pull rocker/geospatial
      sudo docker run -d -p 8787:8787 --name rstudio -e ROOT=true -e USER=rstudio -e PASSWORD=${data.google_secret_manager_secret_version.brcomputetfgcpsecretrpw.secret_data} rocker/geospatial

      sleep 5

      sudo docker exec -t rstudio bash -c '
        apt update
        apt install -y git

        mkdir -p ~/.ssh
        echo -e "${data.google_secret_manager_secret_version.brcomputetfgcpsecretgitprivsshk.secret_data}" > ~/.ssh/id_rsa
        chmod 600 ~/.ssh/id_rsa

        touch /.ssh/known_hosts
        ssh-keyscan -H github.com > ~/.ssh/known_hosts
        chmod 600 ~/.ssh/known_hosts

        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_rsa
        git config --global user.email "guilhermeviegas1993@gmail.com"
        git config --global user.name "Gui-go"

        git clone git@github.com:Gui-go/BRdb.git /home/rstudio/BRdb/
        git config --global --add safe.directory /home/rstudio/BRdb
        
      '
      
    EOF
  }
#   service_account {
#     email  = google_service_account.brcomputetfgcpsa.email
#     scopes = ["https://www.googleapis.com/auth/cloud-platform"]
#   }
}

# resource "google_service_account" "brcomputetfgcpsa" {
#   account_id   = "my-service-account"
#   display_name = "My Service Account"
# }

# resource "google_project_iam_member" "brcomputetfgcpiamm" {
#   project = var.proj_id
#   role    = "roles/compute.viewer"
#   member  = "serviceAccount:${google_service_account.brcomputetfgcpsa.email}"
# }

