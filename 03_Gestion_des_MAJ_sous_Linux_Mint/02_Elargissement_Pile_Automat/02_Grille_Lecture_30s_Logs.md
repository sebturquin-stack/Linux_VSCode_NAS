# 02 - Grille Lecture 30s Logs

Date: 2026-07-22

## But

Avoir une lecture ultra rapide de l'etat de la pile MAJ, en 30 secondes, avec action immediate.

## Commandes 30 secondes

```bash
apt list --upgradable
tail -n 40 /var/log/unattended-upgrades/unattended-upgrades.log
tail -n 40 /home/sebastien/01_Infra/04_Logs/02_System_Update_Logs/apt_auto_update.sh.log
tail -n 20 ~/.local/state/linux-maj-reminder/reminder.log
```

## Tableau de lecture rapide

| Signal                 | Ou regarder                                            | OK                                                                              | WARN                                                          | ACTION                                                 |
|------------------------|--------------------------------------------------------|---------------------------------------------------------------------------------|---------------------------------------------------------------|--------------------------------------------------------|
| Stock MAJ restant      | `apt list --upgradable`                                | 0 a 5 paquets, surtout tiers                                                    | >5 paquets Ubuntu/Mint qui persistent                         | lancer verification unattended-upgrades + check policy |
| Auto quotidien systeme | `/var/log/unattended-upgrades/unattended-upgrades.log` | lignes d'installation + fin propre                                              | beaucoup de "not allowed" sur des paquets que tu voulais auto | verifier `Allowed-Origins` et pinning                  |
| Auto hebdo perso       | `apt_auto_update.sh.log`                               | `before_upgradable_count`, `after_upgradable_count`, `upgraded_delta` coherents | metriques absentes ou delta nul plusieurs semaines            | rejouer dimanche suivant + verifier timer/service      |
| Snapshot avant MAJ     | `apt_auto_update.sh.log`                               | `snapshot_before_upgrade_ok`                                                    | `snapshot_before_upgrade_error`                               | corriger Timeshift avant prochain run                  |
| Sante post-MAJ         | `apt_auto_update.sh.log`                               | `Service OK` pour NetworkManager/display-manager/cron                           | `Service WARN/KO`                                             | corriger service concerne                              |
| Rappel operateur       | `~/.local/state/linux-maj-reminder/reminder.log`       | `ACK` present, `notified=OUI` quand cycle du                                    | `notified=NON` repete                                         | verifier session GUI / notify-send / gdbus             |

## Interprétation simple

1. Si il reste seulement Brave/Claude: pile normale, rien de casse.
2. Si des paquets Ubuntu security s'accumulent: verifier tout de suite unattended-upgrades.
3. Si le dimanche ne fait pas baisser le stock: regarder `before/after/delta` dans le log hebdo.

## Routine operateur minimale

1. Mardi et samedi: check rapide 30 secondes.
2. Apres un cycle manuel: `~/.local/bin/linux_maj_reminder.sh --ack`.
3. Si notif visuelle gene: `~/.local/bin/linux_maj_reminder.sh --clear`.

## Commandes de diagnostic si WARN

```bash
journalctl -u apt-daily-upgrade.service --since '7 days ago' --no-pager
systemctl list-timers --all | grep -E 'apt-daily|apt-daily-upgrade'
systemctl --user list-timers --all | grep -E 'apt-auto|apt-daily|linux-maj-reminder'
```
