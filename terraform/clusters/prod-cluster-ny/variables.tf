variable "project" {
  type        = string
  description = "the GCP project where the cluster will be created"
}

variable "gke_name" {
  type        = string
  description = "the root directory in the repo branch that contains the resources."
  default     = "prod-cluster-ny"
}

variable "sync_rev" {
  type        = string
  description = "the git commit in the repo to sync"
  default     = "7c8feabc06b7a0e3a90618dd75578fcc31618365"
}

variable "policy_dir" {
  type        = string
  description = "the root directory in the repo branch that contains the resources."
  default     = "deploy/prod/prod-cluster-ny"
}