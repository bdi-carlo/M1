;TP2 Benjamin DI CARLO

(deffacts faits-initiaux
  (animaux Bozo Bobby Betty Baloo Koko) ;liste des animaux

  (caracteristique poilu Bozo)
  (caracteristique poilu Bobby)
  (caracteristique poilu Betty)
  (caracteristique poilu Baloo)

  (caracteristique poche_ventrale Bozo)
  (caracteristique poche_ventrale Bobby)

  (caracteristique grands_bonds Bozo)
  (caracteristique grimpe_arbres Bobby)
  (caracteristique vole Betty)

  (caracteristique carnivore Betty)
  (caracteristique carnivore Baloo)
  (caracteristique eucalyptus Koko)
  (caracteristique bambou Koko)

  (caracteristique pond_oeufs Baloo)

  (espece koala un)
  (espece souris une)
  (espece chauve-souris une)
  (espece kangourou un)
  (espece opossum un)
  (espece ornithorynque un)
  (espece phalenger un)

  (question pond_oeufs "pond des oeufs")
  (question bambou "mange du bambou")
  (question eucalyptus "mange de l eucalyptus")
  (question vole "vole")
  (question carnivore "est un carnivore")
  (question poilu "est poilu")
  (question poche_ventrale "a une poche ventrale")
  (question grimpe_arbres "grimpe aux arbres")
  (question grands_bonds "fais de grands bons")

  (question faucon "est un faucon")
  (question queue_prehensile "a une queue prehensile")
  (question queue_longue "a une longue queue")
  (question phalenge_longue "a des phalenges longues")
)

(defrule regle-lait
  (caracteristique poilu ?nom)
  =>
  (assert (caracteristique donne_lait ?nom)))

(defrule regle-phalenger
  (caracteristique poche_ventrale ?nom)
  (caracteristique phalenge_longue ?nom)
  =>
  (assert (identification ?nom phalenger)))

(defrule regle-koala
  (caracteristique marsupial ?nom)
  (caracteristique grimpe_arbres ?nom)
  =>
  (assert (identification ?nom koala)))

(defrule regle-koala2
  (caracteristique eucalyptus ?nom)
  (not (caracteristique carnivore ?nom))
  (not (caracteristique bambou ?nom))
  =>
  (assert (identification ?nom koala)))

(defrule regle-marsupial
  (caracteristique donne_lait ?nom)
  (caracteristique poche_ventrale ?nom)
  =>
  (assert (caracteristique marsupial ?nom)))

(defrule regle-kangourou
  (caracteristique marsupial ?nom)
  (caracteristique grands_bonds ?nom)
  =>
  (assert (identification ?nom kangourou)))

(defrule regle-mammifere
  (caracteristique donne_lait ?nom)
  =>
  (assert (caracteristique mammifere ?nom)))

(defrule regle-chauve_souris
  (caracteristique vole ?nom)
  (caracteristique carnivore ?nom)
  (caracteristique donne_lait ?nom)
  =>
  (assert (identification ?nom chauve-souris)))

(defrule regle-oiseau_carnivore
  (caracteristique faucon ?nom)
  =>
  (assert (caracteristique oiseau_carnivore ?nom)))

(defrule regle-opossum
  (caracteristique marsupial ?nom)
  (caracteristique carnivore ?nom)
  (caracteristique queue_prehensile ?nom)
  =>
  (assert (identification ?nom opossum)))

(defrule regle-sud
  (caracteristique marsupial ?nom)
  =>
  (assert (caracteristique hemisphere_sud ?nom)))

(defrule regle-oiseau
  (caracteristique vole ?nom)
  (caracteristique pond_oeufs ?nom)
  =>
  (assert (caracteristique oiseau ?nom)))

(defrule regle-ornithorynque
  (caracteristique mammifere ?nom)
  (caracteristique pond_oeufs ?nom)
  =>
  (assert (identification ?nom ornithorynque)))

(defrule regle-souris
  (petit_caracteristique mammifere ?nom)
  (caracteristique queue_longue ?nom)
  =>
  (assert (identification ?nom souris)))

(defrule informe
  (identification ?nom ?espece)
  (espece ?espece ?deter)
  =>
  (printout t ?nom " est " ?deter " " ?espece crlf))

(defrule echec-identification
  (declare (salience -95))
  (animaux $? ?nom $?)
  (not (identification ?nom ?))
  =>
  (printout t "Je n ai pas pu identifier " ?nom crlf))

(defrule question-hypothese
  ;On met ici la priorité la plus basse car on pose des questions seulement après qu'on est identifié toutes les espèces possibles
  (declare (salience -99))
  (animaux $? ?nom $?)
  (not (identification ?nom ?))
  (question ?caract ?quest)
  (not (caracteristique ?caract ?nom))
  =>
  (printout t "Est ce que " ?nom " " ?quest "? " crlf)
  (if (eq (readline) "oui") then
    (assert (caracteristique ?caract ?nom))))
