locals {
  proj_name    = "brcompute"
  proj_id      = "brcompute2"
  location     = "us-central1"
  zone         = "us-central1-b"
  tag_owner    = "guilhermeviegas"
}

module "network" {
  source    = "./modules/network"
  proj_name = local.proj_name
  proj_id   = local.proj_id
  location  = local.location
  zone      = local.zone
  tag_owner = local.tag_owner
}

module "datalake" {
  source    = "./modules/datalake"
  proj_name = local.proj_name
  proj_id   = local.proj_id
  location  = local.location
  tag_owner = local.tag_owner
}

module "compute1" {
  source           = "./modules/compute"
  proj_name        = local.proj_name
  proj_id          = local.proj_id
  svc_name         = "vm1"
  location         = local.location
  zone             = local.zone
  machine_type     = "n1-standard-4"
  tag_owner        = local.tag_owner
  network_name     = module.network.vpc_network_name
  cleanbucket_name = module.datalake.output_brcomputetfgcpcleanbucket_name
  gpu_enabled      = false
}

module "compute2" {
  source           = "./modules/compute"
  proj_name        = local.proj_name
  proj_id          = local.proj_id
  svc_name         = "vm2"
  location         = local.location
  zone             = local.zone
  machine_type     = "n1-standard-4"
  tag_owner        = local.tag_owner
  network_name     = module.network.vpc_network_name
  cleanbucket_name = module.datalake.output_brcomputetfgcpcleanbucket_name
  gpu_enabled      = false
}

module "compute3" {
  source           = "./modules/compute"
  proj_name        = local.proj_name
  proj_id          = local.proj_id
  svc_name         = "vm3"
  location         = "europe-west4"
  zone             = "europe-west4-b"
  machine_type     = "n1-standard-4"
  tag_owner        = local.tag_owner
  network_name     = module.network.vpc_network_name
  cleanbucket_name = module.datalake.output_brcomputetfgcpcleanbucket_name
  gpu_enabled      = true
  gpu_type         = "nvidia-tesla-p4"
}
