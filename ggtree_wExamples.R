#!/usr/bin/env Rscript

library(ggtree)
library(ggplot2)
library(tidyverse)

#Read in tree file with ggtree
treepath <- "/home/boljaxmolecular/data/listeria/20200324/out.RAxML_bestTree"
tree <- read.tree(treepath)

x <- as_tibble(tree)

p <- ggtree(tree, ladderize=FALSE) + geom_treescale() + geom_tiplab()
p2 <- p %>% collapse(node=27) + geom_point2(aes(subset=(node==27)), shape=21, size=5, fill='green')
p2

scaleClade(p, 27, .3) %>% collapse(27, 'mixed', fill="blue")


viewClade(p2, MRCA(p2, "JBI20000191", "JBI20000067"))