# 05 - Suivi MAJ Chemins

Ce fichier sert de pense-bete pour maintenir des chemins propres quand tu deplaces un dossier, un backup ou un script.

## Mode d'emploi

1. Ajouter ici le chemin source.
2. Noter le chemin cible.
3. Verifier si un script, un lien symbolique ou une variable d'environnement doit etre ajuste.
4. Tester apres changement.

## Tableau de MAJ

| Date       | Element          | Ancien chemin                                                                                                      | Nouveau chemin                                | Fait | Teste |
|------------|------------------|--------------------------------------------------------------------------------------------------------------------|-----------------------------------------------|------|-------|
| 2026-06-30 | Workspace VSCode | `/run/user/1000/gvfs/smb-share:server=sebinfranas.local,share=infradata/07_VSCode_Workspaces/05_Linux_VSCode_NAS/` | `~/03_VSCode_Workspaces/05_Linux_VSCode_NAS/` | Non  | Non   |

## Checklist rapide

- Mise a jour du chemin canonique.
- Verification des scripts qui utilisent ce chemin.
- Verification du symlink si present.
- Test de lecture ou de sauvegarde.
- Note de retour en cas d'echec.
- Reference decision systeme: `../03_Gestion_des_MAJ_sous_Linux_Mint/08_Mini_Grille_de_Decision.md`
- Reference index global MAJ: `../03_Gestion_des_MAJ_sous_Linux_Mint/00_Index.md`

## Zones a surveiller

- `save_dconf_cinnamon.sh`
- `cinnamon_panels_doctor.sh`
- `reset_cinnamon_safe.sh`
- `00_Cinnamon_Backup_DCONF/`
- `~/03_VSCode_Workspaces/`
