# 02 - Plan Weekend MAJ Auto

## Objectif

Mettre en place une strategie simple, stable et durable pour eviter les lots massifs.

## Phase 1 - Baseline (10 min)

1. Capturer l'etat actuel:
   - `apt list --upgradable`
   - `systemctl list-timers --all | grep -E 'apt|unattended'`
   - `journalctl -u apt-daily-upgrade.service --since '7 days ago'`
2. Noter le nombre de paquets au depart.

## Phase 2 - Activer l'automatisation securite (15 min)

1. Installer unattended-upgrades si absent:
   - `sudo apt-get update`
   - `sudo apt-get install -y unattended-upgrades`
2. Activer la periodicite APT (fichier dedie):
   - `sudo nano /etc/apt/apt.conf.d/20auto-upgrades`
3. Contenu recommande:

```conf
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
```

4. Verifier le service:
   - `sudo systemctl restart apt-daily-upgrade.service`
   - `sudo systemctl status apt-daily-upgrade.service --no-pager`

## Phase 3 - Rythme anti-accumulation (10 min)

1. Conserver auto quotidien pour securite.
2. Ajouter un rituel manuel court 2 fois/semaine:
sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove --purge
3. Proposition de rythme:
   - Mardi soir
   - Samedi matin

## Phase 4 - Validation (10 min)

1. Verifier que la file baisse:
   - `apt list --upgradable`
2. Verifier les logs d'execution auto:
   - `journalctl -u apt-daily-upgrade.service --since '2 days ago'`
3. Si la file reste haute: reviser les depots tiers les plus frequents (Brave, Code, Docker, Edge, Claude).

## Phase 5 - Confort VS Code et icones workspace (15 min)

1. Ajouter une correction globale pour l'icone des fichiers .code-workspace (MIME), afin d'eviter la reaffectation manuelle fichier par fichier.
2. Verifier la persistance sur plusieurs dossiers apres fermeture/reouverture de session.
3. Ajouter les reglages de confort terminal VS Code pour apprentissage visuel:
   - terminal visible en permanence pendant les actions
   - profil terminal par defaut (bash ou PowerShell selon preference)
   - sortie de commande facile a suivre
4. Noter le resultat final dans la recap courte.

## Regle d'exploitation

- Si plus de 10 paquets restent > 72h: lancer la sequence manuelle complete.
- Si MAJ critique noyau/systeme: redemarrer rapidement apres installation.
- Utiliser preferentiellement `apt-get` pour les procedures scriptes.
