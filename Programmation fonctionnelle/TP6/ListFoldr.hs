module ListFoldr where
  --definition du shcema reduce
  {-reduce op a l = case l of{
    [] -> a;
    t:r -> op t (reduce op a r)
  }-}

  --somme des elements
  somme :: (Foldable t, Num b) => t b -> b
  somme = foldr (+) 0

  --produit des elements
  produit :: (Foldable t, Num b) => t b -> b
  produit = foldr (*) 1

  --longueur d'une liste
  longueur :: (Foldable t, Num b) => t a -> b
  longueur = foldr (\_ -> (+ 1) ) 0

  --insertion elem dans liste triée dans l'ordre croissant
  inserer :: Ord t => t -> [t] -> [t]
  inserer e l = case l of{[] -> [e]; t:r -> if e < t then e:t:r else t:(inserer e r)}

  --tri dans l'ordre croissant
  --trier liste = foldr inserer [] 1

  --concatene 2 listes
  concatene :: Foldable t => t a -> [a] -> [a]
  concatene l1 l2 = foldr (:) l2 l1

  --norme d'un vecteur
  norme :: (Foldable t, Num a) => t a -> a
  norme = foldr (\ vi res -> res+vi*vi) 0

  --incrémentation de tous les elements
  incrementation :: (Foldable t, Num a) => t a -> [a]
  incrementation = foldr (\ vi res -> (vi+1):res) []

  --calcul de l'écart-type d'un vecteur
  --ecartType = foldr (\ vi res -> sqrt 1/(longueur) )
