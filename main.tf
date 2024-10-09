locals {
  proj_name    = "brcompute"
  proj_id      = "brcompute2"
  svc_name     = "brcompute"
  location     = "us-central1"
  zone         = "us-central1-a"
  machine_type = "e2-small"
  bucket_name  = "thesis4geotech2bucket1-cleanbucket"
  tag_owner    = "guilhermeviegas"
}

module "network" {
  source    = "./modules/network"
  proj_name = local.proj_name
  proj_id   = local.proj_id
  svc_name  = local.svc_name
  location  = local.location
  zone      = local.zone
  tag_owner = local.tag_owner
}

module "datalake" {
  source    = "./modules/datalake"
  proj_name = local.proj_name
  proj_id   = local.proj_id
  svc_name  = local.svc_name
  location  = local.location
  tag_owner = local.tag_owner
}

module "compute" {
  source       = "./modules/compute"
  proj_name    = local.proj_name
  proj_id      = local.proj_id
  svc_name     = local.svc_name
  location     = local.location
  zone         = local.zone
  machine_type = local.machine_type
  tag_owner    = local.tag_owner
  network_name = module.network.vpc_network_name
}


output "ready" {
  value = "bRcompute build complete!"
}

