# 06 - Plan Elargissement Perimetre Auto

## Constat du 2026-07-22

La pile MAJ tourne encore, mais la couverture automatique est trop etroite.

Ce qui fonctionne:

1. `apt-daily-upgrade.service` tourne.
2. Le timer perso `apt-auto.timer` tourne.
3. Le check quotidien detecte bien les MAJ.
4. Les snapshots Timeshift et healthchecks tournent.
5. Le rappel mardi/samedi tourne encore, mais il faut fiabiliser son affichage visuel.

Ce qui limite la valeur de la pile:

1. `unattended-upgrades` n'autorise actuellement que les origines Linux Mint.
2. Beaucoup de paquets utiles du stock courant viennent de `noble-updates` et `noble-security` cote Ubuntu.
3. Les depots tiers restent hors du perimetre de securite quotidienne.
4. Le rappel persistant logue bien son passage, mais l'alerte GUI doit etre rendue plus robuste.

Conclusion:

- La pile n'est pas casse.
- Le probleme est un probleme de perimetre automatique, pas de moteur.

## Objectif

Augmenter le volume de MAJ traitees automatiquement sans perdre la stabilite de la machine.

## Strategie retenue

Elargir en 3 anneaux, du plus sur au plus surveille.

### Anneau 1 - Quotidien securite + updates Ubuntu/Mint

But:

- Faire absorber automatiquement la majorite des MAJ APT classiques.

Actions cible:

1. Ouvrir `unattended-upgrades` aux origines Ubuntu utiles en plus de Mint.
2. Garder exclus par defaut les paquets a fort risque si necessaire.
3. Continuer les logs et la verification via `journalctl` et `history.log`.

Configuration visee:

```conf
Unattended-Upgrade::Allowed-Origins {
        "${distro_id}:${distro_codename}";
        "${distro_id}:${distro_codename}-security";
        "Ubuntu:noble-security";
        "Ubuntu:noble-updates";
        // Option prudente a tester plus tard si le cycle reste stable:
        // "Ubuntu:noble-backports";
};
```

Note:

- Sous Mint, `${distro_id}` peut pointer vers `Linuxmint` et ne pas couvrir automatiquement les origines Ubuntu attendues.
- C'est le point principal a corriger.

### Anneau 2 - Hebdomadaire auto personnalise

But:

- Laisser le script perso `apt_auto_update.sh` absorber le reste du lot APT standard chaque dimanche, avec snapshot avant passage.

Actions cible:

1. Conserver `timeshift --create` avant MAJ.
2. Preferer `apt-get` a `apt` dans les scripts pour une CLI stable.
3. Ajouter un resume explicite du nombre de paquets traites dans le log.
4. Journaliser aussi la liste des paquets mis a jour.

Pourquoi:

- Aujourd'hui le script marche, mais son resume n'est pas assez orientee audit.

### Anneau 3 - Depots tiers sous controle

But:

- Automatiser plus sans lancer aveuglement tous les depots tiers.

Depots a classer:

1. Auto hebdo possible apres validation: `code`, `edge`, `docker`, `powershell`.
2. Auto prudente ou manuelle surveillee: `claude-desktop-unofficial`, `brave-browser`.
3. Toujours hors scope APT: Flatpak, Snap, AppImage.

Principe:

- On n'ajoute pas les tiers dans le quotidien avant d'avoir 1 a 2 cycles stables sur l'anneau 1.

## Plan d'execution

### Phase A - Corriger la couche quotidienne

Objectif:

- Faire en sorte que les MAJ Ubuntu de securite et de maintenance courante ne restent plus en attente inutilement.

Actions:

1. Sauvegarder `/etc/apt/apt.conf.d/50unattended-upgrades`.
2. Ajouter explicitement `Ubuntu:noble-security`.
3. Ajouter explicitement `Ubuntu:noble-updates`.
4. Relancer `apt-daily-upgrade.service`.
5. Lire le log `unattended-upgrades.log`.

Besoin de toi:

- Cette phase demande `sudo` pour modifier `/etc/apt/apt.conf.d/50unattended-upgrades` et relancer le service systeme.
- Je peux te donner la commande exacte ou te preparer le patch si tu veux l'appliquer toi-meme.

Validation attendue:

1. Le journal ne doit plus dire `Aucun paquet a mettre a niveau automatiquement` si des paquets Ubuntu compatibles sont en attente.
2. `history.log` doit montrer des installations automatiques reelles.
3. Le nombre de MAJ restantes doit baisser apres un cycle.

### Phase A bis - Fiabiliser la notification de rappel

Objectif:

- Faire en sorte que le rappel mardi/samedi soit visible au lieu de seulement etre logue.

Actions:

1. Ajouter un traceur `notified=OUI/NON` dans le log du rappel.
2. Garder `notify-send` comme premiere voie.
3. Ajouter un fallback D-Bus `gdbus` si la notification standard ne sort pas.
4. Tester le rappel avec `--check` pendant une session graphique active.

Validation attendue:

1. Le log `~/.local/state/linux-maj-reminder/reminder.log` doit montrer `notified=OUI`.
2. Une notification visible doit apparaître au moins au premier passage.
3. Si le GUI bloque, le fallback doit encore produire un signal exploitable.

### Phase B - Durcir le script hebdo perso

Objectif:

- Mieux tracer et mieux auditer le passage du dimanche.

Actions:

1. Remplacer `apt upgrade` par `apt-get -y dist-upgrade` ou `apt-get -y upgrade` selon le niveau retenu.
2. Ajouter un comptage avant/apres.
3. Ajouter un bloc `apt list --upgradable` avant et apres passage.
4. Conserver le snapshot avant toute MAJ.

Validation attendue:

1. Le log du dimanche doit dire combien de paquets etaient en attente.
2. Le log doit dire combien restent apres execution.
3. Le healthcheck critique doit rester vert.

### Phase C - Etendre aux tiers utiles

Objectif:

- Reduire encore le rituel manuel sans introduire de regressions applicatives.

Actions:

1. Observer pendant 2 semaines quels depots tiers reviennent le plus.
2. Faire une liste `tiers_auto_ok` et `tiers_manuels`.
3. Si besoin, creer une doc dediee de politique par depot.

Validation attendue:

1. Plus de 70% du lot moyen hebdo doit etre absorbe automatiquement.
2. Le rituel manuel doit devenir un filet de securite, pas le moteur principal.

### Phase D - Elargissement prudent optionnel

Objectif:

- Ouvrir ensuite un peu plus le perimetre si les cycles restent stables.

Candidats possibles:

1. `Ubuntu:noble-backports` si un besoin concret justifie le risque.
2. Certains depots tiers frequents si 2 cycles consecutifs sont propres.

Règle:

- On ne passe pas cet anneau sans validation manuelle avant et apres.

## Garde-fous

Ne pas mettre dans le quotidien sans validation explicite:

1. Noyau si tu veux garder une intervention humaine avant reboot.
2. Drivers graphiques sensibles.
3. Gros paquets desktop si tu observes une regression Cinnamon.
4. Tiers peu previsibles.

## Commandes de verification

```bash
systemctl list-timers --all | grep -E 'apt-daily|apt-daily-upgrade'
systemctl --user list-timers --all | grep -E 'apt-auto|apt-daily|snapshot-weekly|healthcheck-daily|linux-maj-reminder'
journalctl -u apt-daily-upgrade.service --since '7 days ago' --no-pager
tail -n 120 /var/log/unattended-upgrades/unattended-upgrades.log
tail -n 120 /var/log/apt/history.log
apt list --upgradable
```

## Decision pratique pour la prochaine seance

Ordre recommande:

1. Corriger d'abord `50unattended-upgrades`.
2. Valider sur 1 cycle.
3. Ensuite seulement durcir `apt_auto_update.sh`.
4. Enfin decider depot tiers par depot tiers.
5. Si besoin, ouvrir le perimetre prudent optionnel sur `noble-backports` ou certains tiers stables.

## Verdict

La pile actuelle est utile, mais elle est sous-exploitee.

La bonne direction n'est pas de tout automatiser d'un coup.
La bonne direction est d'elargir proprement le perimetre quotidien Ubuntu/Mint, puis de renforcer le passage hebdo, puis de trier les depots tiers.
Le rappel mardi/samedi doit rester visible pour servir de filet humain, pas seulement de log technique.
