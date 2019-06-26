alibi(mardi, luc, bernard).
alibi(mardi, paul, bernard).
alibi(mardi, louis, luc).
alibi(jeudi, alain, luc).

douteux(alain).

venger(paul, jean).
venger(luc, jean).

heritier(bernard, jean).
heritier(jean, louis).

argent(louis, jean).
argent(luc, jean).

vu_faire_crime(jean, alain).

a_arme(luc).
a_arme(louis).
a_arme(alain).

desire_tuer(X) :- venger(X, jean).
desire_tuer(X) :- heritier(X, jean).
desire_tuer(X) :- argent(X, jean).
desire_tuer(X) :- vu_faire_crime(jean, X).

assassin(X) :- desire_tuer(X), a_arme(X), not(alibi(mardi, X, Y)), douteux(Y).
