# Convention Definitive Des Messages De Commit

## Objectif

Garder un historique lisible, actionnable et facilement reversible.

## Format Standard

Type(scope): resume court a l imperatif

Corps optionnel:

- Pourquoi
- Ce qui change
- Impact/risque

Footer optionnel:

- Refs: ticket, note, incident, date

## Types Autorises

- Docs: documentation, notes, procedures, plans
- Feat: nouvelle fonctionnalite
- Fix: correction de bug ou comportement incorrect
- Refactor: reorganisation sans changement fonctionnel
- Chore: maintenance technique, nettoyage, outillage
- Ops: scripts, automatisation, supervision, exploitation
- Backup: snapshots, exports, fichiers de restauration

## Regles Simples

- Un seul theme par commit.
- Sujet <= 72 caracteres quand possible.
- Sujet clair et specifique, jamais "update" seul.
- Le scope est recommande pour les gros dossiers.
- Commits incrementaux et atomiques: chaque commit doit etre comprenable seul.

## Scopes Recommandes Dans Ce Depot

- cinnamon
- graphics-engine
- updates
- devops-structure
- backup-dconf
- crash-graphique

## Exemples Valides

- Docs(graphics-engine): ajoute consolidation apres tweak 5
- Backup(backup-dconf): ajoute snapshot post-recovery 2026-07-06
- Ops(updates): ajoute script de controle de pile MAJ
- Fix(cinnamon): corrige filtre rsync sans BOM
- Chore(devops-structure): reordonne les dossiers de reference

## Workflow Recommande

1. Regrouper les changements par theme.
2. Verifier avec git status puis git diff --staged.
3. Commiter avec sujet clair.
4. Pousser apres une serie coherente de commits.

## A Eviter

- Melanger docs + scripts + restauration dans le meme commit sans raison.
- Commits geants sans separation logique.
- Messages vagues: "fix", "update", "wip" sans contexte.
