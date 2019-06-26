module Fibonnaci where
  -- Non terminale
  fibo1(0) = 0
  fibo1(1) = 1
  fibo1(n) = fibo1(n-1) + fibo1(n-2)

  -- Terminale
  iterer(a,b,0) = a
  iterer(a,b,n) = iterer(b, a+b, n-1)

  fibo2(n) = iterer(0,1,n)
