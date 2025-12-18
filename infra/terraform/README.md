## Terraform bootstrap

Ossature Terraform AWS sans création de ressources par défaut. Backend S3 activable via `-backend-config` (ou variables Makefile).

### Prérequis
- Terraform >= 1.6
- Auth AWS via SSO/OIDC/env (`AWS_PROFILE`, `AWS_REGION`, ou clés temporaires) ; aucun secret/ARN dans le dépôt
- Accès réseau au registry Terraform pour télécharger les providers

### Structure
- `versions.tf` : contrainte Terraform + provider AWS
- `providers.tf` : provider AWS (région via variable)
- `backend.tf` / `backend-s3.tf.example` / `backend.example.hcl` : backend local ou S3 configuré via flags
- `variables.tf` : variables régionales + EKS/VPC/nodegroup
- `vpc.tf`, `iam.tf`, `eks.tf` : VPC/subnets/IGW (NAT optionnel), rôles IAM, cluster EKS + node group
- `outputs.tf` : région, cluster, VPC/subnets, rôle nodegroup
- `examples/eks-dev.tfvars` : exemple tfvars (aucun secret)

### Commandes de base
```sh
cd infra/terraform
terraform init -backend=false
terraform fmt -check
terraform validate
```

Plan (sans apply) avec backend distant :
```sh
terraform init \
  -backend-config="bucket=<bucket>" \
  -backend-config="region=<region>" \
  -backend-config="dynamodb_table=<table>"

terraform plan -input=false
```

### EKS skeleton (cluster + nodegroup + VPC)
- Variables clés : `cluster_name`, `eks_version`, `vpc_cidr`, `azs`, `public_subnets_cidrs`, `private_subnets_cidrs`, `enable_nat_gateway` (coûts), `enable_public_api_endpoint`, `node_instance_types`, `node_desired_capacity`/`min_size`/`max_size`, `cluster_tags`.
- Exemple : `examples/eks-dev.tfvars` (région eu-west-3, VPC 10.10.0.0/16, 2 AZs, NAT désactivé par défaut).
- IAM : rôles EKS/NodeGroup avec politiques gérées (cluster, VPC controller, worker, CNI, ECR read-only).
- Logs : `cluster_log_types` (api, audit par défaut).
- NAT : `enable_nat_gateway=false` par défaut pour éviter les coûts ; à activer si les nœuds privés ont besoin d’egress.

### Via Makefile (depuis la racine)
```sh
make tf-fmt
make tf-validate          # init -backend=false + validate
make tf-plan              # init -backend=false par défaut

# Backend S3 (exemple)
TF_BACKEND_BUCKET=my-bucket \
TF_BACKEND_REGION=eu-west-3 \
TF_BACKEND_DYNAMODB_TABLE=tf-locks \
make tf-plan

# Plan EKS avec tfvars
terraform -chdir=infra/terraform plan -var-file=examples/eks-dev.tfvars
```

### Entrées attendues / conventions
- ECR : utiliser le registry/repo issus de M17 (ex: `<account>.dkr.ecr.<region>.amazonaws.com/booking-api:sha`).
- IAM/OIDC : rôle assume-role pour Terraform (pas d’ARN en clair ici) ; OIDC EKS disponible via l’output `cluster_oidc_issuer`.
- Réseau : fournir des CIDR cohérents avec `azs`; NAT à activer explicitement si nécessaire (coûts).
- Naming : préfixe `booking-` dans l’exemple, à adapter via `cluster_name` et `cluster_tags`.

### Tests / dry-run
- Sans AWS creds, `terraform plan` échouera (attendu). Avec des creds : `terraform -chdir=infra/terraform plan -var-file=examples/eks-dev.tfvars`.
- Contrôles manuels recommandés : rôle OIDC disponible (`cluster_oidc_issuer`), NAT désactivé par défaut, endpoints EKS publics ou privés selon `enable_public_api_endpoint`.

### Notes
- Aucun secret/ARN/ID sensible en clair ; tout passe par variables ou role assume.
- Pas de `apply` dans ce ticket ; uniquement fmt/validate/plan. 
