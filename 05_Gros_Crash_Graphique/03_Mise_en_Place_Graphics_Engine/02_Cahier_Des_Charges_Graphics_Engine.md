# Cahier des charges - Graphics Engine

## 1. Mission

Le Graphics Engine doit fournir un cadre de stabilisation, de sauvegarde, de validation et de restauration du moteur graphique Linux Mint/Cinnamon.

## 2. Objectif principal

Eviter qu'une optimisation graphique, un reglage Cinnamon, un tweak Muffin ou un applet tiers puisse degrader durablement la session graphique sans possibilite de retour rapide.

## 3. Resultat attendu

- Une baseline stable connue et restorable.
- Un pipeline de changement garde.
- Un rollback rapide vers le dernier etat sain.
- Des backups horodates du moteur graphique.
- Une trace technique exploitable apres incident.

## 4. Perimetre

Le Graphics Engine couvre au minimum:

- dconf sous /org/cinnamon/
- /home/sebastien/.config/cinnamon/
- /home/sebastien/.local/share/cinnamon/
- /home/sebastien/.themes/
- /home/sebastien/.icons/

## 5. Exclusions

Le Graphics Engine ne doit pas modifier automatiquement:

- les pilotes GPU
- les paquets systeme
- la configuration noyau
- la pile graphique systeme root

Ces elements peuvent etre documentes ou diagnostiques, mais pas forces sans validation explicite.

## 6. Regles de securite

- Toute optimisation doit etre appliquee seule.
- Toute optimisation doit etre precedee d'un backup.
- Toute optimisation doit disposer d'un rollback prepare.
- Toute optimisation doit etre validee visuellement avant confirmation.
- En absence de confirmation, le changement doit etre considere comme non fiable.

## 7. Baseline officielle

La baseline officielle initiale du Graphics Engine est l'etat actuel restaure et stabilise du 2026-07-10, sauf remplacement explicite par une baseline plus recente apres validation.

## 8. Pipeline de changement

1. Backup complet du moteur graphique.
2. Application gardee d'un seul changement.
3. Verification visuelle et fonctionnelle.
4. Confirmation manuelle si la session est saine.
5. Rollback automatique ou manuel en cas d'echec.
6. Promotion en nouvelle baseline seulement apres validation stable.

## 9. Criteres de sante minimum

- La session Cinnamon se relance normalement.
- Les panels sont presents.
- Le menu principal fonctionne.
- Les applets critiques sont chargees.
- Le theme et les icones sont corrects.
- Aucun artefact graphique majeur n'apparait.
- Aucun besoin de recovery lourd ne doit etre necessaire.

## 10. Livrables obligatoires

- Structure numerotee du Graphics Engine.
- Scripts gardiens numerotes.
- Rapport de sante graphique.
- Backups horodates.
- Documentation numérotee de la baseline et de la strategie.

## 11. Regle d'evolution

Une optimisation n'entre dans la baseline que si:

- elle est testee seule
- elle ne provoque pas de regression visible
- elle reste stable pendant la fenetre de validation decidee
- son rollback a deja ete prouve
