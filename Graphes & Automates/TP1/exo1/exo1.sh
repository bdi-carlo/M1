fstcompile --acceptor --isymbols=A.isyms A.txt A.fsa
fstdraw --acceptor --portrait --isymbols=A.isyms A.fsa | dot -Tpng > A.png
fstcompile --acceptor --isymbols=A.isyms B.txt B.fsa
fstdraw --acceptor --portrait --isymbols=A.isyms B.fsa | dot -Tpng > B.png
fstunion A.fsa B.fsa AuB.fsa
fstdraw --acceptor --portrait --isymbols=A.isyms AuB.fsa | dot -Tpng > AuB.png
fstintersect A.fsa B.fsa AinterB.fsa
fstdraw --acceptor --portrait --isymbols=A.isyms AinterB.fsa | dot -Tpng > AinterB.png
fstconcat A.fsa B.fsa AconcatB.fsa
fstdraw --acceptor --portrait --isymbols=A.isyms AconcatB.fsa | dot -Tpng > AconcatB.png
fstclosure A.fsa AK.fsa
fstdraw --acceptor --portrait --isymbols=A.isyms AK.fsa | dot -Tpng > AK.png
fstclosure B.fsa BK.fsa
fstdraw --acceptor --portrait --isymbols=A.isyms BK.fsa | dot -Tpng > BK.png
fstrmepsilon AinterB.fsa Crme.fsa
fstdraw --acceptor --portrait --isymbols=A.isyms Crme.fsa | dot -Tpng > Crme.png
fstdeterminize Crme.fsa CrmeDt.fsa
fstdraw --acceptor --portrait --isymbols=A.isyms CrmeDt.fsa | dot -Tpng > CrmeDt.png
fstdeterminize AuB.fsa AuBDt.fsa
fstdraw --acceptor --portrait --isymbols=A.isyms AuBDt.fsa | dot -Tpng > AuBDt.png
fstcompile --acceptor --isymbols=A.isyms M.txt M.fsa
fstdraw --acceptor --portrait --isymbols=A.isyms M.fsa | dot -Tpng > M.png
fstminimize M.fsa Mmini.fsa
fstdraw --acceptor --portrait --isymbols=A.isyms Mmini.fsa | dot -Tpng > Mmini.png
fstshortestpath --nshortest=4 A.fsa A4.fsa
fstdraw --acceptor --portrait --isymbols=A.isyms A4.fsa | dot -Tpng > A4.png
