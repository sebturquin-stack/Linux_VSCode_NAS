# 03 - Procedure Stabilisation Pas A Pas

## Principe

Procedure ciblee, reproductible, avec checkpoints. Eviter les resets massifs repetes sans mesure.

## Etape 0 - Pre-check

```bash
~/01_Infra/02_Scripts/01_Cinnamon/cinnamon_panels_doctor.sh check
```

Critere: verdict `OK`.

## Etape 1 - Sauvegarde avant action

```bash
~/01_Infra/02_Scripts/01_Cinnamon/save_dconf_cinnamon.sh
```

Critere: creation d'un fichier `dconf_cinnamon_backup_YYYY-MM-DD_HHMMSS.ini`.

## Etape 2 - Controle topologie panels

```bash
gsettings get org.cinnamon panels-enabled
gsettings get org.cinnamon enabled-applets
```

Critere:

- 2 panels definis
- applets panel1/panel2 presentes

## Etape 3 - Relance securisee de Cinnamon (si necessaire)

```bash
~/01_Infra/02_Scripts/01_Cinnamon/reset_cinnamon_safe.sh check
~/01_Infra/02_Scripts/01_Cinnamon/reset_cinnamon_safe.sh restart
```

Critere:

- pas d'erreur de contexte
- relance en arriere-plan
- log disponible: `/tmp/reset_cinnamon_safe.log`

## Etape 4 - Validation post-action

```bash
~/01_Infra/02_Scripts/01_Cinnamon/cinnamon_panels_doctor.sh check
dconf dump /org/cinnamon/ | grep -E 'panels-enabled|enabled-applets'
```

Critere: coherence entre visuel desktop et cles DCONF.

## Etape 5 - Validation post-reboot

- Rebooter systeme.
- Verifier visuellement les 2 panels.
- Rejouer la commande doctor en session ouverte.

## Anti-patterns a eviter

- Lancer des commandes DCONF en dehors d'une session Cinnamon active.
- Chainer des `cinnamon --replace` depuis des contextes non stables.
- Diagnostiquer uniquement avec un seul chemin DCONF.

## Definition of Done

- 2 panels visibles apres reboot.
- `cinnamon_panels_doctor.sh check` -> OK.
- Backup recent present dans le dossier principal.
