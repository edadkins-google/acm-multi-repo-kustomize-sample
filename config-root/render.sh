#!/bin/bash

# Render kustomizations

set -o errexit -o nounset -o pipefail

for dir in source/environments/*/
do
    dir=${dir%*/}
    for cluster in source/environments/"${dir##*/}"/*/
    do
       cluster=${cluster%*/}
       echo "rendering ${cluster##*/} in ${dir##*/}..."
       mkdir -p ../deploy/"${dir##*/}"/"${cluster##*/}"
       kustomize build ${cluster} --output=../deploy/"${dir##*/}"/"${cluster##*/}"/manifest.yaml
    done
done