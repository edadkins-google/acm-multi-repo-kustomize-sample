kustomize build ../source/environments/dev --output=../deploy/dev/
kustomize build ../source/environments/pre-prod --output=../deploy/pre-prod/
kustomize build ../source/environments/prod --output=../deploy/prod/