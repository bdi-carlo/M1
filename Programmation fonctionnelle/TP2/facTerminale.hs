import Factorielle

main = do
  print "nb: "
  line <- getLine
  let nb = read line :: Integer in
  print $ "Factorielle Terminale = " ++ show(fac2(nb))
