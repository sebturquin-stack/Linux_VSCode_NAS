# 08 - Mini Grille de Decision

Mini grille rapide pour trancher une action systeme sans casser la stabilite de la pile MAJ DevOps++.

## Mode d'utilisation rapide

1. Identifier si le service en echec est critique ou non critique.
2. Evaluer l'impact reel sur la machine installee (pas theorique).
3. Choisir l'action la moins intrusive possible.
4. Reevaluer apres 1 a 2 cycles de MAJ.

## Grille de decision

| Option                     | Quand l'utiliser                                                               | Avantages                                                                | Risques / limites                                                  | Niveau de recommandation          |
|----------------------------|--------------------------------------------------------------------------------|--------------------------------------------------------------------------|--------------------------------------------------------------------|-----------------------------------|
| Laisser tel quel           | Service residuel, non critique, impact nul sur production                      | Zero changement systeme, zero risque de regression                       | Bruit dans healthcheck (`failed_units=1`)                          | Bon court terme                   |
| Masquer (`systemctl mask`) | Service non utile en environnement installe, et on veut un etat systeme propre | Supprime les executions futures inutiles, reduit le bruit de supervision | Action irreversible sans `unmask` explicite, besoin de traçabilite | Recommande pour un systeme propre |
| Supprimer                  | Seulement si package/service obsoletes clairement identifies et testes         | Nettoyage maximal                                                        | Risque de suppression trop large, effets de bord package           | Faible recommandation             |

## Cas present: casper-md5check.service

- Contexte: service lie au controle de media Live ISO.
- Observation: echec detecte en system scope, aucun echec en user scope.
- Impact: pas d'impact fonctionnel sur la machine installee ni sur la pile MAJ DevOps++.

### Recommandation

- Recommandation cible (propre et coherente): **masquer** le service, pas le supprimer.
- Strategie prudente:
  1. Court terme: tolerer l'alerte si tu veux eviter tout changement maintenant.
  2. Stabilisation: masquer le service pour obtenir un healthcheck sans faux positif.
  3. Eviter la suppression package tant que non necessaire.

## Decision retenue (a tenir a jour)

- Date: 2026-07-03
- Decision: masquer `casper-md5check.service`
- Motif: service residuel Live ISO, non critique sur systeme installe, suppression du faux positif `failed_units=1`
- Validation apres reboot: a confirmer
- Validation apres cycle MAJ: a confirmer

## Trace d'execution (2026-07-03)

### 1) Diagnostic final

Commande:

```bash
systemctl --failed --type=service --no-pager | grep -E "casper-md5check\.service|UNIT|loaded units" || true
```

Observation:

- `casper-md5check.service` etait present en `failed`.
- `1 loaded units listed`.

### 2) Action appliquee

Commande:

```bash
sudo systemctl mask casper-md5check.service
```

Observation:

- Lien cree vers `/dev/null`.

### 3) Validation immediate

Commande:

```bash
systemctl is-enabled casper-md5check.service && sudo systemctl reset-failed casper-md5check.service && systemctl --failed --type=service --no-pager
```

Observation:

- Retour `masked`.
- Plus aucune unite `failed` affichee ensuite.

### Statut

- Etat final: propre et coherent.
- Impact production: aucun effet negatif attendu sur la machine installee.
