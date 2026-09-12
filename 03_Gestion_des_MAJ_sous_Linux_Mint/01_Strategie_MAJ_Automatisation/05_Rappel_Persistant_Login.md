# 05 - Rappel persistant MAJ au login

## Ce que fait le systeme

- Au login Linux, un timer utilisateur verifie l'echeance MAJ.
- Ensuite, il re-verifie toutes les 30 minutes.
- Tant que le cycle n'est pas acquitte, une notification revient.
- Si un mardi est rate, le rappel continue les jours suivants jusqu'a execution + acquittement.

## Fichiers utilises

- Script: `~/.local/bin/linux_maj_reminder.sh`
- Service user: `~/.config/systemd/user/linux-maj-reminder.service`
- Timer user: `~/.config/systemd/user/linux-maj-reminder.timer`
- Etat: `~/.local/state/linux-maj-reminder/state.env`
- Logs rappel: `~/.local/state/linux-maj-reminder/reminder.log`

## Commandes utiles et routine simple

### Routine simple (copier-coller)

Objectif: faire la MAJ complete, verifier, puis acquitter le rappel.

```bash
sudo apt update && sudo apt -y full-upgrade && sudo apt -y autoremove --purge
apt list --upgradable
~/.local/bin/linux_maj_reminder.sh --ack
~/.local/bin/linux_maj_reminder.sh --status
```

Repere rapide:

- Si la sortie de `apt list --upgradable` ne contient plus de paquets, le cycle est termine.
- En cas de demande de redemarrage, redemarrer puis relancer seulement:

```bash
apt list --upgradable
~/.local/bin/linux_maj_reminder.sh --status
```

Voir l'etat:

```bash
~/.local/bin/linux_maj_reminder.sh --status
```

Acquitter le cycle apres routine MAJ:

```bash
~/.local/bin/linux_maj_reminder.sh --ack
```

Verifier timer/service:

```bash
systemctl --user status linux-maj-reminder.timer --no-pager
systemctl --user status linux-maj-reminder.service --no-pager
systemctl --user list-timers --all | grep linux-maj-reminder
```
