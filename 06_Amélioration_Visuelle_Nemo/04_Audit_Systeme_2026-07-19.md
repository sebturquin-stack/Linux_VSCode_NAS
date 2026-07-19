# 04 - Audit systeme 2026-07-19

## Verdict

Etat systeme: conforme.

1. `unattended-upgrades` installe et actif.
2. `/etc/apt/apt.conf.d/20auto-upgrades` present et coherent.
3. Timers `apt-daily` et `apt-daily-upgrade` actifs.
4. Timer user `linux-maj-reminder.timer` actif.
5. Rappel MAJ: pas en attente (dernier acquittement effectue).
6. Chaine visuelle Nemo OK: icones MIME resolues + custom icon sur tous les `.code-workspace` identifies.

## Preuve d'audit

Rapport brut:

- `reports/2026-07-19_audit_visuel_nemo.txt`

## Inventaire .code-workspace controles

- `01_Documentation_Peripheriques/Bibliothèque_Technique .code-workspace`
- `02_QG_-_RESEAUX_-_2026/Seb_Infra.code-workspace`
- `03_Apprentissage_Sur_VSCode/L'Apprentissage_VSCode.code-workspace`
- `04_Profil_Atelier II Documentation - SébDocs_VSCode/Profil_SébDoc_Atelier-II.code-workspace`
- `05_Linux_VSCode_NAS/Linux_VSCode.code-workspace`
- `06_KeePassXC_Conf_W10_&_Linux/06_KeePassXC_W10-Linux.code-workspace`

## Commandes de revalidation rapide

```bash
systemctl --user status linux-maj-reminder.timer --no-pager
~/.local/bin/linux_maj_reminder.sh --status
```

```bash
cd 06_Amélioration_Visuelle_Nemo
./scripts/02_audit_workspace_icons.sh
```
