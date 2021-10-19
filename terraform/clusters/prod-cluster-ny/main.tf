module "eks_cluster" {

  source = "../../modules/eks_cluster"

  project = var.project
  gke_name = var.gke_name
  policy_dir = var.policy_dir
  sync_rev = var.sync_rev
}