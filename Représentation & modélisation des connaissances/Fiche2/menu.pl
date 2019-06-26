/* les entrées */
entree(crudites).
entree(terrine).
entree(melon).

/* les viandes (avec légumes associés) */
viande(steack).
viande(poulet).
viande(gigot).

/* les poissons (avec légumes associés) */
poisson(bar).
poisson(saumon).

/* les desserts */
dessert(sorbet).
dessert(creme).
dessert(tarte).

/* composition d'un menu simple : une entrée ET un plat ET un dessert */
menu_simple(E, P, D) :- entree(E), plat(P), dessert(D).

/* le plat de résistance : viande OU poisson */
plat(P) :- viande(P).
plat(P) :- poisson(P).

/* Etape 3
menu_simple(crudites, P, D).
menu_simple(crudites, P, mousseChocolat).
poisson(P), menu_simple(E, P, D).
poisson(P), menu_simple(melon, P, D).
*/

/* Etape 5
menu_simple(E, P, D), entree(crudites).	=> Affichage de tous les menus et il test si crudites est une entree.
menu_simple(E, P, D), !.	=> Affichage du premier menu trouvé.
menu_simple(E, P, D), poisson(P),!.	=> Affichage du premier menu trouvé avec du poisson.
menu_simple(E, P, D), !, poisson(P). => On prends le premier menu trouvé et on vérifie si il y a du poisson dedans.
*/
