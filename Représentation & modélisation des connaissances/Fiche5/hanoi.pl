transferer(0, A, B, I).
transferer(1, A, B, I) :- deplacer(A, B).
transferer(N, A, B, I) :-
  M is N-1,
  transferer(M, A, I, B),
  deplacer(A, B),
  transferer(M, I, B, A).

deplacer(A, B) :- write('On deplace un disque de '), write(A), write(' vers '), write(B), nl.
