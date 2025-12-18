# Terraform bootstrap

Base Terraform pour AWS, sans creation de ressources. Cette configuration se contente de verrouiller les versions (Terraform 1.8, provider AWS 5.x) et expose un backend S3 parametrable pour preparer les travaux ECR/EKS.

## Prerequis
- Terraform 1.8+
- Acces AWS par OIDC ou variables d'environnement standard (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`), uniquement pour les commandes ayant besoin du provider.
- Aucun secret ou ARN ne doit etre committe. Fournir les valeurs via l'environnement ou un fichier backend local.

## Backend S3 parametrable
Le bloc backend est volontairement vide et doit etre renseigne au moment du `terraform init` via `-backend-config`. Exemple de fichier `backend.example.hcl` :

```hcl
bucket         = "<your-s3-bucket>"
key            = "terraform.tfstate"
region         = "<aws-region>"
dynamodb_table = "<optional-dynamodb-table>"
encrypt        = true
```

Appliquer le fichier :

```bash
terraform -chdir=infra/terraform init -backend-config=backend.example.hcl
```

Pour un travail purement local (fmt/validate), preferer :

```bash
terraform -chdir=infra/terraform init -backend=false
```

## Variables exposes
- `aws_region` : region AWS (defaut `eu-west-3`).
- `default_tags` : tags par defaut ajoutes aux ressources eventuelles.

## Commandes utiles
- `make tf-fmt` : `terraform fmt -check` dans `infra/terraform`.
- `make tf-validate` : `terraform init -backend=false` puis `terraform validate`.
- `make tf-plan` : `terraform init` (backend configurable via variables d'environnement) puis `terraform plan`.

### Exemple de plan sans appliquer
```bash
TF_BACKEND_BUCKET=my-tfstate-bucket \
TF_BACKEND_REGION=eu-west-3 \
TF_BACKEND_DYNAMODB_TABLE=tf-locks \
make tf-plan TF_PLAN_ARGS="-out=plan.tfplan"
```

Cette sequence reste sans effet sur AWS tant qu'aucun `terraform apply` n'est lance.
