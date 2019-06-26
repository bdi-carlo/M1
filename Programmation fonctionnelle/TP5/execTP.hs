import Tree

q1 = do
  let tree = Node( Node(Node(Empty,4,Empty),2,Node(Node(Empty,7,Empty),5,Node(Empty,8,Empty))), 1 ,Node(Empty,3,Node(Node(Empty,9,Empty),6,Empty)) ) in
    do{
      print $ "hauteur arbre -> " ++ show(hauteur tree) ++ " | nombre de feuilles -> " ++ show(nbFeuilles tree);
      print $ "liste prefixe -> " ++ show(listeElemsPrefixe tree) ++ " | liste postfixe -> " ++ show(listeElemsPostfixe tree) ++ " | liste symetrique -> " ++ show(listeElemesSymetrie tree);
      affichePrefixe tree
    }

-- ==================================================================================== --
q2a = do
  let tree1 = Node( Node(Node(Empty,4,Empty),2,Node(Node(Empty,7,Empty),5,Node(Empty,8,Empty))), 1 ,Node(Empty,3,Node(Node(Empty,9,Empty),6,Empty)) ) in
    let tree2 = Node( Node(Node(Empty,5,Empty),12,Node(Node(Empty,17,Empty),19,Node(Empty,24,Empty))), 30 ,Node(Node(Empty,36,Empty),43,Node(Empty,77,Empty)) ) in
    do{
      print $ "ABR tree1 -> " ++ show(bienForme tree1);
      print $ "ABR tree2 -> " ++ show(bienForme tree2);
      print "insertion de 13 dans tree2.";
      affichePrefixe (insere tree2 13);
      print $ "ABR tree2 -> " ++ show(bienForme tree2);
      print $ "transforme [5,1,6,3,2] en ABR";
      affichePrefixe (liste2arbre [5,1,6,3,2]);
      print $ "et le retransforme en liste croissante [5,1,6,3,2] en ABR -> " ++ show(abr2liste (liste2arbre [5,1,6,3,2]));
      print $ "trie de [15,20,78,1,3,56,2] en utilisant un ABR -> " ++ show(tri [15,20,78,1,3,56,2])
    }

q2b = do
  let tree = Node( Node(Node(Node(Empty,90,Empty),21,Node(Empty,22,Empty)),20,Node(Empty,80,Node(Empty,81,Empty))), 8 ,Node(Node(Node(Empty,75,Empty),12,Node(Empty,20,Empty)),10,Node(Node(Empty,80,Empty),11,Empty)) ) in
    do{
      print $ "TAS tree -> " ++ show(bienFormeTas tree);
      print "insertion de 6 dans tree.";
      affichePrefixe (insereTas tree 6);
      print "transforme [5,1,6,3,2] en TAS";
      affichePrefixe (liste2arbreTas [5,1,6,3,2]);
      print $ "tree en liste triee croissante -> " ++ show(arbre2listeTas tree);
      print $ "trie de [15,20,78,1,3,56,2] en utilisant un TAS -> " ++ show(triTas [15,20,78,1,3,56,2])
    }

-- ==================================================================================== --

main = do
  q2b
