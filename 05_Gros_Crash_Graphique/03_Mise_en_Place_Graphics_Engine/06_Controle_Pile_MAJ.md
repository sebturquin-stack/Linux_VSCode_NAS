# Controle de pile MAJ (avant tweak graphique)

## Objectif

Verifier rapidement si les mises a jour en attente peuvent impacter la stabilite graphique avant de continuer les tweaks gardes.

## Commande simple

```bash
/home/sebastien/01_Infra/06_Services/08_Graphics_Engine/07_Scripts/07_check_update_stack.sh
```

La commande retourne un chemin de rapport dans:

- /home/sebastien/01_Infra/06_Services/08_Graphics_Engine/05_Health_Checks/

## Lecture rapide du rapport

1. [upgradable]: liste des paquets en attente.
2. [holds]: paquets volontairement bloques.
3. [timers]: etat des timers apt-daily.
4. [unattended_upgrades_pkg]: presence du mode auto-upgrades.
5. [sensitive_candidates]: paquets a risque graphique/boot (fwupd, ovmf, plymouth, xorg, muffin, cinnamon, etc.).

## Regle pratique

- Si des paquets sensibles sont presents:
  - consolider d'abord la baseline
  - appliquer les MAJ sensibles a part
  - revalider la sante graphique
- Si les MAJ sont surtout applicatives/securite usuelles:
  - possible de continuer les tweaks gardes
  - faire la MAJ en fenetre dediee ensuite

## Etat actuel (constate ensemble)

- MAJ en attente: nombreuses MAJ usuelles + quelques paquets sensibles (fwupd/ovmf/plymouth)
- Holds actifs utiles pour la stabilite graphique:
  - cinnamon-session
  - cinnamon-session-common
  - libxapp1
  - nemo
  - xapps-common
