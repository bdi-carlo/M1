#1
fstcompile --acceptor --isymbols=cc2_word.full.syms W.txt W.fsa
fstdraw --acceptor --portrait --isymbols=cc2_word.full.syms W.fsa | dot -Tpng > W.png

#2
fstcompile --isymbols=cc2_word.full.syms --osymbols=cc2_pron.full.syms cc2_w2p.100.fsm.txt W2P.100.fst
fstdraw --portrait --isymbols=cc2_word.full.syms --osymbols=cc2_pron.full.syms W2P.100.fst | dot -Tpng > W2P.100.png

#3
fstcompose W.fsa W2P.100.fst | fstproject --project_output > WTrad.fst
fstrmepsilon WTrad.fst WTradF.fst
fstdraw --acceptor --portrait --isymbols=cc2_pron.full.syms WTradF.fst | dot -Tpng > WTradF.png
# Prononciation: ax0 b ae1 n d ih0 n <s> aa1 k ih0 n

#4
fstcompile --isymbols=cc2_word.full.syms --osymbols=cc2_pron.full.syms cc2_w2p.full.fsm.txt W2P.full.fst
fstdraw --portrait --isymbols=cc2_word.full.syms --osymbols=cc2_pron.full.syms W2P.full.fst | dot -Tpng > W2P.full.png
fstcompose W.fsa W2P.full.fst | fstproject --project_output > WTrad2.fst
fstrmepsilon WTrad2.fst WTrad2F.fst
fstdraw --acceptor --portrait --isymbols=cc2_pron.full.syms WTrad2F.fst | dot -Tpng > WTrad2F.png
# Prononciation: too long to launch

#5
fstrmepsilon W2P.full.fst W2P.fullrm.fst
fstdeterminize W2P.fullrm.fst W2P.fulldet.fst
fstminimize W2P.fulldet.fst W2P.fullmin.fst
fstclosure W2P.fullmin.fst W2P.fullclos.fst
fstrmepsilon W2P.fullrclos.fst W2P.fullrm1.fst
fstdeterminize W2P.fullrm1.fst W2P.full.opt.fst