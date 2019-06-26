import Factorielle

main = do
  print "nb: "
  line <- getLine
  let nb = read line :: Integer in
  print $ "Factorielle non Terminale = " ++ show(fac1(nb))
