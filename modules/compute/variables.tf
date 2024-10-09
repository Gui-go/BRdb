variable "proj_name" {
  description = "Project name"
  type        = string
}

variable "proj_id" {
  description = "Project ID identifier"
  type        = string
}

variable "svc_name" {
  description = "Service name"
  type        = string
}

variable "location" {
  description = "Location of the resources"
  type        = string
}

variable "zone" {
  description = "Zone of the resources"
  type        = string
}

variable "machine_type" {
  description = "Virtual Machine type/size"
  type        = string
}

variable "tag_owner" {
  description = "Tag to describe the owner of the resources"
  type        = string
}

variable "network_name" {
  description = "Output from network module"
  type        = string
}
