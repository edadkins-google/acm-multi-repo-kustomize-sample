# Configuration and Policy as Data with Anthos Config Management

[Anthos Config Management](https://cloud.google.com/anthos/config-management) demo with the following functionality:

1. Provision three GKE clusters and enable ACM via the Hub Feature API using Terraform
2. Hydrate manifests from a set of Dry configs using Kustomize (typically undertaken Platform Engineering teams using the RootSync resource)
3. Each tenant can deploy to clusters using their own repository (typically this would be App teams using the RepoSync resource)
4. Tenants can provision their application dependant GCP Services using a KRM approach with the Kubernetes Config Connector
5. Ensure Kubernetes resources adhere to a set of policy contracts using the Policy Controller

## Getting Started

### Prerequisites/Requirements
This section describes prerequisites you must meet before this tutorial.
- `terraform` is installed on your machine.
- `git` is installed on your machine.
- `kustomize` is installed in your local machine. If not, you can install it by `gcloud components install kustomize`.

### Get the example configuration
The example Git repository contains three namespaces for different tenants, three clusters across three different environments. The repository contains the following directories and files.
```
config-root
├── base
│   ├── cluster
│   │   ├── connect-gateway
│   │   │   ├── admin-permission.yaml
│   │   │   └── impersonate.yaml
│   │   ├── kcc
│   │   │   ├── configconnector.yaml
│   │   │   └── kustomization.yaml
│   │   ├── kustomization.yaml
│   │   └── policies
│   │       ├── K8sPSPCapabilities.yaml
│   │       └── K8sRequiredLabels.yaml
│   └── namespace
│       ├── kustomization.yaml
│       ├── namespace.yaml
│       ├── reposync.yaml
│       ├── role.yaml
│       └── rolebinding.yaml
├── environments
│   ├── dev
│   │   └── dev-cluster
│   │       └── kustomization.yaml
│   ├── preprod
│   │   └── preprod-cluster
│   │       └── kustomization.yaml
│   └── prod
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

### Provision GCP services

Run the `provision.sh` helper script with the `-c` flag to provision the following services in your GCP project:
- Three GKE clusters (dev-cluster, preprod-cluster, prod-cluster-lon)
- Register the clusters to the GKE Hub
- Enable and configure ACM for the clusters

```
$ cd scripts
$ ./provision.sh -c
```

You'll be prompted to enter your GCP Project Id and your forked Git URL i.e. `https://github.com/<YOUR_ORGANIZATION>/acm-multi-repo-kustomize-sample.git`.

The provisioning should take <30 mins, once complete, there will be three GKE clusters, with ACM deployed and successfully synced to your Git repo.

Once completed, render your manifests and commit the updates to your repo, this ensures your Project ID is updated in the manifests for the Config Connector to work correctly. 

```
$ ./render.sh
$ git commit -am 'update configuration'
$ git push origin main
```

### Make changes to your Cluster's configuration

After making changes i.e. adding a new tenant or resource, you should hyrdrate your manifests by running the `render.sh` script.
```
$ ./render.sh
```

Then you can commit and push the update.

```
$ git commit -am 'update configuration'
$ git push origin main
```

### Synchronise resources from a Tenants repository

[Tenant A's repository](https://github.com/ejmadkins/acm-multi-repo-tenant-a) has already been provisioned for you with a few example resources in the dev branch.  We can verify that Tenant A's various resources have been synchronised to the cluster successfully.

```
$ kubectl get role,rolebinding,storagebucket,networkpolicy -n tenant-a
```

For more advanced users, update the tenant's Kustomize file to point to your own tenant repo and sync your own resources.

### Synchronise resources from a Tenants repository

Tenant A's repository includes a Custom Resource for Google Cloud Storage that the Kubernetes Config Connector will use to provision a new bucket.  Verify that the `StorageBucket` Custom Resource has synced successfully to the cluster.

```
$ kubectl get storagebucket -n tenant-a
```

Check out the Google Cloud Storage section of the GCP console to verify that the bucket has been created.

### Test policy contracts

The `policy-example` directory contains two manifests (`out-of-policy.yaml` and `in-policy.yaml`), execute the following and verify in the Workloads section of the GKE dashboard that the Pod violates a policy constraint.

```
$ kubectl apply -f out-of-policy.yaml
```

To fix this, apply the `in-policy.yaml` manifest.

## Expanding this demo

Note that in this example, the kustomize output is written into a different directory on the same branch in the same Git repository. You could use the `render.sh` script within a pipeline, that writes the output of `kustomize build` i.e. the deploy directory to a different Git repository, separated by branches per environment.
