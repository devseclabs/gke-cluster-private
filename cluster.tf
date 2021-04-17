data "google_client_config" "default" {}

provider "kubernetes" {
  load_config_file       = false
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gcp-network" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 3.1"
  project_id   = var.project_id
  network_name = "${var.prefix}-${var.network}"

  subnets = [
    {
      subnet_name           = "${var.prefix}-${var.subnetwork}"
      subnet_ip             = "10.0.0.0/17"
      subnet_region         = var.region
      subnet_private_access = "true"
    },
  ]

  secondary_ranges = {
    "${var.prefix}-${var.subnetwork}" = [
      {
        range_name    = "${var.prefix}-${var.ip_range_pods_name}"
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = "${var.prefix}-${var.ip_range_services_name}"
        ip_cidr_range = "192.168.64.0/18"
      },
    ]
  }
}

data "google_compute_subnetwork" "subnetwork" {
  name       = "${var.prefix}-${var.subnetwork}"
  project    = var.project_id
  region     = var.region
  depends_on = [module.gcp-network]
}

module "gke" {
  source     = "git::https://github.com/devseclabs/gke-cluster-module.git"
  project_id = var.project_id
  name       = "${var.prefix}-${var.cluster_name}"
  regional   = false
  region     = var.region
  zones      = slice(var.zones, 0, 1)

  network                 = module.gcp-network.network_name
  subnetwork              = module.gcp-network.subnets_names[0]
  ip_range_pods           = "${var.prefix}-${var.ip_range_pods_name}"
  ip_range_services       = "${var.prefix}-${var.ip_range_services_name}"
  create_service_account  = true
  enable_private_endpoint = true
  enable_private_nodes    = true
  master_ipv4_cidr_block  = "172.16.0.0/28"

  master_authorized_networks = [
    {
      cidr_block   = data.google_compute_subnetwork.subnetwork.ip_cidr_range
      display_name = "VPC"
    },
  ]

  node_pools = [
    {
      name               = "${var.prefix}-node-pool"
      machine_type       = "e2-medium"
      node_locations     = "us-central1-a,us-central1-b"
      min_count          = var.num_nodes
      max_count          = 10
      local_ssd_count    = 0
      disk_size_gb       = 10
      disk_type          = "pd-standard"
      image_type         = "ubuntu"
      auto_repair        = true
      auto_upgrade       = true
      #service_account    = var.compute_engine_service_account
      preemptible        = false
      initial_node_count = 2
    },
    {
      name               = "${var.prefix}-node-pool-2"
      machine_type       = "e2-medium"
      node_locations     = "us-central1-a,us-central1-b"
      min_count          = var.num_nodes
      max_count          = 10
      local_ssd_count    = 0
      disk_size_gb       = 10
      disk_type          = "pd-standard"
      image_type         = "ubuntu"
      auto_repair        = true
      auto_upgrade       = true
      #service_account    = var.compute_engine_service_account
      preemptible        = false
      initial_node_count = 1
    },
  ]

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = false
    }
  }

}