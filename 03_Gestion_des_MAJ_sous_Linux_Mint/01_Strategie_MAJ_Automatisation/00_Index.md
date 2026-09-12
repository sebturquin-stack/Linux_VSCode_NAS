# 00 - Index Strategie MAJ Automatisation

Dossier de travail cree suite a l'incident MAJ du 2026-07-16.
Objectif: eliminer les lots de MAJ trop volumineux et fiabiliser la pile automatique.

## Contenu

1. [01_Incident_MAJ_2026-07-16.md](01_Incident_MAJ_2026-07-16.md)
2. [02_Plan_Weekend_MAJ_Auto.md](02_Plan_Weekend_MAJ_Auto.md)
3. [03_Recap_Courte_A_Coller.md](03_Recap_Courte_A_Coller.md)
4. [04_Check_30s_Mardi_Samedi.md](04_Check_30s_Mardi_Samedi.md)
5. [05_Rappel_Persistant_Login.md](05_Rappel_Persistant_Login.md)
6. [06_Plan_Elargissement_Perimetre_Auto.md](06_Plan_Elargissement_Perimetre_Auto.md)

## Resultat attendu

- MAJ securite automatises tous les jours.
- MAJ completes executes sur un rythme court (2 fois par semaine minimum).
- Plus de session surprise de 30 a 45 minutes pour des lots accumules.

## Acces rapide

- Routine MAJ simple (copier-coller): voir `05_Rappel_Persistant_Login.md`, section **Routine simple (copier-coller)**.
- Acquittement rappel apres MAJ: `~/.local/bin/linux_maj_reminder.sh --ack`.
