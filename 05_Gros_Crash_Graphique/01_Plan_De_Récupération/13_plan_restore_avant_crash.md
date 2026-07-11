# Plan de restauration avant crash

## Conclusion sur .config/cinnamon

- Restauration raisonnablement safe: oui, avec garde-fous.
- Cette arborescence contient ici surtout les JSON de reglages spices et un fichier de fonds d'ecran.
- Elle ne contient pas de binaire, pas de service, pas de module noyau, pas de configuration systeme sensible.
- Risque principal: remettre des reglages d'applets plus anciens que le code actuellement charge.
- Dans ce cas precis, le backup semble plus coherent que l'etat actuel: le dconf courant reference encore `Cinnamenu@json:93`, alors que son JSON manque actuellement dans `.config/cinnamon/spices`.

## Ce qui rend la restauration plus sure

- Restaurer ensemble:
  - le dconf Cinnamon
  - `.config/cinnamon` issu du backup historique
  - `.local/share/cinnamon` issu du backup historique
  - `.themes` et `.icons`
- Garder un dry-run rsync avant toute application.
- Garder une sauvegarde dconf courante avant toute charge.

## Ce qui est objectivement risque faible

- `backgrounds/user-folders.lst`
  - contenu observe: `/home/sebastien/Images`
  - risque faible, simple pointeur de dossier
- `spices/*.json`
  - risque faible a modere
  - ce sont des reglages utilisateurs et identifiants d'instances

## Ce qui peut casser si on force trop vite

- Un applet tiers incompatible avec la version actuelle de Cinnamon.
- Un jeu de reglages reference par dconf sans code d'applet correspondant.
- Un second panel remis par dconf si tu ne veux finalement restaurer que le panel principal.

## Etat constate pendant l'analyse

- `.config/cinnamon` actuel: seulement `spices/`
- `.config/cinnamon` backup: `spices/` + `backgrounds/user-folders.lst`
- `.local/share/cinnamon` backup contient un applet absent de l'actuel: `Cinnamenu@json`
- Le dconf courant reference deja `Cinnamenu@json:93`

## Strategie recommandee

1. Construire un stage historique avec le script `12_prepare_restore_before_crash_stage.sh`.
2. Lancer un dry-run rsync du stage vers `/home/sebastien` avec le filtre agressif.
3. Si le dry-run est propre, appliquer le rsync reel.
4. Restaurer le dconf Cinnamon:
   - mode panel-only si tu veux d'abord remettre la structure visuelle sans tout forcer
   - mode full si tu veux revenir au plus proche de l'avant crash
5. Relancer Cinnamon et verifier les panels, applets, menus, icones et theme.

## Commandes de reference

### Construire le stage

```bash
bash /run/user/1000/gvfs/smb-share:server=sebinfranas.local,share=infradata/07_VSCode_Workspaces/05_Linux_VSCode_NAS/05_Gros_Crash_Graphique/01_Plan_De_Récupération/12_prepare_restore_before_crash_stage.sh
```

### Dry-run de restauration avant crash

```bash
rsync -aAXHvin --delete \
  --filter="merge /run/user/1000/gvfs/smb-share:server=sebinfranas.local,share=infradata/07_VSCode_Workspaces/05_Linux_VSCode_NAS/05_Gros_Crash_Graphique/01_Plan_De_Récupération/11_filtre_cinnamon_avant_crash_agressif.rsync-filter" \
  /home/sebastien/07_restore_before_crash_stage/ \
  /home/sebastien/
```

### Application reelle

```bash
rsync -aAXHiv --delete \
  --filter="merge /run/user/1000/gvfs/smb-share:server=sebinfranas.local,share=infradata/07_VSCode_Workspaces/05_Linux_VSCode_NAS/05_Gros_Crash_Graphique/01_Plan_De_Récupération/11_filtre_cinnamon_avant_crash_agressif.rsync-filter" \
  /home/sebastien/07_restore_before_crash_stage/ \
  /home/sebastien/
```

### Restauration dconf

```bash
bash /run/user/1000/gvfs/smb-share:server=sebinfranas.local,share=infradata/07_VSCode_Workspaces/05_Linux_VSCode_NAS/05_Gros_Crash_Graphique/08_restore_cinnamon_depuis_backup.sh --panel-only
```

Puis, si besoin de retour plus complet:

```bash
bash /run/user/1000/gvfs/smb-share:server=sebinfranas.local,share=infradata/07_VSCode_Workspaces/05_Linux_VSCode_NAS/05_Gros_Crash_Graphique/08_restore_cinnamon_depuis_backup.sh --full
```
