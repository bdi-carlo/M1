not(0,1).
not(1,0).

and(0,0,0).
and(0,1,0).
and(1,0,0).
and(1,1,1).

or(0,0,0).
or(0,1,1).
or(1,0,1).
or(1,1,1).

nand(0,0,1).
nand(0,1,1).
nand(1,0,1).
nand(1,1,0).

nor(0,0,1).
nor(0,1,0).
nor(1,0,0).
nor(1,1,0).

xor(0,0,0).
xor(0,1,1).
xor(1,0,1).
xor(1,1,0).

xnor(0,0,1).
xnor(0,1,0).
xnor(1,0,0).
xnor(1,1,1).


circuit(X,Y,Z) :- not(X,S1), nand(X,Y,S2), xor(S1,S2,S3), not(S3,Z).
