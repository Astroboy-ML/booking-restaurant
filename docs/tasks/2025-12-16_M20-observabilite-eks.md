# Ticket: M20 — Observabilité EKS (Prometheus + Grafana optionnel)

## But
Collecter les métriques de l’API déployée sur EKS et offrir une visibilité basique via Prometheus (et Grafana optionnel).

## Scope
- k8s/ (charts/manifests observabilité)
- docs/DEV.md (procédure d’installation)

## Contraintes
- Utiliser Helm ou kustomize ; pas d’exposition publique non sécurisée.
- Ciblage des endpoints `/metrics` de l’API uniquement ; compatible kind et EKS.
- Installation désactivable/isolée par environnement.

## Deliverables
- Manifests/Chart pour Prometheus (scrape ServiceMonitor/PodMonitor de l’API).
- (Optionnel) Grafana avec un dashboard HTTP basique (latence, taux de succès).
- Documentation pour installer/accéder (port-forward, commandes helm/kubectl).

## Critères d’acceptation
- [ ] Prometheus scrape `/metrics` et voit des échantillons HTTP.
- [ ] La doc décrit comment accéder aux métriques/dashboards (port-forward).
- [ ] L’installation peut être activée/désactivée selon l’environnement.

## Plan proposé
1) Ajouter les manifests Prometheus (+ ServiceMonitor/PodMonitor) ciblant l’API.
2) (Option) Ajouter Grafana avec dashboard importé et credentials non commités.
3) Documenter l’installation sur kind/EKS et l’accès aux métriques.
