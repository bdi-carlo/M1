egaux(a,b,c,d) = a == b && c == d && a == d

max2(a,b) =
  if( b > a) then
    b
  else
    a

max4(a,b,c,d) = max2( max2(a,b), max2(c,d) )

distance(a,b) = abs(a - b)

sumDistance(x1,x2,x3,x4) = distance(x1,x2) + distance(x1,x3) + distance(x1,x4)

eloigne(a,b,c,d) =
  let dista = sumDistance(a,b,c,d) in
    let distb = sumDistance(b,a,c,d) in
      let distc = sumDistance(c,b,a,d) in
        let distd = sumDistance(d,b,c,a) in
          let maxDist = max4(dista, distb, distc, distd) in
            if maxDist == dista then a
            else if maxDist == distb then b
            else if maxDist == distc then c
            else d

q1 = do
  print $ "egaux(2,2,2,2)   => " ++ show(egaux(2,2,2,2))
  print $ "max4(1,2,3,4)    => " ++ show(max4(1,2,3,4))
  print $ "eloigne(3,2,4,6) => " ++ show(eloigne(3,2,4,6))

-- ======================================================================================================== --

data Dominos = Domino (Int,Int)
  deriving Show

chaineLinTest(Domino (a,b), Domino (c,d)) =  a == c || a == d || b == c || b == d
chaineLinRes(Domino (a,b), Domino (c,d)) =
  if a == c  then Domino (b,d)
  else if a == d  then Domino (b,c)
  else if b == c  then Domino (a,d)
  else Domino (a,c)

chaineLin3Test((Domino(a,b),Domino (c,d)), Domino (e,f)) =
  if chaineLinTest(Domino(a,b), Domino (e,f)) == True then
    chaineLinTest(chaineLinRes(Domino(a,b),Domino (e,f)), Domino(c,d))
  else if chaineLinTest(Domino(c,d), Domino (e,f)) == True then
    chaineLinTest(chaineLinRes(Domino(c,d),Domino (e,f)), Domino(a,b))
  else
    False

q2 = do
  print $ "avec (2-3) et (1-3)       => " ++ show(chaineLinTest(Domino (2,3), Domino (1,3))) ++ " => Res = "++ show(chaineLinRes(Domino (2,3), Domino (1,3)))
  print $ "avec (2-3) et (1-4)       => " ++ show(chaineLinTest(Domino (2,3), Domino (1,4)))
  print $ "avec (2-3) (2-4) et (1-3) => " ++ show(chaineLin3Test((Domino (2,3),Domino (2,4)), Domino (1,4)))
  print $ "avec (2-3) (2-4) et (1-2) => " ++ show(chaineLin3Test((Domino (2,3),Domino (2,4)), Domino (1,2)))

-- ======================================================================================================== --

oneWord(nb) =
  case nb of
    0 -> ""
    1 -> "un"
    2 -> "deux"
    3 -> "trois"
    4 -> "quatre"
    5 -> "cinq"
    6 -> "six"
    7 -> "sept"
    8 -> "huit"
    9 -> "neuf"
    10 -> "dix"
    11 -> "onze"
    12 -> "douze"
    13 -> "treize"
    14 -> "quatorze"
    15 -> "quinze"
    16 -> "seize"

dizaine(diz, unite) =
  let chaine = "" in

    if unite == 0 then
      case diz of
        1 -> chaine ++ "dix"
        2 -> chaine ++ "vingt"
        3 -> chaine ++ "trente"
        4 -> chaine ++ "quarante"
        5 -> chaine ++ "cinquante"
        6 -> chaine ++ "soixante"
        7 -> chaine ++ "soixante"
        8 -> chaine ++ "quatre-vingts"
        9 -> chaine ++ "quatre-vingt"

    else if (diz == 8) && (unite /= 1) then chaine ++ "quatre-vingts-"

    else if unite == 1 && diz <= 7 then
      case diz of
        2 -> chaine ++ "vingt et "
        3 -> chaine ++ "trente et "
        4 -> chaine ++ "quarante et "
        5 -> chaine ++ "cinquante et "
        6 -> chaine ++ "soixante et "
        7 -> chaine ++ "soixante et "

    else if (diz == 7 || diz == 9) && (unite > 6) then
      case diz of
        7 -> chaine ++ "soixante-dix-"
        9 -> chaine ++ "quatre-vingt-dix-"

    else
      case diz of
        1 -> chaine ++ "dix-"
        2 -> chaine ++ "vingt-"
        3 -> chaine ++ "trente-"
        4 -> chaine ++ "quarante-"
        5 -> chaine ++ "cinquante-"
        6 -> chaine ++ "soixante-"
        7 -> chaine ++ "soixante-"
        8 -> chaine ++ "quatre-vingt-"
        9 -> chaine ++ "quatre-vingt-"

nb2Letter(nb) =
  let chaine = "" in
    if nb < 16 then chaine ++ oneWord(nb)
    else if nb > 16 && nb < 100 then
      if (nb `div` 10 == 7 || nb `div` 10 == 9) && (nb `mod` 10 <= 6) then
        chaine ++ dizaine(nb `div` 10, nb `mod` 10) ++ oneWord((nb `mod` 10)+10)
      else
        chaine ++ dizaine(nb `div` 10, nb `mod` 10) ++ oneWord(nb `mod` 10)
    else
      "cent"

q3 = do
  print "Un nombre entre 1 et 100 inclus: "
  line <- getLine
  let nb = read line :: Integer in
    print $ "pour " ++ show(nb) ++ " -> " ++ nb2Letter(nb)

-- ======================================================================================================== --

-- Payer une somme s avec des pièces a b c d respectivement de 2 euros, 1 euro, 50 cts et 10 cts.
payer(s,(a,b,c,d)) = (a*2 + b*1 + c*0.5 + d*0.1) == s

q4 = do
  print $ "Peut-on payer 3.60euros avec 1 piece de 2euros, 1 piece de 1 euros, 1 piece de 0.5cts et 1 piece de 0.1cts => " ++ show(payer(3.6,(1,1,1,1)))

-- ======================================================================================================== --

main = do
  q4
