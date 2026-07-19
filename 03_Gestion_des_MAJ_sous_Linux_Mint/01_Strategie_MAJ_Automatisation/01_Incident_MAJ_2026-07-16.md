# 01 - Incident MAJ du 2026-07-16

## Contexte vecu

- Le systeme affichait environ 21 MAJ cote interface Mint, puis 68 paquets upgradables cote APT.
- Sensation de pile MAJ inefficace: MAJ trop nombreuses et trop longues quand lancees manuellement.
- Plusieurs essais de lancement depuis terminal VS Code ont ete interrompus, puis relances en manuel.

## Ce qui a ete verifie

1. Etat de Cinnamon et logs systeme: pas de crash critique lie aux MAJ.
2. Processus APT/dpkg: pas de verrou bloque permanent.
3. Timers systemd:
   - apt-daily.timer actif
   - apt-daily-upgrade.timer actif
4. Config auto-upgrades:
   - fichiers classiques unattended-upgrades absents
   - service quotidien present mais execution tres courte (environ 1 seconde), sans installation massive effective

## Pourquoi c'etait confus

1. Le wrapper `apt` de Linux Mint est plus sensible a certaines formes de commande.
2. Une commande peut afficher l'aide au lieu d'executer le full-upgrade si la syntaxe n'est pas interpretee comme prevu.
3. En mode assistant, toute annulation utilisateur stoppe immediatement l'execution.
4. Le mot de passe sudo doit toujours etre saisi directement dans le terminal actif.

## Conclusion technique

- Linux n'est pas en panne.
- Le comportement observe vient surtout d'une automatisation incomplete + grand nombre de depots actifs + execution manuelle irreguliere.
- Sans strategie explicite, les MAJ s'accumulent et forment des lots longs.
