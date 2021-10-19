module "gke_cluster" {

  source = "../../modules/gke_cluster"
  
  project = var.project
  gke_name = var.gke_name
  policy_dir = var.policy_dir
}