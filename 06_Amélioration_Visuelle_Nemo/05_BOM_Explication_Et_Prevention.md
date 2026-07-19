# 05 - BOM explication et prevention

## Ce qu'est le BOM

Le BOM UTF-8 est la sequence d'octets `EF BB BF` ajoutee parfois au debut d'un fichier texte.

## Pourquoi ca casse les scripts

Pour un script shell, la premiere ligne doit commencer exactement par:

```bash
#!/usr/bin/env bash
```

Si un BOM est present avant `#!`, le noyau lit mal le shebang et peut produire:

- `#!/usr/bin/env: Aucun fichier ou dossier de ce nom`
- `Exec format error`

## Impact reel dans ce projet

- BOM dans les fichiers `.md`: generalement sans impact fonctionnel.
- BOM dans les `.sh`, `.service`, `.timer`: a eviter absolument.

## Verification rapide

```bash
xxd -g 1 -l 16 scripts/01_apply_workspace_icon_fix.sh
xxd -g 1 -l 16 scripts/02_audit_workspace_icons.sh
```

Si la sortie commence par `23 21`, c'est bon (`#!`).
Si la sortie commence par `ef bb bf 23 21`, il faut corriger.

## Correction immediate

```bash
sed -i '1s/^\xEF\xBB\xBF//' <fichier>
```

Exemple:

```bash
sed -i '1s/^\xEF\xBB\xBF//' scripts/01_apply_workspace_icon_fix.sh
```

## Prevention (recommandee)

1. Dans VS Code, enregistrer les scripts en `UTF-8` sans BOM.
2. Garder ce controle avant execution:
   - verifier le shebang en premiere ligne
   - verifier les 16 premiers octets avec `xxd`
3. En cas d'erreur shebang, appliquer directement la correction `sed` ci-dessus.

## Garde-fou projet

Un script anti-BOM est disponible:

- `scripts/03_bom_guard.sh`

Verifier un dossier:

```bash
./scripts/03_bom_guard.sh <chemin> --check
```

Corriger automatiquement:

```bash
./scripts/03_bom_guard.sh <chemin> --fix
```

## Regle pratique projet

- Les scripts executables doivent etre en UTF-8 sans BOM et en fin de ligne LF.
- Les notes Markdown peuvent rester telles quelles, sauf besoin d'uniformisation future.
