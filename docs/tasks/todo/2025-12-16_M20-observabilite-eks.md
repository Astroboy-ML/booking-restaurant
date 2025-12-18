---
id: "2025-12-16_M20-observabilite-eks"
title: "M20 Observabilité sur EKS"
type: feature
area: devops
agents_required: [devops]
depends_on: ["2025-12-16_M19-deploy-eks"]
validated_by:
validated_at:
---

## Contexte
Après le déploiement de l’API sur EKS, aucune stack d’observabilité n’est définie. Il faut collecter logs/metrics/traces avec un coût maîtrisé et des dashboards/alertes de base.

## Objectif
Mettre en place une stack d’observabilité sur EKS (Prometheus/Grafana/CloudWatch/OTel selon choix retenu) permettant de visualiser les métriques API, centraliser les logs et créer une alerte minimale.

## Hors scope
- Observabilité applicative avancée (tracing business détaillé) ou dashboards métier.
- Refactor de l’application pour exposer de nouvelles métriques (se limiter aux métriques existantes ou ajout léger).
- Gestion des coûts CloudWatch/AWS au-delà des recommandations de base (pas d’engagement long terme).

## Scope technique
- Manifests/Helm pour la stack retenue (ex: kube-prometheus-stack ou CloudWatch/FluentBit/OTel collector) adaptée à EKS.
- Intégration des métriques existantes de l’API (endpoint Prometheus) et collecte des logs applicatifs.
- Création d’au moins un dashboard et une alerte basique (taux d’erreur ou disponibilité) avec documentation d’accès.

## Contraintes
- Budget maîtrisé : sizing minimal et composants managés privilégiés si disponible.
- Pas de secrets en clair ; credentials/ARN passés via Secrets/IRSA/roles.
- Compatibilité avec les manifests de déploiement (namespace, labels) et avec les probes existantes.

## Deliverables
- Manifests/Helm charts pour la stack d’observabilité et leur configuration (namespace, values/overlays).
- Un dashboard d’exemple et au moins une alerte configurée/documentée.
- Documentation pour accéder aux dashboards/logs et ajuster les alertes (ports/URLs/roles nécessaires).

## Critères d’acceptation
- [ ] Les métriques de l’API sont collectées et visibles dans un dashboard (capture ou commande de vérification documentée).
- [ ] Les logs applicatifs sont centralisés dans la stack choisie (commande de consultation fournie).
- [ ] Une alerte basique est configurée (ex: taux d’erreur HTTP > seuil) et son test ou son mode de validation est documenté.
- [ ] La procédure d’installation/rollback est décrite, sans secret en clair.

## Comment tester
1) `kubectl apply --dry-run=client -k <overlay_observability>` (ou `helm template --validate`) pour vérifier les manifests.
2) Déployer sur un cluster de test puis vérifier les métriques : `kubectl -n <ns> port-forward svc/grafana 3000:80` et consulter le dashboard d’exemple.
3) Vérifier la collecte de logs : `kubectl -n <ns> logs -l app.kubernetes.io/name=<collector>` ou requête dans l’outil (CloudWatch/Prometheus/Grafana Loki).
4) Tester l’alerte en simulant des erreurs (ou en baissant le seuil) et vérifier la notification ou l’état de l’alerte.

## Plan
1) Choisir la stack (Prom/Grafana/OTel ou CloudWatch) adaptée à EKS et l’installer via Helm/manifests avec sizing minimal.
2) Brancher l’API : scrape metrics, collecte de logs, configuration d’IRSA/Secrets si nécessaire.
3) Créer un dashboard et une alerte minimale ; documenter l’accès, le test et le rollback.

## À contrôler
- Coût estimé de la stack (logs/metrics/storage) documenté ou borné.
- Compatibilité avec le namespace/labels de l’API pour que le scraping fonctionne.
- Absence de credentials statiques ; préférer IRSA/roles.
