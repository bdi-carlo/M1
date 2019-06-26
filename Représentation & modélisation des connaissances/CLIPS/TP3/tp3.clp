;TP3 Benjamin DI CARLO

(deftemplate situation
  (slot x (allowed-values 0 1 2 3) (default 0))
  (slot y (allowed-values 0 1 2 3 4) (default 0))
  (slot pere (type FACT-ADDRESS SYMBOL) (default nil))
  (slot action (type STRING) (default "Situation initiale")))

(deffacts fait-initiaux
  ;faits qui permettent de connaitre les quantités en litres de chaque cruche après transvidage en fonction des quantités actuelles
  (trans3dans4 1 0 0 1)
  (trans3dans4 2 0 0 2)
  (trans3dans4 3 0 0 3)
  (trans3dans4 1 1 0 2)
  (trans3dans4 2 1 0 3)
  (trans3dans4 3 1 0 4)
  (trans3dans4 1 2 0 3)
  (trans3dans4 2 2 0 4)
  (trans3dans4 3 2 1 4)
  (trans3dans4 1 3 0 4)
  (trans3dans4 2 3 1 4)
  (trans3dans4 3 3 2 4)

  (trans4dans3 0 1 1 0)
  (trans4dans3 0 2 2 0)
  (trans4dans3 0 3 3 0)
  (trans4dans3 0 4 3 1)
  (trans4dans3 1 1 2 0)
  (trans4dans3 1 2 3 0)
  (trans4dans3 1 3 3 2)
  (trans4dans3 1 4 3 3)
  (trans4dans3 2 1 3 0)
  (trans4dans3 2 2 3 1)
  (trans4dans3 2 3 3 2)
  (trans4dans3 2 4 3 3)

  (situation))

(deffunction afficher-solution (?noeud)
  (if (neq ?noeud nil) then
    (bind ?pere (fact-slot-value ?noeud pere))
    (bind ?action (fact-slot-value ?noeud action))
    
    ;récupération des valeurs des 2 cruches
    (bind ?c1 (fact-slot-value ?noeud x))
    (bind ?c2 (fact-slot-value ?noeud y))
    (afficher-solution ?pere)
    (printout t ?action " -> (" ?c1 "," ?c2 ")" crlf)))

(defrule etat-final
  (declare (salience 99))
  (or ?fact <- (situation (x 2) (y ?))
      ?fact <- (situation (x ?) (y 2)))
  =>
  ;on affiche la solution finale et on arrête
  (afficher-solution ?fact)
  (halt))

;regle qui évite les situations déjà vues
(defrule deja-vu
  (declare (salience 100))
  ?f1 <- (situation (x ?c1) (y ?c2))
  ?f2 <- (situation (x ?c1) (y ?c2))
  (test (> (fact-index ?f2) (fact-index ?f1)))
  =>
  (retract ?f2))

;règles du problème

(defrule remplir-3L
  ?fact <- (situation (x 0) (y ?c2))
  =>
  (assert (situation (x 3) (y ?c2) (pere ?fact) (action "Remplir la cruche de 3 litres"))))

(defrule remplir-4L
  ?fact <- (situation (x ?c1) (y 0))
  =>
  (assert (situation (x ?c1) (y 4) (pere ?fact) (action "Remplir la cruche de 4 litres"))))

(defrule vider-3L
  ?fact <- (situation (x ?c1) (y ?c2))
  (test (neq ?c1 0))
  =>
  (assert (situation (x 0) (y ?c2) (pere ?fact) (action "Vider la cruche de 3 litres"))))

(defrule vider-4L
  ?fact <- (situation (x ?c1) (y ?c2))
  (test (neq ?c2 0))
  =>
  (assert (situation (x ?c1) (y 0) (pere ?fact) (action "Vider la cruche de 4 litres"))))

(defrule transvaser3dans4
  ?fact <- (situation (x ?c1) (y ?c2))
  (test (neq ?c1 0))
  (test (neq ?c2 4))
  (trans3dans4 ?c1 ?c2 ?new1 ?new2)
  =>
  (assert (situation (x ?new1) (y ?new2) (pere ?fact) (action "Transvaser la cruche de 3 litres dans la cruche de 4 litres"))))

(defrule transvaser4dans3
  ?fact <- (situation (x ?c1) (y ?c2))
  (test (neq ?c1 3))
  (test (neq ?c2 0))
  (trans4dans3 ?c1 ?c2 ?new1 ?new2)
  =>
  (assert (situation (x ?new1) (y ?new2) (pere ?fact) (action "Transvaser la cruche de 4 litres dans la cruche de 3 litres"))))
