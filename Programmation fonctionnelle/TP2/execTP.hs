import Pow2_test

somme(0) = 0
somme(n) = somme(n-1) + n

q1 = do
  print $ "somme(3) = " ++ show(somme(3))

-- ======================================================================================================== --

q2 = do
  let nb = 9 in
    --print $ "fibo(15) = " ++ show(fibo2(15))
    print $ "pow2_test1("++show(nb)++") = " ++ show(pow2_test1(nb))

-- ======================================================================================================== --

nbPaquets(0,n2) = 0
nbPaquets(n1,0) = 0
nbPaquets(1,n2) = n2+1
nbPaquets(n1,1) = n1+1

nbPaquets(n1,n2) = nbPaquets(n1-1,n2) + nbPaquets(n1,n2-1)

nbPaquets3(n1,n2,n3) = nbPaquets(n1,n2) * nbPaquets(n1+n2,n3)

q3 = do
  print "n1: "
  n1 <- readLn
  print "n2: "
  n2 <- readLn
  print "n3: "
  n3 <- readLn
  print $ "Il y a " ++ show(nbPaquets3(n1,n2,n3)) ++ " paquets finaux differents."

-- ======================================================================================================== --

multiRusse(0,y) = 0
multiRusse(x,y) =
  if (x `mod` 2) == 0 then
    multiRusse( (x `div` 2) , 2*y )
  else
    multiRusse( ((x-1) `div` 2) , (2*y) ) + y

q4 = do
  print "n1: "
  n1 <- readLn
  print "n2: "
  n2 <- readLn
  print $ "n1 x n2 = " ++ show(multiRusse(n1,n2))

-- ======================================================================================================== --

main = do
  q4
