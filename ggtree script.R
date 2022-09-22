library("ggtree")
library("treeio") # for tree data input & output
library("tidytree")
library("readxl")
library("ggplot2")
library("ggtreeExtra") 
library(tidyverse)
library(RColorBrewer)
tree <- read.iqtree("SNPs_boot.treefile")
# get.tree() or as.phylo() methods can convert the treedata object to a phylo object 
as.phylo(tree) 
get.tree(tree)
get.fields(tree) #returns vector of attributes stored in the object and associated with phylogeny
get.data(tree) #returns a tibble of all the associated data
SNPs_boot.treefile <- system.file("extdata", "sample.nwk", package="treeio")
tree <- read.tree(SNPs_boot.treefile)
ggtree(tree2) +
  geom_point(aes(shape=isTip, color=isTip, size=3)) +
  geom_tiplab(size=3, color="purple")
ggtree(tree2) + 
  theme_tree2() +
  geom_tiplab(size=4, color="orange", linesize=0.02, align=TRUE)
# to add the internal node numbers
ggtree(tree2) + geom_text(aes(label=node), hjust=-.3) 
ggtree(tree2) + 
  geom_tiplab(size=3, color="purple")
# labelling clades
ggtree(tree2) + 
  geom_cladelabel(node=31, label="Some random clade", color="red")
# add offset to adjust the position of the label
ggtree(tree2) + 
  geom_tiplab() + 
  geom_cladelabel(node=31, label="Some random clade", 
                  color="red2", offset=.1)
# to add another label for the clade connecting L and J
ggtree(tree2) + 
  geom_tiplab(size=4, color="purple") + 
  geom_cladelabel(node=31, label="Some random clade", 
                  color="red", offset=.1) + 
  geom_cladelabel(node=22, label="A different clade", 
                  color="green", offset=.1)
#To highlight the entire clade
ggtree(tree2) + 
  geom_tiplab(size=3, color="purple") + 
  geom_hilight(node=31, fill="gold") + 
  geom_hilight(node=22, fill="purple", type="rect")
# connecting taxa - to show evolutionary events
ggtree(tree2) + 
  geom_tiplab() + 
  geom_taxalink("JBI22000771", "JBI22000866", color="blue") +
  geom_taxalink("JBI22000820", "JBI22000871", color="orange", curvature=-.6) +
  ggtitle(SNPs_boot.treefile)
