# Audit Cinnamon - 2026-09-12

## Perimetre

Audit non destructif de la session Cinnamon apres la stabilisation graphique documentee dans `04_Stabiliser.md`.
Aucune modification systeme ou utilisateur n'a ete appliquee pendant cet audit.

## Etat observe

- Session: Cinnamon 6.6.9, Muffin 6.6.3, Nemo 6.6.3.
- Session graphique: X11, rendu direct Mesa/Intel actif.
- GPU: Intel HD Graphics Broadwell, pilote kernel `i915`.
- Ecrans: portable 1600x900 + ASUS HDMI 1920x1080, tous deux a 60 Hz, sans scaling fractionnaire.
- Processus: une session Cinnamon, un `cinnamon --replace`, un `cinnamon-killer-daemon`, un `nemo-desktop`.
- Extensions Cinnamon: aucune.
- Desklets: aucun.
- Deux panneaux actifs, coherents avec le projet Cinnamon 2 Panels.
- Animations desactivees.
- Fonctionnalites experimentales Muffin vides.
- `unredirect-fullscreen-windows=false`, coherent avec la stabilisation precedente.
- Icones Nemo du bureau actives et fondu du fond desactive.
- Aucun crash Cinnamon/Muffin/Nemo present dans les crash dumps de la session.

## Ecarts et points de vigilance

### 1. Profil visuel Sand actif

Les valeurs courantes sont:

- GTK: `Mint-L-Darker-Sand`
- Icones: `Mint-Y-Sand`
- Theme Cinnamon: `Mint-Y-Dark-Sand`

Ces valeurs correspondent au backup du 2026-07-06, mais pas au profil stock retenu dans la phase de stabilisation (`Mint-Y` et `Mint-Y-Dark`). Ce n'est pas une preuve de panne, mais c'est la premiere variable a isoler si le comportement bizarre concerne des clignotements, des rafraichissements ou le panel.

### 2. Double ecran

Le double ecran est stable techniquement: resolutions natives, 60 Hz et absence de scaling fractionnaire. Il reste toutefois une variable de complexite importante pour Cinnamon/Muffin. En cas de retour des artefacts, le test ecran interne seul reste le test discriminant prevu par la procedure SAFE.

### 3. Warning screensaver au demarrage

Le journal contient un timeout initial de Cinnamon lors de la lecture de l'etat du screensaver. Le service finit ensuite son initialisation correctement. A surveiller, mais pas de symptome suffisant pour justifier une reinstallation ou un reset de profil.

### 4. Erreurs hors Cinnamon a ne pas confondre

Le journal signale aussi des erreurs BIOS/ACPI, TPM/DMAR et surtout 88 secteurs actuellement illisibles et offline uncorrectable sur `/dev/sdb`. Ces erreurs ne prouvent pas une cause Cinnamon, mais elles constituent un risque systeme reel et peuvent produire des lenteurs ou blocages applicatifs. Elles doivent etre traitees dans un audit stockage separe.

## Conclusion

Cinnamon est actuellement fonctionnel et globalement protege par les reglages de stabilisation. Je ne constate pas de crash actif, d'extension tierce, de scaling fractionnaire ou de variable Clutter/Muffin active dans `/etc/environment`.

Le profil n'est toutefois pas strictement revenu a l'etat de reference: le theme Sand et le double ecran restent les deux variables visuelles principales. Le comportement "bizarre" ne peut donc pas encore etre attribue a une panne du moteur Cinnamon.

## Suite recommandee, dans cet ordre

1. Ne rien reinstaller et ne pas ajouter de tweak graphique.
2. Si le probleme est visuel, tester temporairement le profil stock `Mint-Y` / `Mint-Y-Dark`, avec backup dconf avant le changement.
3. Valider 10 a 15 minutes sur les deux ecrans.
4. Si le probleme revient, refaire le meme test sur ecran interne seul.
5. Traiter separement le disque `/dev/sdb` avant toute conclusion sur la stabilite generale.

## Resultat

Audit: **fonctionnel avec points de vigilance**, pas de correction automatique appliquee.
