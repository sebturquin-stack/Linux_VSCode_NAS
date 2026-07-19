# 04 - Check 30s Mardi Samedi

## Objectif

Eviter toute accumulation de MAJ avec un rituel ultra court.

## Routine standard

```bash
sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove --purge
apt list --upgradable
```

## Check rapide (30 secondes)

1. Verifier le nombre de paquets restants:
   - `apt list --upgradable 2>/dev/null | tail -n +2 | wc -l`
2. Si resultat `0`: cycle valide.
3. Si resultat `>0`: laisser la prochaine fenetre auto ou refaire un passage manuel court.

## Acquitter le rappel persistant

Quand la routine est faite:

```bash
~/.local/bin/linux_maj_reminder.sh --ack
```

## Diagnostic express du rappel

```bash
~/.local/bin/linux_maj_reminder.sh --status
systemctl --user status linux-maj-reminder.timer --no-pager
```
