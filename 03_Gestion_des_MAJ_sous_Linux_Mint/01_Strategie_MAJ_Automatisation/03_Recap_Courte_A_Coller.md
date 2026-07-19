# 03 - Recap Courte a Coller

## Resume express

Le 2026-07-16, les MAJ se sont accumulees (environ 21 cote interface, 68 paquets cote APT). Le systeme n'etait pas en panne, mais la pile auto etait incomplete: timers actifs, sans configuration unattended-upgrades exploitable. Resultat: executions quotidiennes tres courtes sans vraie reduction du stock.

## Decision

1. Activer unattended-upgrades pour la securite quotidienne.
2. Ajouter un passage manuel court 2 fois/semaine pour les MAJ completes.
3. Suivre la file upgradable apres chaque cycle.

## Commandes standard

```bash
sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove --purge
apt list --upgradable
```

## Verdict

Strategie retenue: auto + rituel court hebdomadaire. Objectif: ne plus subir de mega MAJ de 30 a 45 minutes.

## Point de controle 2026-07-19

1. File MAJ actuelle: 0 paquet upgradable.
2. Timers actifs confirmes:
	- apt-daily.timer
	- apt-daily-upgrade.timer
3. Etat auto-upgrades:
	- paquet unattended-upgrades non installe
	- fichier /etc/apt/apt.conf.d/20auto-upgrades absent

Conclusion: aucun lot MAJ a traiter ce jour, mais la couche auto securite reste a finaliser.

## Action a faire en 1 bloc (terminal)

```bash
sudo apt-get update
sudo apt-get install -y unattended-upgrades
printf 'APT::Periodic::Update-Package-Lists "1";\nAPT::Periodic::Unattended-Upgrade "1";\nAPT::Periodic::AutocleanInterval "7";\n' | sudo tee /etc/apt/apt.conf.d/20auto-upgrades >/dev/null
sudo systemctl restart apt-daily-upgrade.service
sudo systemctl status apt-daily-upgrade.service --no-pager
journalctl -u apt-daily-upgrade.service --since '2 days ago' --no-pager | tail -n 40
```

## Validation executee (2026-07-19)

1. unattended-upgrades: installe (version 2.9.1+nmu4ubuntu1).
2. Fichier de periodicite: present et conforme.
3. Timers auto: actifs (apt-daily + apt-daily-upgrade).
4. Service apt-daily-upgrade: redemarre puis termine avec succes.
5. File MAJ actuelle: 0 paquet upgradable.

Statut global: mission automation securite validee. On conserve le rituel manuel 2 fois/semaine pour eviter toute accumulation future.

## Rappel persistant login (mardi/samedi)

Mise en place validee via un timer systemd utilisateur.

Comportement:

1. Verification au login Linux puis toutes les 30 minutes.
2. Si cycle MAJ mardi/samedi non acquitte: notification repetee.
3. Si mardi est manque: le rappel continue les jours suivants jusqu'a acquittement.

Commande d'acquittement apres execution de la routine MAJ:

```bash
~/.local/bin/linux_maj_reminder.sh --ack
```

## Correction icones .code-workspace (globale)

Constat:

1. Le MIME est correct: application/x-code-workspace.
2. Le theme Mint-Y-Sand ne fournit pas d'icone MIME native application-x-code-workspace.
3. Le choix manuel d'icone dans Nemo cree un metadata::custom-icon-name par fichier, non global.

Correction appliquee:

1. Ajout d'une icone MIME utilisateur globale application-x-code-workspace dans ~/.local/share/icons/hicolor/*/mimetypes.
2. Rafraichissement du cache d'icones.
3. Ajout aussi du nom symbolic application-x-code-workspace-symbolic pour eviter le fallback blanc selon la vue/zoom Nemo.
4. Suppression des overrides manuels sur les fichiers testes.

Resultat attendu:

- Tous les nouveaux fichiers .code-workspace prennent l'icone VS Code automatiquement sans reaffectation manuelle fichier par fichier.
