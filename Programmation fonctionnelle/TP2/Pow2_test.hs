module Pow2_test where
  -- Terminale
  pow2_test1(2) = True
  pow2_test1(n) = do
    if (n `mod` 2) /= 0 then False
    else pow2_test1(n `div` 2)
