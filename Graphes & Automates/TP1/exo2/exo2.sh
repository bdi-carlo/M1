fstcompile --acceptor --isymbols=ascii.isyms Mars.txt Mars.fsa
fstdraw --acceptor --portrait --isymbols=ascii.isyms Mars.fsa | dot -Tpng > Mars.png
fstcompile --acceptor --isymbols=ascii.isyms homme.txt homme.fsa
fstdraw --acceptor --portrait --isymbols=ascii.isyms homme.fsa | dot -Tpng > homme.png
fstcompile --acceptor --isymbols=ascii.isyms Martien.txt Martien.fsa
fstdraw --acceptor --portrait --isymbols=ascii.isyms Martien.fsa | dot -Tpng > Martien.png

fstunion Mars.fsa Martien.fsa union1.fsa
fstunion union1.fsa homme.fsa union.fsa

fstrmepsilon union.fsa unionrm.fsa
fstdeterminize unionrm.fsa unionrmdt.fsa
fstminimize unionrmdt.fsa unionrmdtmini.fsa
fstclosure unionrmdtmini.fsa union1.fsa
fstrmepsilon union1.fsa union2.fsa
fstdeterminize union2.fsa unionF.fsa
fstdraw --acceptor --portrait --isymbols=ascii.isyms unionF.fsa | dot -Tpng > unionF.png

fstshortestpath --nshortest=2 unionF.fsa test.fsa
fstdraw --acceptor --portrait --isymbols=ascii.isyms test.fsa | dot -Tpng > test.png
