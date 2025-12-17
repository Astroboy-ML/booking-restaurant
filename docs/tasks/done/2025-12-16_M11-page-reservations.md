# Ticket: M11 — Espace client : réserver et voir ses réservations

## But
Offrir une page React côté client pour créer et lister les réservations du MVP (expérience publique de réservation).

## Scope
- apps/web/ (composants/pages client, service d’appel API)
- docs/DEV.md (URL API, exemple d’appel)

## Contraintes
- Validation côté front : champs requis, `party_size > 0`, `date_time` non vide.
- Gestion d’erreurs API (afficher message pour 4xx/5xx) ; pas d’auth pour l’instant.
- Ne pas modifier le contrat API existant (POST/GET /reservations).

## Deliverables
- Page “Client” avec formulaire (name, date_time, party_size) qui appelle `POST /reservations` et rafraîchit la liste.
- Liste des réservations issue de `GET /reservations` (tri simple, affichage minimal) visible depuis l’espace client.
- Gestion d’état de chargement + erreurs utilisateur friendly.
- Note dans la doc sur la configuration de l’URL backend.

## Critères d’acceptation
- [ ] Créer une réservation depuis le front client l’ajoute et l’affiche dans la liste.
- [ ] La liste se charge au montage de la page et après création.
- [ ] Les erreurs API sont visibles (ex: validation 422, 500).
- [ ] Documentation web mise à jour (URL API, commandes utiles).

## Plan proposé
1) Ajouter un client API configurable via env (axios/fetch) dans apps/web/.
2) Implémenter la page client avec formulaire + liste et gestion des états (loading/error).
3) Tester manuellement avec l’API locale et documenter les réglages.
