## Terraform bootstrap

Ossature Terraform AWS sans création de ressources. Compatible avec `terraform init -backend=false` pour le travail local, et backend S3 activable via `-backend-config` (ou variables Makefile).

### Prérequis
- Terraform >= 1.6
- Auth AWS via SSO/OIDC/env (`AWS_PROFILE`, `AWS_REGION`, ou clés temporaires) ; aucun secret/ARN dans le dépôt
- Accès réseau vers le registry Terraform pour télécharger les providers

### Structure
- `versions.tf` : contrainte Terraform + provider AWS
- `providers.tf` : provider AWS (région via variable)
- `backend.tf` : placeholder local (backend désactivé par défaut)
- `backend-s3.tf.example` : squelette backend S3 à copier/utiliser avec `-backend-config`
- `backend.example.hcl` : exemple HCL pour `terraform init -backend-config=backend.example.hcl`
- `variables.tf` : variables régionales/backend
- `outputs.tf` : sortie de la région active

### Commandes Terraform
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

### Via Makefile (depuis la racine)
```sh
make tf-fmt
make tf-validate          # init -backend=false par défaut
make tf-plan              # init -backend=false par défaut

# Activer un backend S3 (variables Makefile)
TF_BACKEND_BUCKET=my-bucket \
TF_BACKEND_REGION=eu-west-3 \
TF_BACKEND_DYNAMODB_TABLE=tf-locks \
make tf-plan

# Ou passer directement une config backend personnalisée
TF_BACKEND_CONFIG='-backend-config="bucket=<bucket>" -backend-config="region=<region>"' \
make tf-plan
```

### Notes
- Aucun nom de bucket/ARN/secrets en dur ; toujours passer via variables ou `-backend-config`.
- Pas de cible `apply` exposée dans ce ticket.
