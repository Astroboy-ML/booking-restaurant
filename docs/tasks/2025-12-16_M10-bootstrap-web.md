# Ticket: M10 — Bootstrap frontend React (structure + tooling multi-espaces)

## But
Initialiser l’application web React avec le socle lint/tests et une navigation minimale séparant l’espace client (réservation) et l’espace restaurateur (gestion).

## Scope
- apps/web/
- Makefile (cibles web-*)
- docs/DEV.md (section front)

## Contraintes
- Pas de logique métier avancée (pages squelette et navigation seulement).
- Node 18+ documenté ; pas de secrets commités.
- Lint/test via npm reliés aux cibles `make web-lint` et `make web-test`.

## Deliverables
- Squelette React (Vite ou équivalent) avec eslint + tests (vitest/jest) fonctionnels.
- Navigation/pages de base : accueil, lien vers espace client et espace restaurateur (sections vides mais routées), layout partagé minimal.
- Scripts npm `lint`, `test`, `dev` et cibles Makefile correspondantes.
- README ou section docs/DEV.md détaillant installation, variables d’environnement (URL API) et commandes.

## Critères d’acceptation
- [ ] `npm run lint` et `npm test` passent en local.
- [ ] `make web-lint` et `make web-test` appellent bien les scripts npm.
- [ ] Lancer `npm run dev` affiche les pages client/restaurateur accessibles via la navigation.
- [ ] Documentation front ajoutée/à jour.

## Plan proposé
1) Générer l’app React + config lint/test minimaliste.
2) Ajouter les scripts npm, cibles Makefile `web-lint`/`web-test` et la navigation client/restaurateur.
3) Documenter l’installation, l’URL de l’API et les commandes dans docs/DEV.md.
