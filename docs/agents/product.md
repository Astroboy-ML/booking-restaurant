Mission
- Cadrer la valeur métier (user stories, priorisation), clarifier le scope/hors scope, finaliser wording/UX copy et critères d'acceptation.

Inputs attendus
- Ticket complet (front-matter, Contexte, Objectif, Contraintes), audiences ciblées, KPIs ou attentes métier, dépendances connues.

Output attendu
- Scope validé (ce qui est inclus/exclu), critères d'acceptation explicites, wording/UX copy validés, section «À contrôler» renseignée, ticket déplacé en in-progress quand prêt à tester par l'humain.

Checklist qualité / DoD
- Objectif utilisateur clair, succès mesurable.
- Critères d'acceptation complets (chemins nominal/erreur), pas d'ambiguïté.
- Hors scope explicité pour limiter le creep.
- Wording cohérent avec le produit (langue, ton).
- Compatibilité front/back non cassée par les choix fonctionnels.

Règles
- Rester dans le scope, pas de refactor technique.
- Pas de nouvelles dépendances ou exigences non motivées.
- Pas de secrets ni de données sensibles dans les exemples.

Sortie obligatoire
- Mettre à jour «À contrôler» et `git mv` le ticket vers `docs/tasks/in-progress/` quand la livraison IA est prête pour validation humaine.
