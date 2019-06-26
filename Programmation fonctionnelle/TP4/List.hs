module List where
  --somme des éléments d'une liste
  somme [] = 0
  somme (tete:reste) = tete + (somme reste)

  --produit des éléments d'une liste
  produit [] = 1
  produit (tete:reste) = tete * (produit reste)

  --longueur d'une liste
  longueur [] = 0
  longueur (_:reste) = 1 + (longueur reste)

  --insertion elem dans liste triée dans l'ordre croissant
  inserer e [] = [e]
  inserer e (tete:reste) =
    if e < tete then
      e:tete:reste
    else
      tete:(inserer e reste)

  --trie une liste dans l'ordre croissant
  trier [] = []
  trier (tete:reste) = inserer tete (trier reste)

  --concatène 2 listes
  concatene [] l2 = l2
  concatene (tete:reste) l2 = tete:(concatene reste l2)

  --inverse les éléments d'une liste
  inverse [] = []
  inverse (tete:reste) = concatene (inverse reste) [tete]
