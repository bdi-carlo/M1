import ListFoldr

q1 = do
  let v = [25,13,65,3,42] in
    do
      print "v1 = [25,13,65,3,42] & v2 = [78,89,12]"
      print $ "somme -> " ++ show(somme v)
      print $ "produit -> " ++ show(produit v)
      print $ "longueur -> " ++ show(longueur v)
    --  print $ "trier -> " ++ show(trier v)
      print $ "concatene v1 et v2 -> " ++ show(concatene v [78,89,12])
      print $ "norme de [1,2,3] -> " ++ show(norme [1,2,3])
      print $ "incrementation de v1 -> " ++ show(incrementation v)

-- ========================================================================= --

main = do
  q1
