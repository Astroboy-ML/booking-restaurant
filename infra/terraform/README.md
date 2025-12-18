## Terraform bootstrap

Ossature Terraform AWS sans création de ressources par défaut. Backend local par défaut (désactivable avec `-backend=false`), backend S3/DynamoDB activable via `-backend-config` ou variables Makefile.

### Prérequis
- Terraform >= 1.6
- Auth AWS via SSO/OIDC/env (`AWS_PROFILE`, `AWS_REGION`, ou clés temporaires) ; aucun secret/ARN dans le dépôt
- Accès réseau au registry Terraform pour télécharger les providers

### Structure
- `versions.tf` : contrainte Terraform + provider AWS
- `providers.tf` : provider AWS (région via variable)
- `backend.tf` / `backend-s3.tf.example` / `backend.example.hcl` : backend local ou S3 configuré via flags
- `variables.tf` : variables régionales + EKS/VPC/nodegroup + rôles IAM
- `vpc.tf`, `iam.tf`, `eks.tf` : VPC/subnets/IGW (NAT optionnel), rôles IAM, cluster EKS + node group
- `outputs.tf` : région, cluster, VPC/subnets, rôle nodegroup
- `examples/eks-dev.tfvars` : exemple tfvars (aucun secret)

### Commandes de base
```sh
cd infra/terraform
# Backend local désactivé :
terraform init -backend=false

# Mise en forme / validation
terraform fmt -recursive
terraform validate

# Plan avec un tfvars spécifique (sans backend distant)
terraform plan -var-file=examples/eks-dev.tfvars
```

Plan (sans apply) avec backend distant sécurisé :
```sh
terraform init \
  -backend-config="bucket=<bucket>" \
  -backend-config="region=<region>" \
  -backend-config="dynamodb_table=<table>"

terraform plan -input=false -var-file=<env>.tfvars
```

### EKS skeleton (cluster + nodegroup + VPC)
- Variables clés : `cluster_name`, `eks_version`, `vpc_cidr`, `azs`, `public_subnets_cidrs`, `private_subnets_cidrs`, `enable_nat_gateway` (coûts), `enable_private_api_endpoint`, `enable_public_api_endpoint`, `node_instance_types`, `node_desired_capacity`/`min_size`/`max_size`, `eks_cluster_role_name` / `eks_node_role_name`, `cluster_tags`.
- Exemple : `examples/eks-dev.tfvars` (région eu-west-3, VPC 10.10.0.0/16, 2 AZs, NAT désactivé par défaut, endpoint public configurable).
- IAM : rôles EKS/NodeGroup avec politiques gérées (cluster, VPC controller, worker, CNI, ECR read-only) ; noms overridables par variables.
- Logs : `cluster_log_types` (api, audit par défaut).
- NAT : `enable_nat_gateway=false` par défaut pour éviter les coûts ; à activer si les nœuds privés ont besoin d’egress.

#### Variables principales (réseau, sizing, rôles)
| Variable | Description | Exemple / défaut |
| --- | --- | --- |
| `aws_region` | Région AWS ciblée | `eu-west-3` |
| `default_tags` | Tags appliqués à toutes les ressources | `{ project = "booking-restaurant", env = "sandbox" }` |
| `cluster_name` | Nom du cluster et préfixe pour les ressources | `booking-eks-dev` |
| `eks_version` | Version EKS | `1.30` |
| `eks_cluster_role_name` | Nom IAM du rôle control plane (override) | `booking-eks-dev-eks-role` par défaut si non fourni |
| `vpc_cidr` | CIDR du VPC | `10.10.0.0/16` |
| `azs` | Liste des AZ utilisées (ordre = subnets) | `["eu-west-3a", "eu-west-3b"]` |
| `public_subnets_cidrs` / `private_subnets_cidrs` | CIDR des subnets publics/privés alignés sur `azs` | `["10.10.0.0/20", "10.10.16.0/20"]` |
| `enable_nat_gateway` | Active un NAT pour les subnets privés (coûts) | `false` par défaut |
| `enable_private_api_endpoint` | API EKS accessible en privé dans le VPC | `true` |
| `enable_public_api_endpoint` | API EKS publique (true) ou privée uniquement (false) | `true` |
| `cluster_log_types` | Logs control plane activés | `["api", "audit"]` |
| `node_group_name` | Nom du node group managé | `booking-ng-dev` |
| `eks_node_role_name` | Nom IAM du rôle nodes (override) | `booking-eks-dev-node-role` par défaut si non fourni |
| `node_instance_types` | Types d’instances des nœuds | `["t3.small"]` |
| `node_desired_capacity` / `node_min_size` / `node_max_size` | Autoscaling du node group | `2 / 1 / 3` |
| `cluster_tags` | Tags additionnels appliqués aux ressources | `{ environment = "dev" }` |

> Aucun ARN ou secret n’est codé en dur : les rôles IAM utilisent des policies managées et doivent être assumés via vos credentials/assume-role au moment du plan.

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
- Réseau : fournir des CIDR cohérents avec `azs`; NAT à activer explicitement si nécessaire (coûts). Endpoint public ajustable via `enable_public_api_endpoint` ; endpoint privé contrôlé par `enable_private_api_endpoint`.
- Naming : préfixe `booking-` dans l’exemple, à adapter via `cluster_name` et `cluster_tags`.

### Tests / dry-run & checklist
- Sans AWS creds, `terraform plan` échouera (attendu). Avec des creds : `terraform -chdir=infra/terraform plan -var-file=examples/eks-dev.tfvars`.
- Contrôles manuels recommandés après un plan valide :
  - `terraform output` : vérifier `cluster_name`, `cluster_endpoint`, `cluster_oidc_issuer` (OIDC activé), `vpc_id`, `public_subnets`, `private_subnets`, `node_group_role_arn`.
  - Backend verrouillé : bucket + table DynamoDB référencés dans `terraform init`.
  - Absence de secrets : aucune clé/ARN codée en dur, variables seulement.

### Notes
- Aucun secret/ARN/ID sensible en clair ; tout passe par variables ou role assume.
- Pas de `apply` dans ce ticket ; uniquement fmt/validate/plan.
- L’agent ne peut pas utiliser ni recevoir vos identifiants AWS : exécutez localement les commandes ci-dessus avec vos creds/assume-role, puis partagez uniquement les erreurs (sans données sensibles) pour support.
