# Ticket: M16 — AuthN minimale par clé d’API (post-MVP)

## But
Sécuriser l’API de réservation pour les environnements démo en ajoutant une vérification par clé d’API simple.

## Scope
- apps/api/ (dépendances légères FastAPI)
- tests API
- docs/DEV.md (configuration de la clé)

## Contraintes
- Clé fournie uniquement via variables d’environnement ou secrets k8s (jamais en clair dans Git).
- Appliquer la vérification sur les endpoints réservations ; réponse 401/403 si clé manquante/incorrecte.
- Ne pas changer le contrat JSON des endpoints hors auth.

## Deliverables
- Dépendance/config FastAPI pour vérifier la clé via un header (ex: `X-API-Key`).
- Tests couvrant les cas : clé absente, clé invalide, clé correcte.
- Documentation pour générer/fournir la clé en local, compose, k8s, CI.

## Critères d’acceptation
- [ ] Tous les endpoints réservations refusent sans clé valide.
- [ ] Variables d’environnement/secret nécessaires sont documentées.
- [ ] Tests passent (pytest) en couvrant la sécurité.

## Plan proposé
1) Ajouter un dépendant de sécurité qui valide la clé d’API sur les routes.
2) Étendre la config/échantillons env et les tests pour les scénarios auth.
3) Documenter l’utilisation de la clé en local/k8s/CI.
