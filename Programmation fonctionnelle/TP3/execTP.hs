somme_termes fonction 0 = (fonction 0)
somme_termes fonction n = (fonction n) + somme_termes fonction (n-1)

--a
entier n = n

--b
impair n =
  if n`mod`2 == 1 then
    n
  else
    0

--c
questionC n =
  if n`mod`2 == 0 then
    -n
  else
    n

--d
puiss x n = (1-x)^n
inv100 x = somme_termes (puiss x) 100
inv100bis x = somme_termes (\n -> (1-x)^n) 100

q1 = do
  print $ show(somme_termes entier 100)
  print $ show(somme_termes impair 10)
  print $ show(somme_termes questionC 99)
  print $ show(inv100 0.5)

-- ================================================================================== --
somme_filtre fBool 0 = 0
somme_filtre fBool n =
  if (fBool n) then
    n + somme_filtre fBool (n-1)
  else
    somme_filtre fBool (n-1)

--a
pair nb = nb`mod`2 == 0

--b
est_parfait nb = (somme_filtre (\n -> nb`mod`n == 0) nb)`div`2 == nb

q2 = do
  print $ "somme nombres pairs <= 10 -> " ++ show(somme_filtre pair 10)
  print $ "est parfait 6 -> " ++ show(est_parfait 6)
  print $ "est parfait 5 -> " ++ show(est_parfait 5)

-- ================================================================================== --
--a
applyn 1 f x = (f x)
applyn n f x = (f (applyn (n-1) f x))

--b
power x n = applyn (n-1) (\n -> n*x) x

q3 = do
  print $ "5 fois f(x+1) -> " ++ show(applyn 5 (\n -> n+1) 10)
  print $ "2 puissance 4 -> " ++ show(power 2 4)

-- ================================================================================== --
--a
exemple(i,j) =
  if 1 <= i && i <= 6 && 1 <= j && j <= 5 then
    (True,2*i+j)
  else
    (False,0)

--b
identite_4_4(i,j) =
  if 1 <= i && i <= 4 && 1 <= j && j <= 4 && i == j then (True,1)
  else if 1 <= i && i <= 4 && 1 <= j && j <= 4 && i /= j then (True,0)
  else (False,0)

--c
l(m,i,j) =
  if( fst(m(i,j)) == False ) then i-1
  else
    l(m,i+1,j)

c(m,i,j) =
  if( fst(m(i,j)) == False ) then j-1
  else
    l(m,i,j+1)

dims(m) = ( l(m,1,1), c(m,1,1) )

--d
add_mat (mat_A, mat_B) i j =
  if( dims(mat_A) == dims(mat_B) ) then
    (\ (i,j) -> if (1 <= i && i <= fst(dims(mat_A)) && 1 <= j && j <= snd(dims(mat_A))) then (True, snd(mat_A(i,j))+snd(mat_B(i,j))) ) i j
  else
    error "bottom"


q4 = do
  print $ "valeur en (5,3) -> " ++ show(exemple(5,3))
  print $ "4x4 en (2,2) -> " ++ show(identite_4_4(2,2))
  print $ "C,L -> " ++ show(dims(identite_4_4))
  print $ "identite_4_4 * 2 -> " ++ show(add_mat(identite_4_4,identite_4_4,1,1))

-- ================================================================================== --

main = do
  q4
