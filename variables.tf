variable "region" {
    default = "us-central1"  
}

variable "zones" {
  default = ["us-central1-a", "us-central1-b", "us-central1-f"]
}

variable "project_id" {
    default="my-project"  
}

variable "network" {
  default = "cluster-vpc"
}

variable "subnetwork" {
  default = "cluster-subnet"
}

variable "compute_engine_service_account" {
  default = "compute@developer.gserviceaccount.com"
}

variable "ip_range_pods_name" {
  default = "smu-pods"
}

variable "ip_range_services_name" {
  default = "smu-svc"
}

variable "cluster_name" {
  default ="private-cluster"
}

variable "prefix" {
  default ="default"
}

variable "num_nodes" {
  default = 1
}