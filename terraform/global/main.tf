module "enabled_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 10.0"

  project_id                  = var.project
  disable_services_on_destroy = true

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "gkehub.googleapis.com",
    "anthosconfigmanagement.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "anthos.googleapis.com",
    "sqladmin.googleapis.com"
  ]
}

resource "google_project_organization_policy" "os_login" {
  project = var.project
  constraint = "compute.requireOsLogin"

  restore_policy {
    default = true
  }
}

resource "google_project_organization_policy" "shielded_vm" {
  project = var.project
  constraint = "compute.requireShieldedVm"

  restore_policy {
    default = true
  }
}

resource "google_project_organization_policy" "vm_external_ip_access" {
  project = var.project
  constraint = "compute.vmExternalIpAccess"

  restore_policy {
    default = true
  }
}

resource "google_project_organization_policy" "ip_forward" {
  project = var.project
  constraint = "compute.vmCanIpForward"

  restore_policy {
    default = true
  }
}

resource "google_project_organization_policy" "bucket_level_access" {
  project = var.project
  constraint = "constraints/storage.uniformBucketLevelAccess"

  restore_policy {
    default = true
  } 
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [module.enabled_google_apis]
  create_duration = "30s"
}

resource "google_compute_network" "vpc_network" {
  project                 = var.project
  name                    = "gke-vpc"
  auto_create_subnetworks = true
  depends_on = [time_sleep.wait_30_seconds]
}

resource "google_gke_hub_feature" "feature" {
  name = "configmanagement"
  location = "global"
  provider = google-beta
  depends_on = [time_sleep.wait_30_seconds]
}