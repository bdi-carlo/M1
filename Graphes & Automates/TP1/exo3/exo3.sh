fstcompile --isymbols=ascii.isyms --osymbols=out.isyms homme.txt homme.fst
fstdraw --portrait --isymbols=ascii.isyms --osymbols=out.isyms homme.fst | dot -Tpng > homme.png
fstcompile --isymbols=ascii.isyms --osymbols=out.isyms Mars.txt Mars.fst
fstdraw --portrait --isymbols=ascii.isyms --osymbols=out.isyms Mars.fst | dot -Tpng > Mars.png
fstcompile --isymbols=ascii.isyms --osymbols=out.isyms Martien.txt Martien.fst
fstdraw --portrait --isymbols=ascii.isyms --osymbols=out.isyms Martien.fst | dot -Tpng > Martien.png

fstunion Mars.fst Martien.fst union1.fst
fstunion union1.fst homme.fst union.fst
fstdraw --portrait --isymbols=ascii.isyms --osymbols=out.isyms union.fst | dot -Tpng > union.png

fstrmepsilon union.fst unionrm.fst
fstdeterminize unionrm.fst unionrmdt.fst
fstminimize unionrmdt.fst unionrmdtmini.fst
fstclosure unionrmdtmini.fst union1.fst
fstrmepsilon union1.fst union2.fst
fstdeterminize union2.fst unionF.fst
fstdraw --acceptor --portrait --isymbols=ascii.isyms --osymbols=out.isyms unionF.fst | dot -Tpng > unionF.png

fstcompile --acceptor --isymbols=ascii.isyms hommeMars.txt hommeMars.fsa
#fstdraw --acceptor --portrait --isymbols=ascii.isyms homme.fsa | dot -Tpng > hommeMars.png

fstcompose hommeMars.fsa unionF.fst | fstproject --project_output > sortie.fst
fstrmepsilon sortie.fst sortieF.fst
fstdraw --acceptor --portrait --isymbols=out.isyms sortieF.fst | dot -Tpng > sortie.png
