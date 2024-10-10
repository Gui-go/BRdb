
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
  metadata = {
    "user-data" = <<-EOF
      #!/bin/bash

      sudo apt update -y

      sudo apt install tree -y

      sudo apt install -y docker.io
      sudo systemctl start docker
      sudo systemctl enable docker

      sudo docker pull rocker/geospatial
      sudo docker run -d -p 8787:8787 \
        --name rstudio \
        -e ROOT=true \
        -e USER=rstudio \
        -e PASSWORD=${data.google_secret_manager_secret_version.brcomputetfgcpsecretrpw.secret_data} \
        rocker/geospatial

      sleep 5

      sudo docker exec -t rstudio bash -c '

        sudo apt update -y

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
        git config --global --add safe.directory /home/rstudio/BRdb/

      '

      sudo docker exec -t rstudio bash -c '

        sudo apt-get update
        sudo apt-get install gnupg -y

        echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list 
        curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - 
        
        sudo apt-get install google-cloud-sdk -y
        
        mkdir -p /home/rstudio/BRdb/data/cleanbucket/
        sudo gsutil -m cp -r gs://${var.cleanbucket_name}/* /home/rstudio/BRdb/data/cleanbucket/
      
      '
      
      echo "VM init finished!"

    EOF
  }

  service_account {
    email  = google_service_account.vm_service_account.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "google_service_account" "vm_service_account" {
  account_id   = "vm-access-storage"
  display_name = "Service account for VM to access GCS"
}

resource "google_project_iam_member" "vm_storage_access" {
  project = var.proj_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.vm_service_account.email}"
}

