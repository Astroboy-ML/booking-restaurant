# Ticket: M10 — Bootstrap frontend React (structure + tooling multi-espaces)

## But
Initialiser l’application web React avec un socle **build/lint/tests** et une **navigation minimale** séparant l’espace **client** (réservation) et l’espace **restaurateur** (gestion).

## Scope
- `apps/web/`
- `Makefile` (cibles `web-*`)
- `docs/DEV.md` (section front)

## Contraintes
- Pas de logique métier avancée (pages squelette et navigation seulement).
- Node **18+** documenté (idéalement “Node 18 LTS”).
- Pas de secrets commités.
- Lint/test **via npm** reliés aux cibles `make web-lint` et `make web-test`.
- L’URL de l’API ne doit **pas** être hardcodée (utiliser une variable d’environnement).

## Choix techniques (imposés)
- React + **Vite** + **TypeScript**
- Routing: `react-router-dom`
- Tests: **Vitest** + React Testing Library
- Lint: **ESLint** (formatting minimal ; pas besoin de Prettier si non souhaité)

## Deliverables
- Squelette React (Vite) avec ESLint + tests (Vitest) **fonctionnels**.
- Routing et pages de base :
  - `/` : Accueil
  - `/client` : Espace client (squelette)
  - `/restaurateur` : Espace restaurateur (squelette)
  - Layout partagé minimal + navigation (liens visibles).
- Scripts npm dans `apps/web/package.json` :
  - `dev`, `build`, `lint`, `test`
- Cibles `Makefile` :
  - `web-lint` → exécute `npm run lint` dans `apps/web`
  - `web-test` → exécute `npm run test -- --run` dans `apps/web`
  - (optionnel mais recommandé) `web-build` → exécute `npm run build` dans `apps/web`
- Documentation dans `docs/DEV.md` :
  - Installation Node + dépendances
  - Commandes `npm` et `make`
  - Variables d’environnement
- Fichier `.env.example` (commit) dans `apps/web/` contenant `VITE_API_URL=...`
  - `.env` doit être ignoré (non commité)

## Critères d’acceptation
- [ ] `cd apps/web && npm run lint` passe en local.
- [ ] `cd apps/web && npm test -- --run` passe en local.
- [ ] `cd apps/web && npm run build` passe en local.
- [ ] `make web-lint` et `make web-test` appellent bien les scripts npm (en se plaçant dans `apps/web`).
- [ ] `npm run dev` affiche l’accueil + navigation vers `/client` et `/restaurateur`.
- [ ] `docs/DEV.md` contient une section Frontend claire + `.env.example` présent.

## Plan proposé
1) Générer l’app React (Vite + TS) + dépendances (router, vitest, testing library, eslint).
2) Ajouter les pages/layout + routes `/`, `/client`, `/restaurateur` + navigation minimale.
3) Configurer scripts npm (dev/build/lint/test) + Makefile (`web-lint`, `web-test`, optionnel `web-build`).
4) Ajouter `.env.example` + documenter l’URL API et les commandes dans `docs/DEV.md`.
