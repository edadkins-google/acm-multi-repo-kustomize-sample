#!/bin/bash

set -o errexit -o nounset -o pipefail

# get GCP Project ID and Git repo URL from user
get_inputs () {
  echo Enter Project ID:
  read project
  echo Enter Git Repo URL:
  read git_repo
}

# update project
update_project () {
  for env_dir in ../config-root/environments/*/
  do
      env_dir=${env_dir%*/}
      for cluster in ../config-root/environments/"${env_dir##*/}"/*/
      do
        cluster=${cluster%*/}
        echo ../config-root/environments/"${env_dir##*/}"/"${cluster##*/}"/kustomization.yaml
        sed -i "s/PROJECT-INSERT/${project}/g" ../config-root/environments/"${env_dir##*/}"/"${cluster##*/}"/kustomization.yaml
      done
  done

  for tenant_dir in ../config-root/tenants/*/
  do
      tenant_dir=${tenant_dir%*/}
      for tenant in ../config-root/tenants/"${tenant_dir##*/}"/
      do
        tenant=${tenant%*/}
        echo "${tenant##/}"/kustomization.yaml
        sed -i "s/PROJECT-INSERT/${project}/g" "${tenant##/}"/kustomization.yaml
      done
  done
}

# enable ACM as a hub feature
enable_acm () {
  terraform -chdir=../terraform/global init
  terraform -chdir=../terraform/global apply -var "project=${project}" -auto-approve
}

# provision clusters
create_cluster () {
  get_inputs
  update_project
  enable_acm
  for cluster in dev-cluster preprod-cluster prod-cluster-lon
  do
    terraform -chdir=../terraform/clusters/${cluster} init
    terraform -chdir=../terraform/clusters/${cluster} apply -var "project=${project}" -var "sync_repo=${git_repo}" -auto-approve
    gcloud container clusters get-credentials ${cluster} --region europe-west2 --project ${project}
  done
}

# delete clusters
destroy_cluster () {
  get_inputs
  for cluster in dev-cluster preprod-cluster prod-cluster-lon
  do
    terraform -chdir=../terraform/clusters/${cluster} init
    terraform -chdir=../terraform/clusters/${cluster} destroy  -var "project=${project}" -var "sync_repo=${git_repo}" -auto-approve
  done
}

print_usage () {
    echo hello
}

while getopts cdh flag
do
    case "${flag}" in
        c) create_cluster ;;
        d) destroy_cluster ;;
        h) print_usage ;;
    esac
done