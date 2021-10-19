set -o errexit
set -o nounset
set -o pipefail

echo Enter Project Name:
read project

update_project () {
  for env_dir in ../config-root/source/environments/*/
  do
      env_dir=${env_dir%*/}
      for cluster in ../config-root/source/environments/"${env_dir##*/}"/*/
      do
        cluster=${cluster%*/}
        echo ../config-root/source/environments/"${env_dir##*/}"/"${cluster##*/}"/kustomization.yaml
        sed -i "s/PROJECT-INSERT/${project}/g" ../config-root/source/environments/"${env_dir##*/}"/"${cluster##*/}"/kustomization.yaml
      done
  done

  for tenant_dir in ../config-root/source/tenants/*/
  do
      tenant_dir=${tenant_dir%*/}
      for tenant in ../config-root/source/tenants/"${tenant_dir##*/}"/
      do
        tenant=${tenant%*/}
        echo "${tenant##/}"/kustomization.yaml
        sed -i "s/PROJECT-INSERT/${project}/g" "${tenant##/}"/kustomization.yaml
      done
  done
}

# provision clusters
create_cluster () {
  for cluster in dev-cluster pre-prod-cluster prod-cluster-lon
  do
    terraform -chdir=clusters/${cluster} init
    terraform -chdir=clusters/${cluster} apply -var "project=${project}" -auto-approve &
    gcloud container clusters get-credentials ${cluster} --region europe-west2 --project ${project}
  done
}

# delete clusters
destroy_cluster () {
  for cluster in dev-cluster pre-prod-cluster prod-cluster-lon
  do
    terraform -chdir=clusters/${cluster} init
    terraform -chdir=clusters/${cluster} destroy  -var "project=${project}" -auto-approve
  done
}

while getopts cd flag
do
    case "${flag}" in
        c) create_cluster ;;
        d) destroy_cluster ;;
    esac
done

