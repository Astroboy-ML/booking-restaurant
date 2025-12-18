---
id: "2025-12-16_M22-doc-architecture"
title: "M22 Documentation d’architecture"
type: doc
area: product
agents_required: [product, backend, devops]
depends_on: []
validated_by:
validated_at:
---

## Contexte
La documentation d’architecture est partielle et non structurée : il manque des schémas et descriptions claires des composants API/DB/web, des environnements et des flux CI/CD.

## Objectif
Produire une documentation d’architecture à jour (Markdown + schémas en texte/mermaid/draw.io) couvrant les composants, les flux, les environnements (local/CI/prod) et les dépendances principales.

## Hors scope
- Ajout de nouvelles fonctionnalités applicatives ou refactor du code pour alignement (doc uniquement).
- Modélisation de menaces détaillée ou audits sécurité poussés (peut être référencé mais non livré ici).

## Scope technique
- Pages Markdown dans `docs/` (ex: `ARCHITECTURE.md` ou sous-dossiers) avec schémas (mermaid/diagrams as code ou fichiers sources `.drawio/.svg`).
- Cartographie des environnements (local/CI/prod) incluant points d’entrée (API, front), DB, observabilité prévue, CI/CD.
- Description des flux principaux : requêtes utilisateur → API → DB, build/push d’images, déploiement EKS, gestion des secrets.

## Contraintes
- Documentation synchronisée avec l’état actuel/plannifié (tickets ECR/EKS/secrets) et sans secrets/ARN en clair.
- Schémas versionnés dans le dépôt (fichiers texte ou sources exportables), pas d’images opaques sans source.
- Format partageable (Markdown lisible sur GitHub) avec liens internes.

## Deliverables
- Pages Markdown structurées avec sections claires (composants, environnements, flux, dépendances externes).
- Schémas (mermaid/diagramme source) couvrant API/DB/web, pipelines CI/CD, et déploiement EKS.
- Guide de mise à jour (où éditer les schémas, conventions) ajouté dans la doc.

## Critères d’acceptation
- [ ] Les schémas couvrent API/DB/web, CI/CD (build ECR, déploiement EKS) et observabilité prévue (stack choisie).
- [ ] Chaque environnement (local/CI/prod) est décrit avec endpoints/ports principaux et dépendances.
- [ ] Les fichiers sources des schémas sont présents (mermaid ou équivalent texte) et référencés depuis la doc.
- [ ] La doc ne contient aucun secret ou identifiant sensible et indique comment la mettre à jour.

## Comment tester
1) Ouvrir les pages Markdown ajoutées/éditées et vérifier la présence de liens vers les schémas (mermaid ou fichiers sources).
2) Vérifier la cohérence avec le code existant : `grep -R "DATABASE_URL" apps/api` pour confirmer les dépendances DB, ou `cat k8s/kustomization.yaml` pour valider les composants référencés.
3) S’assurer que les schémas sont lisibles sur GitHub (mermaid rendu ou lien vers fichier `.drawio/.svg` versionné).

## Plan
1) Recenser les composants et flux actuels (API/web/DB, CI/CD, déploiement prévu ECR/EKS, observabilité/secrets en préparation).
2) Produire/mettre à jour les schémas (mermaid/diagrams) et les pages Markdown associées dans `docs/`.
3) Ajouter un guide de maintenance (comment régénérer/éditer les schémas) et vérifier l’absence de secrets/ARN.

## À contrôler
- Cohérence entre la doc et les tickets en cours (ECR/EKS/secrets/observabilité).
- Vérifier que les schémas sont diffables (texte ou source fournie) et non des images opaques sans source.
- S’assurer que les URLs/ports indiqués reflètent l’état réel (Makefile/k8s/compose).
