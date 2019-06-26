module Tree where
  import List

  data Tree a =
    Empty |
    Node(Tree a , a , Tree a)
    deriving Show

  --calcul la hauteur d'un arbre
  hauteur t = case t of{
    Empty -> 0;
    Node(g,_,d) -> max ((hauteur g) + 1) ((hauteur d) + 1);
  }

  --calcul le nb de feuilles d'un arbre
  nbFeuilles t = case t of{
    Empty -> 0;
    Node(Empty,_,Empty) -> 1;
    Node(g,_,d) -> (nbFeuilles g) + (nbFeuilles d);
  }

  --création des listes d'éléments
  listeElemsPrefixe t = case t of{
    Empty -> [];
    Node(g,e,d) -> e:(listeElemsPrefixe g) ++ (listeElemsPrefixe d); --on concatene avec ++
  }

  listeElemsPostfixe t = case t of{
    Empty -> [];
    Node(g,e,d) -> (listeElemsPostfixe g) ++ (listeElemsPostfixe d) ++ [e];
  }

  listeElemesSymetrie t =  case t of{
    Empty -> [];
    Node(g,e,d) -> (listeElemesSymetrie g) ++ [e] ++ (listeElemesSymetrie d);
  }

  --affiche un arbre donné en paramètre en parcours préfixé
  affichePrefixe t = affichageRec t "|__"

  affichageRec t chaine = case t of{
    Node(Empty,e,Empty) -> do{
      (putStr chaine);
      (print e)
    };
    Node(g,e,Empty) -> do{
      (putStr chaine);
      (print e);
      (affichageRec g ("   "++chaine))
    };
    Node(Empty,e,d) -> do{
      (putStr chaine);
      (print e);
      (affichageRec d ("   "++chaine))
    };
    Node(g,e,d) -> do{
      (putStr chaine);
      (print e);
      (affichageRec g ("   "++chaine));
      (affichageRec d ("   "++chaine))
    }
  }

  -- ================ ABR ================ --

  --teste si un arbre est un ABR
  bienForme t = case t of{
    Node(Empty,e,Empty) -> True;
    Node(g,e,Empty) -> (e >= (noeud g)) && (bienForme g);
    Node(Empty,e,d) -> (e < (noeud d)) && (bienForme d);
    Node(g,e,d) -> (e >= (noeud g)) && (e < (noeud d)) && (bienForme d)  && (bienForme g)
  }

  --renvoie la valeur d'un noeud
  noeud t = case t of{
    Empty -> error "bottom";
    Node(g,e,d) -> e
  }

  --insere un element à la bonne place dans un ABR
  insere t new = case t of{
    Empty -> Node(Empty,new,Empty);
    Node(g,e,d) ->
      if new <= e then
        Node((insere g new),e,d)
      else
        Node(g,e,(insere d new))
  }

  --c
  liste2arbre (tete:[]) = Node(Empty,tete,Empty)
  liste2arbre (tete:reste) = insere (liste2arbre reste) tete

  --d
  abr2liste tree = listeElemesSymetrie tree

  --e
  tri liste = abr2liste (liste2arbre liste)

  -- ================ TAS ================ --

  --a
  bienFormeTas t = case t of{
    Node(Empty,e,Empty) -> True;
    Node(g,e,Empty) -> (e <= (noeud g)) && (bienFormeTas g);
    Node(Empty,e,d) -> (e <= (noeud d)) && (bienFormeTas d);
    Node(g,e,d) -> (e <= (noeud g)) && (bienFormeTas g) && (e <= (noeud d)) && (bienFormeTas d);
  }

  --b
  insereTas t new = case t of{
    Empty -> Node(Empty,new,Empty);
    Node(g,e,d) ->
      if new < e then
        -- si le sous arbre-droit est plus grand que le gauche alors on insere a gauche
        case (hauteur g) <= (hauteur d) of{
          True -> Node((insereTas g e),new,d);
          False -> Node(g,new,(insereTas d e))
        }
      else
        --idem
        case (hauteur g) <= (hauteur d) of{
          True -> Node((insereTas g new),e,d);
          False -> Node(g,e,(insereTas d new))
        }
  }

  --c
  liste2arbreTas (tete:[]) = Node(Empty,tete,Empty)
  liste2arbreTas (tete:reste) = insereTas (liste2arbreTas reste) tete

  --d
  arbre2listeTas t = case t of{
    Empty -> [];
    Node(g,e,d) ->  trier (e:((arbre2listeTas g)++(arbre2listeTas d)))
  }

  --e
  triTas liste = arbre2listeTas (liste2arbreTas liste)
