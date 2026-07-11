# 04 - Stabiliser (RCA + Chronologie Complete)

## Objectif du document

Ce document sert de recap technique complet pour comprendre:

1. Comment l'incident graphique a pu se produire.
2. Ce qui a ete execute et analyse pas a pas.
3. Ce qui a effectivement stabilise la machine.
4. Les regles a appliquer pour ne plus revivre ce scenario.

---

## 1) Symptome constates

- Clignotement persistant des icones et du panel.
- Artefacts visuels et rendu instable sur 2 ecrans (portable + ASUS HDMI).
- Episodes de bureau inutilisable / retour TTY dans certaines phases.
- Perte temporaire des icones du bureau (Nemo desktop).
- Sensation de systeme "casse" alors que le noyau et la session restaient globalement vivants.

---

## 2) Cause probable (vision systeme)

Cause principale: empilement de tweaks graphiques sur plusieurs couches en peu de temps, sans validation intermediaire.

Couches impactees en meme temps:

- Variables globales `/etc/environment` (Clutter).
- Compositeur Muffin (`/etc/muffin/muffin.ini`).
- Theme/icones Cinnamon (variantes Sand + changements successifs).
- Relances repetees de `cinnamon --replace`.
- Double ecran actif pendant la phase d'instabilite.

Effet cumule:

- Synchronisation rendu/compositeur fragile.
- Rafraichissements parasites sur icones/panel.
- Etats graphiques incoherents entre bureau, panel et applets.

---

## 3) Chronologie des actions executees et analyses

## Phase A - Triage initial

- Lecture complete du dossier:
  - `05_Gros_Crash_Graphique/01_Le_Moteur_Graphique_Décroche.md`
  - `05_Gros_Crash_Graphique/02_Suite.md`
  - `05_Gros_Crash_Graphique/03_Suite_2.md`
- Creation d'une procedure de reprise safe:
  - `05_Gros_Crash_Graphique/00_Plan_Stabilisation_SAFE.md`
- Ajout d'un renvoi dans `03_Suite_2.md` vers le plan SAFE.

## Phase B - Diagnostic systeme reel

Commandes executees pour verifier l'etat reel:

- `journalctl -b -p err --no-pager`
- `systemctl status display-manager --no-pager`
- `journalctl -b -u display-manager --no-pager`
- `inxi -Gxx`
- `grep -n "CLUTTER\|MUTTER\|MUFFIN\|VBLANK\|FPS" /etc/environment`
- `journalctl -b | grep -Ei "cinnamon|muffin|xorg|i915|drm|modesetting|lightdm"`
- `xrandr --verbose`
- `gsettings list-schemas`, `gsettings list-keys`, `gsettings list-recursively`

Constats techniques importants:

- `lightdm.service` actif et stable.
- GPU Intel i915 actif, rendu Mesa materiel OK.
- X11/modesetting actifs, pas de crash driver bloquant dans les erreurs critiques.
- Les 2 ecrans etaient bien en mode natif.
- Des commandes historiques utilisaient des cles gsettings inexistantes pour cette version Cinnamon.

## Phase C - Stabilisation progressive appliquee

### C1) Stabilisation Cinnamon compatible (cles valides)

- `gsettings set org.cinnamon.desktop.interface enable-animations false`
- `gsettings set org.cinnamon.muffin unredirect-fullscreen-windows false`
- `gsettings set org.cinnamon.muffin experimental-features "[]"`
- Relance session visuelle:
  - `cinnamon --replace`

### C2) Hygiene de session (processus + autostart)

- Verification processus Cinnamon actifs.
- Detection et correction d'instances multiples de `cinnamon --replace`.
- Desactivation propre de l'autostart invalide:
  - `~/.config/autostart/blueman.desktop` -> renomme en backup `.disabled.<timestamp>`

### C3) Profil visuel plus stable

- Bascule sur theme/icones stock:
  - GTK theme: `Mint-Y-Dark`
  - Icon theme: `Mint-Y`
  - Cinnamon theme: `Mint-Y-Dark`
- Sauvegarde des anciennes valeurs dans:
  - `05_Gros_Crash_Graphique/07_backup_themes_before_stable_icons.txt`

### C4) Test ciblant Nemo desktop (diagnostic du clignotement icones)

- Test temporaire (reversible) avec icones Nemo desactivees:
  - `org.nemo.desktop show-desktop-icons=false`
  - `org.nemo.desktop background-fade=false`
- Observation: clignotement toujours present (mais reduit) -> cause non unique.

### C5) Recuperation icones + reset profil utilisateur Cinnamon

Actions executees:

- Restauration icones bureau:
  - `org.nemo.desktop show-desktop-icons=true`
- Relance `nemo-desktop`.
- Backup + reset profil Cinnamon utilisateur:
  - `~/.config/cinnamon` -> `.bak-<timestamp>`
  - `~/.local/share/cinnamon` -> `.bak-<timestamp>`
- Nettoyage caches:
  - `~/.cache/cinnamon/*`
  - `~/.cache/thumbnails/*`
  - `~/.cache/icons/*`
- Relance `cinnamon --replace`.

Effet observe:

- Recuperation du bureau et retour des icones.
- Clignotements fortement diminues puis stabilisation fonctionnelle.

## Phase D - Mesure post-stabilisation

Commandes executees:

- `systemd-analyze`
- `systemd-analyze blame | head -n 30`
- `systemd-analyze critical-chain`

Constat:

- Systeme stable, boot correct (~1min03 au total dans la mesure relevee).
- Le ressenti de "reboot long" vient surtout de firmware + loader, puis de Docker/UFW dans la chaine userspace.
- La crise graphique et la lenteur du boot sont deux sujets differents.

---

## 4) Ce qui etait trompeur / dangereux dans les essais precedents

1. Appliquer plusieurs optimisations graphiques d'un coup (theme + compositeur + variables systeme + animations).
2. Utiliser des cles gsettings non disponibles sur la version installee.
3. Relancer `cinnamon --replace` de facon repetee sans verifier les processus restants.
4. Modifier des fichiers systeme non standards sans validation intermediaire.

---

## 5) Ce qui a vraiment aide

1. Revenir a une methode "safe": une action, une validation.
2. Verifier d'abord l'etat reel (LightDM, i915, X11, logs) avant de reinstaller.
3. Revenir sur theme/icones stock pour reduire les variables.
4. Nettoyer les processus Cinnamon parasites.
5. Reset du profil Cinnamon utilisateur avec backup (approche reversible).

---

## 6) Regles anti-recidive (obligatoires)

1. Toujours snapshot/backup avant lot de tweaks graphiques.
2. Jamais plus d'un changement graphique par cycle de test.
3. Tester d'abord sur ecran interne seul en cas d'instabilite.
4. Ne pas creer de nouveaux fichiers de config systeme sans verifier qu'ils sont supportes.
5. Conserver un journal de changements: "changement -> resultat -> rollback".

---

## 7) Checklist de securite avant toute nouvelle optimisation graphique

- [ ] Backup effectue (dconf + fichiers utilisateur importants).
- [ ] Etat initial capture (`systemd-analyze`, `inxi -Gxx`, `xrandr`).
- [ ] Un seul changement prevu.
- [ ] Procedure de retour arriere prete.
- [ ] Validation visuelle 10-15 min avant changement suivant.

---

## 8) Etat courant (fin de cette sequence)

- Session graphique revenue et utilisable.
- Icones du bureau restaurees.
- Clignotements nettement reduits puis stabilisation constatee.
- Documentation de crise structuree dans:
  - `05_Gros_Crash_Graphique/00_Plan_Stabilisation_SAFE.md`
  - `05_Gros_Crash_Graphique/03_Suite_2.md`
  - `05_Gros_Crash_Graphique/04_Stabiliser.md`

---

## 9) Point de vigilance pour la suite

Si un clignotement reapparait:

1. Stopper toute nouvelle optimisation.
2. Revenir a la checklist SAFE.
3. Diagnostiquer avant toute action corrective lourde.

Ce document est la reference pour eviter de reproduire la meme chaine d'incident.

---

## 10) Analyse des captures (etat visuel apres recuperation)

Lecture des captures fournies:

1. Le bureau est revenu (panel visible, zone systeme presente, icones visibles).
2. VS Code et la structure workspace sont accessibles normalement.
3. Le systeme est dans un etat "degrade leger" possible, mais plus dans un etat de crash dur.

Verification dconf effectuee:

- Les cles coeur panels/applets (`panels-enabled`, `enabled-applets`, `next-applet-id`) correspondent au backup final.

Conclusion:

- Les backups ont deja rempli leur role sur la partie applets/panels.
- Un restore complet immediate n'est pas obligatoire tant que l'etat est stable.

---

## 11) Mecanisme de restauration backup (script)

Script ajoute:

- `05_Gros_Crash_Graphique/08_restore_cinnamon_depuis_backup.sh`

Modes disponibles:

1. `--panel-only` (recommande)
  - Restaure uniquement panels/applets/tailles/ids.
2. `--full`
  - Restaure tout `/org/cinnamon/` depuis le backup INI.

Securite integree:

- Sauvegarde automatique de l'etat courant avant restauration.
- Relance Cinnamon en fin de procedure.
- Re-force `show-desktop-icons=true` cote Nemo.

Exemples:

- `bash 05_Gros_Crash_Graphique/08_restore_cinnamon_depuis_backup.sh --panel-only`
- `bash 05_Gros_Crash_Graphique/08_restore_cinnamon_depuis_backup.sh --full`

Backup post-recuperation cree pour reference:

- `00_Cinnamon_Backup_DCONF/dconf_cinnamon_post_recovery_2026-07-06-202846.ini`
