# acm-multi-repo-kustomize-sample

## Before you begin
This section describes prerequisites you must meet before this tutorial.
- ConfigSync is installed on your cluster, with multi-repo enabled and the RootSync resource deployed. If not, you can install
  it following the [instructions](https://cloud.google.com/anthos-config-management/docs/how-to/multi-repo#root-sync).
- `git` is installed in your local machine.
- `kustomize` is installed in your local machine. If not, you can install it by `gcloud components install kustomize`.

## Get the example configuration
The example Git repository contains three namespaces for different tenants, four clusters and three different environments. The repository contains the  following directories and files.
```
├── deploy
│   ├── dev
│   │   └── dev-cluster
│   │       └── manifest.yaml
│   ├── pre-prod
│   │   └── pre-prod-cluster
│   │       └── manifest.yaml
│   └── prod
│       ├── prod-cluster-lon
│       │   └── manifest.yaml
│       └── prod-cluster-ny
│           └── manifest.yaml
├── script
│   └── render.sh
└── source
    ├── base
    │   ├── cluster
    │   │   ├── agents
    │   │   │   └── datadog.yaml
    │   │   ├── kustomization.yaml
    │   │   └── policies
    │   │       └── K8sRequiredLabels.yaml
    │   └── namespace
    │       ├── kustomization.yaml
    │       ├── namespace.yaml
    │       ├── networkpolicy.yaml
    │       ├── reposync.yaml
    │       ├── role.yaml
    │       └── rolebinding.yaml
    ├── environments
    │   ├── dev
    │   │   ├── dev-cluster
    │   │   │   └── kustomization.yaml
    │   │   └── kustomization.yaml
    │   ├── pre-prod
    │   │   ├── kustomization.yaml
    │   │   └── pre-prod-cluster
    │   │       └── kustomization.yaml
    │   └── prod
    │       ├── kustomization.yaml
    │       ├── prod-cluster-lon
    │       │   └── kustomization.yaml
    │       └── prod-cluster-ny
    │           └── kustomization.yaml
    └── tenants
        ├── tenant-a
        │   └── kustomization.yaml
        ├── tenant-b
        │   └── kustomization.yaml
        └── tenant-c
            └── kustomization.yaml
```

Fork the example repository into your organization and clone the forked repo locally.

```
$ git clone https://github.com/<YOUR_ORGANIZATION>/acm-multi-repo-kustomize-sample.git configuration
```

After making changes i.e. adding a new tenant or cluster, you should rebuild the kustomize output by running the `render.sh` script.
```
$ cd scripts
$ ./render.sh
```

Then you can commit and push the update.

```
$ git add .
$ git commit -m 'update configuration'
$ git push origin main
```

Note that in this example, the kustomize output is written into a different
directory on the same branch in the same Git repository. You can also write
the kustomize output into a different Git repository if desired.
