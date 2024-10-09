

export BILLING_ACC="01F0C7-9A2082-488963"
export PROJECT_INFRA_NAME="brcompute"
export PROJECT_INFRA_ID="${PROJECT_INFRA_NAME}2"
gcloud projects create $PROJECT_INFRA_ID --name=$PROJECT_INFRA_NAME --labels=owner=guilhermeviegas,environment=dev --enable-cloud-apis
gcloud beta billing projects link $PROJECT_INFRA_ID --billing-account=$BILLING_ACC
gcloud services enable compute.googleapis.com --project=$PROJECT_INFRA_ID
gcloud config set project $PROJECT_INFRA_ID

# gcloud projects delete


sudo docker run -d -p 8787:8787 --name rstudio -e USER=rstudio -e PASSWORD=rstudio rocker/geospatial

sudo docker exec -it rstudio bash -c "cat ~/.ssh/id_rsa"

sudo docker run -d -e ROOT=true -p 8787:8787 --name rstudio -v /home/guilhermeviegas1993/:/home/rstudio/ -e USER=rstudio -e PASSWORD=rstudio rocker/geospatial
sudo docker run -d -p 8787:8787 --name rstudio -v /home/guilhermeviegas1993/:/home/guilhermeviegas1993/ -e USER=rstudio -e PASSWORD=rstudio rocker/geospatial
sudo docker run -d -p 8787:8787 --name rstudio -e USER=rstudio -e PASSWORD=rstudio rocker/geospatial
sudo docker run -d -p 8787:8787 --name rstudio -e ROOT=true -e USER=rstudio -e PASSWORD=rstudio rocker/geospatial

git remote add origin https://github.com/Gui-go/BRdb.git
git branch -M main

sudo docker exec -t rstudio bash -c '
        mkdir -p ~/.ssh
        echo -e "${data.google_secret_manager_secret_version.brcomputetfgcpsecretgitprivsshk.secret_data}" > ~/.ssh/id_rsa
        chmod 600 ~/.ssh/id_rsa
        ssh-keyscan github.com >> ~/.ssh/known_hosts
        git clone git@github.com:Gui-go/BRdb.git /home/guilhermeviegas1993/BRdb/
      '


gcloud compute ssh brcompute-vm --zone us-central1-a
tail -f /var/log/cloud-init-output.log


gcloud compute images create brcompute-image --source-disk brcompute-vm --source-disk-zone us-central1-a


# -----



#!/bin/bash
apt-get update
apt-get install -y git
mkdir -p /home/rstudio/.ssh
echo "${tls_private_key.ssh_key.private_key_pem}" > /home/your_username/.ssh/id_rsa
echo  GCPgitSSHkey > /home/rstudio/.ssh/id_rsa
chmod 600 /home/rstudio/.ssh/id_rsa
eval "$(ssh-agent -s)"
ssh-add /home/rstudio/.ssh/id_rsa

git config --global user.email "guilhermeviegas1993@gmail.com"

git clone git@github.com:Gui-go/BRdb.git /home/rstudio/BRdb







'


sudo docker exec -t rstudio bash -c '
        # apt update
        # apt install -y git

        mkdir -p /home/rstudio/.ssh
        # echo -e "${data.google_secret_manager_secret_version.brcomputetfgcpsecretgitprivsshk.secret_data}" > /home/rstudio/.ssh/id_rsa
        chmod 600 /home/rstudio/.ssh/id_rsa

        touch /home/rstudio/.ssh/known_hosts
        ssh-keyscan github.com > /home/rstudio/.ssh/known_hosts
        chmod 600 /home/rstudio/.ssh/known_hosts

        eval "$(ssh-agent -s)"
        ssh-add /home/rstudio/.ssh/id_rsa
        git config --global user.email "guilhermeviegas1993@gmail.com"
        git config --global user.name "Gui-go"
        git clone git@github.com:Gui-go/BRdb.git /home/rstudio/BRdb5
        touch /home/rstudio/BRdb/vaiiii2.txt
        
      '

gcloud secrets versions access latest --secret="github-private-ssh-key" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
touch ~/.ssh/known_hosts
ssh-keyscan github.com > ~/.ssh/known_hosts
chmod 600 ~/.ssh/known_hosts
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
git config --global user.email "guilhermeviegas1993@gmail.com"
git config --global user.name "Gui-go"
git clone git@github.com:Gui-go/BRdb.git /home/rstudio/BRdb5






chmod 600 ~/.ssh/id_rsa
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
ssh-keyscan github.com >> ~/.ssh/known_hosts
git config --global user.name "Gui-go"
git config --global user.email "guilhermeviegas1993@gmail.com"
git clone git@github.com:Gui-go/BRdb.git /home/rstudio/BRdb
git add .
git commit -m "abc"
git push origin main

--

gcloud secrets versions access latest --secret="github-private-ssh-key" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
touch /.ssh/known_hosts
ssh-keyscan -H github.com > ~/.ssh/known_hosts
chmod 600 ~/.ssh/known_hosts
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
git config --global user.email "guilhermeviegas1993@gmail.com"
git config --global user.name "Gui-go"
git clone git@github.com:Gui-go/BRdb.git ~/Documents/08-bRcompute/BRdb/
git config --global --add safe.directory ~/Documents/08-bRcompute/BRdb

