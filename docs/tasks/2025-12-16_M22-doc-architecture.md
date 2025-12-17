# Ticket: M22 — Documentation architecture & ADR

## But
Formaliser l’architecture cible (local, kind, AWS) et consigner les décisions clés via des ADR.

## Scope
- docs/ (nouveau dossier architecture/adr si besoin)
- README.md et docs/DEV.md (liens)

## Contraintes
- Rester aligné avec le Project Charter (API FastAPI, Web React, Postgres, Docker/K8s, Terraform AWS, CI/CD GitHub Actions).
- Au moins deux ADR (ex: choix FastAPI, choix EKS+ECR via Terraform) numérotées et datées.
- Diagramme ou description textuelle des flux (Web → API → DB) et des environnements.

## Deliverables
- Document d’architecture synthétique couvrant dev local (Compose), kind, et cible AWS (ECR/EKS).
- ADR structurées (contexte, décision, conséquences) pour les choix principaux.
- Liens ajoutés depuis README et docs/DEV.md vers la documentation architecture/ADR.

## Critères d’acceptation
- [ ] Les ADR sont présentes, datées, numérotées et référencées.
- [ ] L’architecture décrit clairement les composants et flux pour local/kind/AWS.
- [ ] README/docs renvoient vers la nouvelle documentation.

## Plan proposé
1) Rédiger un document d’architecture (diagramme texte ou image) couvrant local, kind et AWS.
2) Écrire au moins deux ADR sur les choix majeurs (stack API, infra EKS/ECR Terraform).
3) Ajouter les liens vers ces documents dans README et docs/DEV.md.
