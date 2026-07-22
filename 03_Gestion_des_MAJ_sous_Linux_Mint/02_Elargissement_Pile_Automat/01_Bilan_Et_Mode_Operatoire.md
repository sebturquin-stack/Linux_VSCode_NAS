# 01 - Bilan Et Mode Operatoire

Date: 2026-07-22

## 1) Ce qui a ete change

### 1.1 Elargissement de la couche quotidienne unattended-upgrades

Le perimetre auto a ete elargi dans `/etc/apt/apt.conf.d/50unattended-upgrades` pour inclure:

- `Linuxmint:zena`
- `Linuxmint:zena-security`
- `Ubuntu:noble-security`
- `Ubuntu:noble-updates`

Effet:

- Les MAJ Ubuntu de securite et de maintenance courante ne restent plus bloquees hors perimetre.
- Les depots tiers restent exclus du quotidien (comportement voulu).

### 1.2 Validation reelle effectuee

Validation faite avec `sudo unattended-upgrade --debug`.

Constat principal:

- Les paquets Ubuntu eligibles ont ete installes en plusieurs lots (krb5, gstreamer, libgif7, tar, libfprint, libhtml-parser-perl, etc.).
- Fin de cycle propre: `left to upgrade set()` puis `Toutes les mises a niveau ont ete installees`.
- Stock final: il reste 2 paquets tiers (`brave-browser`, `claude-desktop-unofficial`).

### 1.3 Fiabilisation du rappel mardi/samedi

Le script de rappel `linux_maj_reminder.sh` a ete renforce:

- trace `notified=OUI/NON` dans le log,
- fallback `gdbus` si `notify-send` ne sort pas la notification GUI.

Effet:

- meilleure observabilite du rappel,
- meilleure fiabilite d'affichage selon la session graphique.

### 1.4 Durcissement du script hebdo perso

Script durci: `/home/sebastien/01_Infra/02_Scripts/02_System_Update/apt_auto_update.sh`

Changements:

- passage de `apt` a `apt-get` (CLI stable pour script),
- ajout d'un `apt-get update` avant upgrade,
- passage en non-interactif (`DEBIAN_FRONTEND=noninteractive`),
- inventaire avant/apres avec `apt list --upgradable`,
- metriques loguees:
  - `before_upgradable_count`,
  - `after_upgradable_count`,
  - `upgraded_delta`,
- ajout d'un `apt-get -y autoremove --purge` en fin de cycle,
- notification finale enrichie avec compte avant/apres.

Effet:

- audit hebdo beaucoup plus lisible,
- moins de risque de blocage interactif,
- meilleure preuve de resultat a chaque passage.

## 2) Comment la nouvelle pile fonctionne

## 2.1 Les moteurs actifs

1. Moteur systeme (APT natif)

- `apt-daily.timer` (systeme): telechargement/refresh APT.
- `apt-daily-upgrade.timer` (systeme): upgrades unattended-upgrades.

2. Moteur perso (systemd --user)

- `apt-daily.timer` (utilisateur): check quotidien perso + notification.
- `apt-auto.timer` (utilisateur): cycle hebdo perso avec snapshot + upgrade.
- `snapshot-weekly.timer`, `healthcheck-daily.timer`, `linux-maj-reminder.timer`.

## 2.2 Cadence reelle

Cadence issue des unites observees:

1. Quotidien perso

- `apt-daily.timer` user: tous les jours a `08:00`.
- Lance `apt_daily_check.sh`.

2. Hebdo perso

- `apt-auto.timer` user: dimanche `09:00`.
- Lance `apt_auto_update.sh`.

3. Quotidien systeme unattended

- `apt-daily.timer` systeme:
  - base `OnCalendar=*-*-* 6,18:00`
  - `RandomizedDelaySec=12h`
- `apt-daily-upgrade.timer` systeme:
  - base `OnCalendar=*-*-* 6:00`
  - `RandomizedDelaySec=60m`
  - depend de `apt-daily.timer`

Interpretation pratique:

- le systeme etale ses runs sur la journee (jitter volontaire),
- le check perso est fixe a 08:00,
- le passage hebdo perso est fixe dimanche 09:00.

## 2.3 Quand des MAJ sont pretes, que se passe-t-il

1. Detection

- Le check quotidien perso detecte les paquets upgradables.
- Il logue le nombre et peut notifier la presence de MAJ.

2. Traitement quotidien auto (unattended-upgrades)

- Si la MAJ vient des origines autorisees (Mint + Ubuntu security/updates), elle devient eligible au cycle auto systeme.
- Si la MAJ vient d'un depot hors scope, elle reste en attente (normal).

3. Traitement hebdo perso (dimanche)

- Snapshot Timeshift.
- `apt-get update`.
- `apt-get -y upgrade`.
- `apt-get -y autoremove --purge`.
- Journalisation avant/apres + delta.

4. Reste a traiter manuellement

- Paquets tiers hors policy (actuellement Brave, Claude).
- Eventuels paquets explicitement maintenus/pinnes.

## 3) Ce que TOI tu dois faire

## 3.1 Role operateur (minimal)

1. 2 fois/semaine (mardi/samedi), verifier la situation et traiter si besoin.
2. Apres un cycle manuel volontaire, acquitter le rappel:

```bash
~/.local/bin/linux_maj_reminder.sh --ack
```

3. Laisser le quotidien auto faire le travail de fond sur Mint + Ubuntu security/updates.

## 3.2 Controle de routine recommande

```bash
apt list --upgradable
journalctl -u apt-daily-upgrade.service --since '7 days ago' --no-pager
tail -n 120 /var/log/unattended-upgrades/unattended-upgrades.log
tail -n 120 /home/sebastien/01_Infra/04_Logs/02_System_Update_Logs/apt_auto_update.sh.log
tail -n 40 ~/.local/state/linux-maj-reminder/reminder.log
```

## 3.3 Lecture rapide des resultats

- Si `apt list --upgradable` montre surtout des tiers: normal avec policy actuelle.
- Si `unattended-upgrades.log` montre des installations Ubuntu/Mint: pile OK.
- Si `apt_auto_update.sh.log` montre `before/after/delta`: audit hebdo OK.

## 4) Ce qui a change pour toi, concretement

Avant:

- beaucoup de MAJ Ubuntu restaient en attente,
- peu de preuve synthese avant/apres sur le run hebdo,
- rappel GUI pas toujours visible.

Maintenant:

- la couche quotidienne absorbe aussi Ubuntu security/updates,
- le run hebdo produit un audit exploitable,
- le rappel est trace avec preuve de notification.

## 5) Risques et limites (volontaires)

1. Les depots tiers ne sont pas encore auto dans le quotidien.
2. `apt-get upgrade` reste conservateur (pas de sauts lourds type dist-upgrade).
3. Certains paquets peuvent rester maintenus selon policy/pinning.

## 6) Prochaines etapes possibles

1. Observer 1 a 2 semaines de stabilite.
2. Classer les tiers en `auto_ok` vs `manuel`.
3. Decider ensuite si certains tiers passent dans l'anneau hebdo.
