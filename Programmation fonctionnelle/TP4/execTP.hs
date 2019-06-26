import List

q1 = do
  print $ "Somme de [2,1,4] -> " ++ show(somme [2,1,4])
  print $ "Produit de [2,1,4] -> " ++ show(produit [2,1,4])
  print $ "Longueur de [2,1,4] -> " ++ show(longueur [2,1,4])
  print $ "Insertion de 3 dans [2,1,4] -> " ++ show(inserer 3 [2,1,4])
  print $ "Trie [2,1,4] -> " ++ show(trier [2,1,4])
  print $ "Concatene [2,1,4] et [7,6,10] -> " ++ show(concatene [2,1,4] [7,6,10])
  print $ "Inverse [2,1,4] -> " ++ show(inverse [2,1,4])

-- =================================================================================================== --
--a
--max_un l = last(trier l)
max_un [] = error "Liste vide"
max_un [t] = t
max_un (tete:reste) =
  if tete > (max_un reste) then
    tete
  else
    (max_un reste)

--b
max_deux l = case inverse(trier l) of{
                                    t1:t2:reste -> (t1,t2);
                                    [t] -> (t,0);
                                  }
{-max_deux [] = error "Liste vide"
max_deux [t] = (t,0)
max_deux [t1,t2] = (t1,t2)
max_deux (tete1:tete2:reste) =
  if tete1 > reste && tete2 > reste
-}

--c
max_trois l = case inverse(trier l) of{
                                    t1:t2:t3:reste -> (t1,t2,t3);
                                    [t] -> (t,0,0);
                                    [t1,t2] -> (t1,t2,0);
                                  }

q2 = do
  print $ "Max de [2,1,4] -> " ++ show(max_un [2,1,4])
  print $ "Max 2 de [23,8,7,12,20,1] -> " ++ show(max_deux [23,8,7,12,20,1])
  print $ "Max 3 de [23,8,7,12,20,1] -> " ++ show(max_trois [23,8,7,12,20,1])

-- =================================================================================================== --
--a
intervalle_asc inf sup =
  if (inf+1) == sup then
    []
  else
    inserer (inf+1) (intervalle_asc (inf+1) sup)

--b
intervalle_desc inf sup = inverse(intervalle_asc inf sup)

q3 = do
  print $ "Liste entre 2 et 8 -> " ++ show(intervalle_asc 2 8)
  print $ "Liste entre 2 et 8 -> " ++ show(intervalle_desc 2 8)

-- =================================================================================================== --
--a
prefixes ([]) = [[]]
prefixes liste = concatene (prefixes (init liste)) [liste]

suffixes [] = [[]]
suffixes (tete:reste) = concatene [tete:reste] (suffixes reste)

q4 = do
  print $ "Prefixes avec [1,2,3] -> " ++ show(prefixes [[1,2],[3,4]])
  print $ "Suffixes avec [1,2,3] -> " ++ show(suffixes [1,2,3])

-- =================================================================================================== --
--a
inferieur u v = u <= v

--b
conjugue u i =
  let n = (longueur u) in
    if 1 < i && i > n then
      error "i doit etre compris entre 1 et n inclus!"
    else
      conjugue_rec u (i-1) n

conjugue_rec mot index 0 = []
conjugue_rec mot index n =
  if index == ((longueur mot)-1) then
    (mot!!(index)):(conjugue_rec mot 0 (n-1))
  else
    (mot!!(index)):(conjugue_rec mot (index+1) (n-1))

--c
lyndon u = lyndon_rec u ((longueur u)-1)
lyndon_rec u 1 = (inferieur u (conjugue u 1))
lyndon_rec u i =
  let res = (inferieur u (conjugue u i)) in
    if res == True then
      (lyndon_rec u (i-1))
    else
      res

--d
--trie une liste en enlevant les doublons
inserer2 e [] = [e]
inserer2 e (tete:reste) =
  if e < tete then
    e:tete:reste
  else if e == tete then
    (inserer2 e reste)
  else
    tete:(inserer2 e reste)

trier2 [] = []
trier2 (tete:reste) = inserer2 tete (trier2 reste)

insere_liste l1 l2 = (trier2 (concatene l1 l2))

--e
fusion_liste l1 l2 = fusion_liste_rec l2 l1 l2

fusion_liste_rec l2 [] (tete2:reste2) = []
fusion_liste_rec l2 (tete1:reste1) [] = fusion_liste_rec l2 reste1 l2
fusion_liste_rec l2 (tete1:reste1) (tete2:reste2) =
  let tmp = (concatene tete1 tete2) in
    if (tete1<tete2) && (lyndon tmp) == True then
      tmp:(fusion_liste_rec l2 (tete1:reste1) reste2)
    else
      (fusion_liste_rec l2 (tete1:reste1) reste2)

--f
genere n =
  if n < 1 then
    error "n doit etre >= 1!"
  else
    genere_rec n

genere_rec 1 = [[0],[1]]
genere_rec n = insere_liste (fusion_liste (genere_rec (1)) (genere_rec (n-1))) (fusion_liste (genere_rec (n-1)) (genere_rec (1)))


q5 = do
  print $ "biere < bonbon -> " ++ show(inferieur ['b','q','e','r','e'] ['b','o','n','b','o','n'])
  print $ "conjugue ['a','b','c','d'] 2 -> " ++ show(conjugue ['a','b','c','d'] 2)
  print $ "conjugue ['a','b','c','d','e'] 4 -> " ++ show(conjugue ['a','b','c','d','e'] 4)
  print $ "lyndon ['a','a','a','b'] -> " ++ show(lyndon ['a','a','a','b'])
  print $ "lyndon ['b','a','a','b'] -> " ++ show(lyndon ['b','a','a','b'])
  print $ "lyndon ['a','b','a','b'] -> " ++ show(lyndon ['a','b','a','b'])
  print $ "insere_liste [['0','1'],['1','0']] [['0','0','1'],['0','1']] -> "++ show(insere_liste [['0','1'],['1','0']] [['0','0','1'],['0','1']])
  print $ "fusion_liste [['0','0'],['0','1','1']] [['0','0','1'],['0','1']] -> "++ show(fusion_liste [['0','0'],['0','1','1']] [['0','0','1'],['0','1']])
  print $ "genere 1 -> " ++ show(genere 1)
  print $ "genere 2 -> " ++ show(genere 3)

-- =================================================================================================== --

main = do
  q5
