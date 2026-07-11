# Baseline actuelle et strategie de securite

## 1. Decision retenue

La decision la plus saine est de considerer l'etat actuel comme baseline officielle de depart.

## 2. Pourquoi cette decision est la bonne

- Le systeme a deja ete restaure et stabilise.
- Cinnamon, les panels et Cinnamenu ont ete recuperes.
- Le Graphics Engine est maintenant en place.
- Les scripts de backup, health-check, restore et changement garde existent deja.

Partir de cet etat comme baseline permet d'ameliorer sans perdre le dernier point reellement sain.

## 3. Sequence recommandee

1. Figer la baseline actuelle par un backup officiel.
2. Produire un rapport de sante associe.
3. N'appliquer ensuite que des optimisations gardees.
4. Promouvoir une nouvelle baseline seulement apres validation.

## 4. Strategie avant chaque amelioration

- backup officiel ou backup de travail
- health-check avant changement
- application gardee du tweak
- validation visuelle
- confirmation manuelle si stable
- rollback si doute ou comportement anormal

## 5. Ce qui doit etre evite

- plusieurs tweaks en meme temps
- changement graphique sans backup
- changement graphique sans plan de retour
- validation trop rapide sans observer la session

## 6. Definition pratique de la baseline

La baseline est composee de:

- l'etat dconf Cinnamon
- .config/cinnamon
- .local/share/cinnamon
- .themes
- .icons
- un rapport de sante horodate

## 7. Niveau de prudence recommande

- Tweak Cinnamon/Muffin: faisable avec mode garde.
- Tweak applets tiers: faisable, mais plus sensible.
- Tweak pilote/stack systeme: hors pipeline simple, a traiter a part.

## 8. Conclusion

Oui, il faut considerer la baseline actuelle comme la baseline initiale du Graphics Engine.

## 9. Etat consolide courant

Une mini consolidation a ete figee apres validation des trois premiers tweaks prudents.

- background-transition='none'
- startup-animation=false
- desktop-effects-on-menus=false

Cette mini consolidation constitue le nouveau point de reprise conseille avant le tweak n°4.

L'ordre logique est donc:

1. Cahier des charges
2. Baseline officielle
3. Securite active
4. Ameliorations une par une
5. Nouvelle baseline seulement si les tests sont concluants
