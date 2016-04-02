default: strat.hs
	ghc -O2 strat.hs -rtsopts -threaded 

#-feager-blackholing

build: strat.hs

test: test.hs
	ghc -O2 test.hs -rtsopts -threaded

prof: 
	ghc -O2 strat.hs -fprof-auto -rtsopts -threaded

r:
	./strat
