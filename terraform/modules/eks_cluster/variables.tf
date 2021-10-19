variable "project" {
  type        = string
  description = "the GCP project where the cluster will be created"
  default     = "ejmadkins-anthos-demo"
}

variable "sync_repo" {
  type        = string
  description = "git URL for the repo which will be sync'ed into the cluster via Config Management"
  default     = "https://github.com/ejmadkins/acm-multi-repo-kustomize-sample.git"
}

variable "sync_branch" {
  type        = string
  description = "the git branch in the repo to sync"
  default     = "main"
}

variable "sync_rev" {
  type        = string
  description = "the git commit in the repo to sync"
  default     = "HEAD"
}

variable "gke_name" {
  type        = string
  description = "the root directory in the repo branch that contains the resources."
}

variable "policy_dir" {
  type        = string
  description = "the root directory in the repo branch that contains the resources."
}