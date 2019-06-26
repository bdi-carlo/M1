;TP1 Benjamin Di Carlo

(deffacts faits-initiaux
  (personne 1 Albert homme)
  (personne 2 Martine femme)
  (personne 3 Christianne femme)
  (personne 4 Daniel homme)
  (personne 5 Eugenie femme)
  (personne 6 Herve homme)
  (personne 7 Laurent homme)
  (personne 8 Nicolas homme)
  (personne 9 Thierry homme)
  (personne 10 Stephanie femme)
  (personne 11 Sylvain homme)
  (personne 12 Philippe homme)
  (personne 13 Eric homme)

  (famille parent-de pere Albert Martine)    ;Albert est le père de Martine
  (famille parent-de pere Albert Christiane)
  (famille parent-de pere Albert Daniel)

  (famille parent-de mere Eugenie Martine)   ;Eugenie est la mère de Martine
  (famille parent-de mere Eugenie Christiane)
  (famille parent-de mere Eugenie Daniel)

  (famille parent-de mere Martine Herve)
  (famille parent-de mere Martine Laurent)
  (famille parent-de mere Martine Nicolas)

  (famille parent-de mere Christiane Thierry)
  (famille parent-de mere Christiane Stephanie)
  (famille parent-de mere Christiane Sylvain)

  (famille parent-de pere Daniel Philippe)
  (famille parent-de pere Daniel Eric)

  (texte mere " est la mere de ")
  (texte pere " est le pere de ")
  (texte frere " est le frere de ")
  (texte soeur " est la soeur de ")
  (texte grand-pere " est le grand pere de ")
  (texte grand-mere " est la gand mere de ")
  (texte oncle " est l'oncle de ")
  (texte tante " est la tante de ")
  (texte cousin " est le cousin de ")
  (texte cousine " est la cousine de ")

  (listePeres)
)

(defrule affichage "Affichage d'une relation entre 2 personnes"
  (famille ?relation ?rel ?pers1 ?pers2)
  (texte ?rel ?text)
  =>
  (printout t ?pers1 ?text ?pers2 crlf))

(defrule frere-soeur
  (personne ?id ?enfant1 ?sexe)
  (famille parent-de ?relation1 ?parent1 ?enfant1)
  (famille parent-de ?relation2 ?parent2 ?enfant2)
  (test (eq ?parent1 ?parent2))
  (test (neq ?enfant1 ?enfant2))
  =>
  (if (eq ?sexe homme)
    then
      (assert (famille frere-soeur frere ?enfant1 ?enfant2))
    else
      (assert (famille frere-soeur soeur ?enfant1 ?enfant2))))

(defrule soeur
  (personne ?id ?enfant1 femme)
  (famille parent-de ?relation1 ?parent1 ?enfant1)
  (famille parent-de ?relation2 ?parent2 ?enfant2)
  (test (eq ?parent1 ?parent2))
  (test (neq ?enfant1 ?enfant2))
  =>
  (assert (famille frere-soeur soeur ?enfant1 ?enfant2)))

(defrule grand-pere-mere
  (personne ?id ?parent1 ?sexe)
  (famille parent-de ?relation1 ?parent1 ?enfant1)
  (famille parent-de ?relation2 ?parent2 ?enfant2)
  (test (eq ?enfant1 ?parent2))
  =>
  (if (eq ?sexe homme)
    then
      (assert (famille grand-parents grand-pere ?parent1 ?enfant2))
    else
      (assert (famille grand-parents grand-mere ?parent1 ?enfant2))))

(defrule oncle-tante
  (famille parent-de ?relation1 ?parent1 ?enfant1)
  (famille parent-de ?relation2 ?parent2 ?enfant2)
  (famille frere-soeur ?relation3 ?parent1 ?parent2)
  (personne ?id ?parent1 ?sexe)
  =>
  (if (eq ?sexe homme)
    then
      (assert (famille oncle-tante oncle ?parent1 ?enfant2))
    else
      (assert (famille oncle-tante tante ?parent1 ?enfant2))))

(defrule cousin-cousine
  (famille parent-de ?relation1 ?parent1 ?enfant1)
  (famille parent-de ?relation2 ?parent2 ?enfant2)
  (famille frere-soeur ?relation3 ?parent1 ?parent2)
  (personne ?id ?enfant1 ?sexe)
  =>
  (if (eq ?sexe homme)
    then
      (assert (famille cousin-cousine cousin ?enfant1 ?enfant2))
    else
      (assert (famille cousin-cousine cousine ?enfant1 ?enfant2))))

(defrule listePere
  ?liste <- (listePeres ?elems)
  (famille parent-de pere ?papa ?enfant)
  (not(listePeres $? ?papa $?)) ;test si le papa est déjà dans la liste
  =>
  (retract ?liste)
  (assert (listePeres ?elems ?papa)))
