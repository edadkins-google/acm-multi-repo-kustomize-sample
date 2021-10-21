#!/bin/bash

set -o errexit -o nounset -o pipefail

# render kustomizations
render () {
  for dir in ../config-root/environments/*/
  do
      dir=${dir%*/}
      for cluster in ../config-root/environments/"${dir##*/}"/*/
      do
        cluster=${cluster%*/}
        echo "rendering ${cluster##*/} in ${dir##*/}..."
        mkdir -p ../deploy/"${dir##*/}"/"${cluster##*/}"
        kustomize build ${cluster} --output=../deploy/"${dir##*/}"/"${cluster##*/}"/manifest.yaml
      done
  done
}

render