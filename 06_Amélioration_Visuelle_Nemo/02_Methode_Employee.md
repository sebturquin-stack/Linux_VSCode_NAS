# 02 - Methode employee

## Logique de resolution

1. Verifier que le MIME des fichiers est bien `application/x-code-workspace`.
2. Ajouter une icone MIME utilisateur globale `application-x-code-workspace` (et sa variante symbolic).
3. Rafraichir les caches GTK/Nemo.
4. Harmoniser les metadonnees des fichiers `.code-workspace` avec `metadata::custom-icon-name=vscode` pour figer les cas persistants.

## Commandes clefs

```bash
xdg-mime query filetype <fichier>.code-workspace
gio info <fichier>.code-workspace | grep -E 'content-type|icon|custom-icon'
```

```bash
gtk-update-icon-cache -f ~/.local/share/icons/hicolor
nemo -q
```

```bash
gio set <fichier>.code-workspace metadata::custom-icon-name 'vscode'
```

## Pourquoi ca tient dans le temps

- La couche globale (MIME icon) couvre le comportement par defaut.
- La couche fichier (custom-icon-name) verrouille les rares cas de cache/retraitement Nemo.
- Le script d'audit permet de detecter immediatement toute regression.
