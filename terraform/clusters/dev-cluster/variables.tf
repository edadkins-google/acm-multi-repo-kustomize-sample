variable "project" {
  type        = string
  description = "the GCP project where the cluster will be created"
}

variable "gke_name" {
  type        = string
  description = "the root directory in the repo branch that contains the resources."
  default     = "dev-cluster"
}

variable "sync_repo" {
  type        = string
  description = "git URL for the repo which will be sync'ed into the cluster via Config Management"
}

variable "policy_dir" {
  type        = string
  description = "the root directory in the repo branch that contains the resources."
  default     = "deploy/dev/dev-cluster"
}