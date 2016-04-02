Stratified sampling with Parallel Strategies
==============
Parallelism in Haskell is achievable using *Strategies*, or abstract containers of computations that carry a sort of meta-information about how they can be broken down for parallel execution.

This example performs Monte-Carlo stratified sampling of an image (map of Scotland) to determine what percentage of it is land area. Samples are generated randomly and split into chunks to be processed in parallel. For this a custom Strategy was created, *parMapChunk*, that splits a list into a specified number of chunks and maps a function over them.
```haskell
--Chunked application of a function on a list, like map
--Takes in Int - how many chunks to split in
parMapChunk :: Strategy b -> Int -> (a -> b) -> [a] -> [b]
parMapChunk strat chunkSize f = withStrategy (parListChunk chunkSize strat) . map f
```

A piece of in-depth mini research with code walkthrough is in [report.pdf](report.pdf).

Running
-------------
Install libraries:
```
cabal install parallel
cabal install JuicyPixels
```

Compile:
```
make
```
or
```
ghc -O2 strat.hs -rtsopts -threaded
```

Run:
```
./strat <samples> <parallel> +RTS -N -s
```
* *samples* - number of samples to collect
* *parallel* - *True* or *False* - enable/disable parallelism
* *+RTS -N* - uses maximum available cores (use -N2 for 2 cores, -N4 for 4 cores, etc)
* *+RTS -s* - displays statistics

If you opt for stats collection, watch this line of the output:
```
SPARKS : 4 (4 converted , 0 overflowed , 0 dud , 0 GC ’d , 0 fizzled )
```
The *converted* sparks are pieces of parallel code that were indeed executed in parallel. A *Fizzled* spark was either executed sequentially or not at all (garbage collected).

Literature
-----------
[Seq No More: Better Strategies for Parallel Haskell](http://community.haskell.org/ simonmar/papers/strategies.pdf)  
[Parallel and Concurrent Programming in Haskell v1.2](http://community.haskell.org/ simonmar/par-tutorial.pdf), Simon Marlow
[Control.Parallel.Strategies](https://hackage.haskell.org/package/parallel-3.2.0.4/docs/Control-Parallel-Strategies.html)  
