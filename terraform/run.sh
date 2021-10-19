set -o errexit
set -o nounset
set -o pipefail

echo Enter Project Name:
read project

update_project () {
  for dir in ../config-root/source/environments/*/
  do
      dir=${dir%*/}
      for cluster in ../config-root/source/environments/"${dir##*/}"/*/
      do
        cluster=${cluster%*/}
        sed -i "s/${project}/PROJECT-INSERT/g" ../config-root/source/environments/"${dir##*/}"/"${cluster##*/}"/kustomization.yaml
      done
  done

  for dir in ../config-root/source/tenants/*/
  do
      dir=${dir%*/}
      for tenant in ../config-root/source/tenants/"${dir##*/}"/*/
      do
        tenant=${tenant%*/}
        sed -i "s/${project}/PROJECT-INSERT/g" ../config-root/source/environments/"${dir##*/}"/"${tenant##*/}"/kustomization.yaml
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

