module "gke_cluster" {

  source = "../../modules/gke_cluster"
  
  project = var.project
  sync_repo = var.sync_repo
  gke_name = var.gke_name
  policy_dir = var.policy_dir
}