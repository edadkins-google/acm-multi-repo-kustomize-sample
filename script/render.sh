for dir in ../source/environments/*/     # list directories in the form "/tmp/dirname/"
do
    dir=${dir%*/}      # remove the trailing "/"
    for cluster in ../source/environments/"${dir##*/}"/*/     # list directories in the form "/tmp/dirname/"
    do
       cluster=${cluster%*/}
       echo "rendering ${cluster##*/} in ${dir##*/}..."
       kustomize build ${cluster} --output=../deploy/"${dir##*/}"/"${cluster##*/}"/manifest.yaml
    done
done