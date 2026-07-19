# 01 - But et perimetre

## But principal

Eviter le retour des icones blanches pour les fichiers `.code-workspace` dans Nemo (Linux Mint), y compris apres redemarrage ou rafraichissement de cache.

## Pourquoi cette manipulation

- Le type MIME `application/x-code-workspace` etait correct, mais le theme ne fournissait pas toujours une icone stable dans toutes les vues.
- L'affectation manuelle dans Nemo etait locale a certains fichiers et non fiable a grande echelle.

## Perimetre technique

- Systeme Linux Mint (Cinnamon)
- Theme d'icones actif: Mint-Y-Sand
- Cibles: tous les fichiers `*.code-workspace` sous `~/03_VSCode_Workspaces`

## Resultat vise

1. Affichage visuel coherent de tous les fichiers `.code-workspace`.
2. Methode reproductible par script.
3. Audit rapide pour verifier l'etat en moins de 1 minute.
