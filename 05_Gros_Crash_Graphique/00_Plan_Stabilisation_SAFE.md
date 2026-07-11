# 00 - Plan Stabilisation SAFE (Crash Graphique)

Objectif: retrouver un affichage stable sans casser davantage le systeme.

Reference recap complet (RCA + chronologie): `04_Stabiliser.md`

Principe: 1 seule modification a la fois, validation, puis etape suivante.

## Ce qu on ne fait pas pour le moment

- Pas de cascade de tweaks GPU/Clutter/Muffin.
- Pas de reinstallation massive tant que le diagnostic n est pas collecte.
- Pas de modifications simultanees du theme, du compositeur et des ecrans.

## Etape 1 - Demarrage minimal stable

1. Eteindre completement le PC.
2. Deconnecter l ecran externe ASUS.
3. Demarrer uniquement sur l ecran du portable.
4. Se connecter en session normale si possible.

Si la session graphique ne monte pas:

- Basculer en TTY (Ctrl+Alt+F2), se connecter, puis passer a l etape 2.

## Etape 2 - Collecte diagnostic (obligatoire)

Executer ces commandes et sauvegarder les sorties dans un fichier texte:

- journalctl -b -p err --no-pager
- systemctl status display-manager --no-pager
- journalctl -b -u display-manager --no-pager
- inxi -Gxx
- grep -n "CLUTTER\|MUTTER\|MUFFIN\|VBLANK\|FPS" /etc/environment

## Etape 3 - Nettoyage prudent cote utilisateur

Depuis TTY (ou terminal si session dispo):

- mv ~/.config/cinnamon ~/.config/cinnamon.bak.$(date +%F-%H%M%S)
- mv ~/.local/share/cinnamon ~/.local/share/cinnamon.bak.$(date +%F-%H%M%S)
- rm -rf ~/.cache/cinnamon/* ~/.cache/thumbnails/* ~/.cache/icons/*

Puis redemarrer:

- sudo systemctl restart display-manager

## Etape 4 - Verrouillage mode stable Cinnamon

Une fois revenu sur le bureau:

- gsettings set org.cinnamon enable-animations false
- gsettings set org.cinnamon.muffin use-vsync false
- gsettings set org.cinnamon.muffin reduced-resources true

Ne rien changer d autre avant validation.

## Etape 5 - Validation stable (15 minutes)

Critere OK:

- Plus de clignotement icones/panel.
- Plus d artefacts sur deplacement de fenetres.
- Pas de retour TTY.

Si OK:

- Rebrancher l ecran ASUS.
- Configurer un seul mode natif, sans scaling exotique.

## Etape 6 - Si encore instable

Faire le test de profil propre:

- sudo adduser testgfx
- se connecter sur testgfx

Si testgfx est stable:

- Le probleme est dans le profil utilisateur actuel (config Cinnamon/theme).

Si testgfx est instable:

- Le probleme est systeme/driver/stack graphique, on passe alors a une reparation ciblee.

## Reparation ciblee (seulement si necessaire)

1.Reinstaller uniquement le minimum:

- sudo apt update
- sudo apt install --reinstall cinnamon muffin lightdm xserver-xorg-core

2.Verifier le gestionnaire d affichage:

- sudo dpkg-reconfigure lightdm

3.Redemarrer:

- sudo reboot

## Regle d or pour la suite

- Ne jamais appliquer plusieurs optimisations graphiques dans la meme session.
- Faire un snapshot/backup avant chaque lot de changement.
- Documenter: changement -> resultat -> rollback.
