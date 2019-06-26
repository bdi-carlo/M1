module Factorielle where
  -- Non terminale
  fac1(0) = 1
  fac1(n) = n * fac1(n-1)

  fac1_cpt(0) = 1
  fac1_cpt(n) = 1 + fac1_cpt(n-1)

  -- Terminale
  iterer(0, fac) = fac
  iterer(n, fac) = iterer(n-1, fac*n)

  fac2(n) = iterer(n,1)

  iterer(0, rep) = rep
  iterer(n, rep) = iterer(n-1, rep+1)

  fac2_cpt(n) = iterer(n,1)
