library(ggtree)
library(ggplot2)
library(tidyverse)

#Read in tree file with ggtree"
tree <- read.tree("SNPs_boot.treefile")

ggtree(tree, right=TRUE) + geom_treescale() + geom_tiplab()

#Save plot as image
ggsave("SNPs_boot_tree.tiff", width = 17, height = 25, units = "cm")