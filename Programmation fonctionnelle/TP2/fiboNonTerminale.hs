import Fibonnaci

main = do
  print "nb: "
  line <- getLine
  let nb = read line :: Integer in
  print $ "Fibonacci Terminale = " ++ show(fibo1(nb))
