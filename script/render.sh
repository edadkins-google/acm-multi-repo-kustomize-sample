kustomize build ../source/environments/dev --output=../deploy/dev/manifest.yaml
kustomize build ../source/environments/pre-prod --output=../deploy/pre-prod/manifest.yaml
kustomize build ../source/environments/prod --output=../deploy/prod/manifest.yaml