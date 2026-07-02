# 02 - Diagnostic Technique Et Causes Racines

## Commandes de diagnostic cle

```bash
whoami
printf 'DBUS=%s\n' "${DBUS_SESSION_BUS_ADDRESS:-}"
printf 'DESKTOP=%s\n' "${XDG_CURRENT_DESKTOP:-}"
systemctl --user status dconf.service --no-pager | sed -n '1,30p'
dconf dump /org/cinnamon/ | sed -n '1,120p'
gsettings get org.cinnamon panels-enabled
gsettings get org.cinnamon enabled-applets
```

## Resultats constates

| Controle                  | Resultat          | Conclusion                 |
|---------------------------|-------------------|----------------------------|
| DBUS_SESSION_BUS_ADDRESS  | present           | Bus utilisateur disponible |
| XDG_CURRENT_DESKTOP       | X-Cinnamon        | Contexte session valide    |
| dconf.service             | active (running)  | Service DCONF fonctionnel  |
| dconf dump /org/cinnamon/ | valeurs presentes | DCONF lisible              |
| gsettings panels-enabled  | 2 panels detectes | Persistance active         |

## Cause racine principale

Le faux diagnostic venait surtout d'une verification orientee vers un sous-chemin non representatif. Le controle pertinent pour cette plateforme etait:

- `dconf dump /org/cinnamon/`
- `gsettings get org.cinnamon panels-enabled`
- `gsettings get org.cinnamon enabled-applets`

## Cause racine secondaire

Incoherence historique de configuration avec references panel3 dans `enabled-applets`, alors que la cible finale etait une topologie a 2 panels.

## Correctifs techniques appliques

1. Sauvegarde prealable complete de `/org/cinnamon/`.
2. Nettoyage des references panel3 non voulues.
3. Re-declaration explicite de 2 panels persistants.
4. Verification immediate par `gsettings` et `dconf`.

## Compte rendu d'essais

| Essai | Action                       | Resultat                        |
|-------|------------------------------|---------------------------------|
| E1    | Diagnostic DBus/DCONF        | OK, services actifs             |
| E2    | Lock config 2 panels         | OK, cles mises a jour           |
| E3    | Reboot + verification        | OK, panels conserves            |
| E4    | Verification terminal VSCode | OK dans le bon contexte session |
