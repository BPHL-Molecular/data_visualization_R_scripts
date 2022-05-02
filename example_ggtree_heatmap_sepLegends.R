#!/usr/bin/env Rscript

library(ggtree)
library(ggplot2)
library(readr)
library(dplyr)
library(stringr)
library(RColorBrewer)
library(cowplot)

#Read in tree files with ggtree
tree <- read.tree("SNPs_boot_Klebp.treefile")


#Read in metadata
meta <- read_tsv("20200724_SaraCREProject_metadataForTrees.txt", col_names = TRUE)
meta[is.na(meta)] <- "NA"
meta[meta == '-'] <- "NA"
meta$MLST <- as.character(meta$MLST)


#Kleb all tree and metadata
meta_k <- meta %>% filter(Species == 'Klebsiella pneumoniae')
meta_k_hm <- meta_k %>% select(MLST, AMR_Gene, Region)
rownames(meta_k_hm) <- meta_k$Accession

mlst <- sort(c(unique(meta_k_hm$MLST)))
mlst <- mlst[-15]
mlst <- sort(as.numeric(mlst))

ar <- sort(c(unique(meta_k_hm$AMR_Gene)))
ar <- ar[-4]

region <- sort(c(unique(meta_k_hm$Region)))
region <- region[-4]

hm_val <- c(mlst, ar, region, "NA")
col <- c(colorRampPalette(brewer.pal(11, "Spectral"))(14), brewer.pal(3, "Paired"), brewer.pal(5, "Set2"), "white")
names(col) <- hm_val

k <- ggtree(tree) + geom_treescale() + geom_tiplab()
p <- gheatmap(k, meta_k_hm, offset = 0.04, width=0.35, font.size=5, colnames_position= "top", colnames_angle = 90, colnames_offset_y = 0, hjust = 0) + scale_fill_manual(values = col, breaks = hm_val) + ylim(0, 37) + theme(legend.position = "none")
p  

#Make separate plots to get legends and patch together with cowplot
mlst_hm <- meta_k_hm %>% select(MLST)
mlst2 <- c(mlst,"NA")
col_mlst <- c(colorRampPalette(brewer.pal(11, "Spectral"))(14), "white")
names(col_mlst) <- mlst2
pm <- gheatmap(k, mlst_hm, offset = 0.03, width=0.35, font.size=5, colnames_position= "top", colnames_angle = 90, colnames_offset_y = 0, hjust = 0) + scale_fill_manual(name = "MLST ST", values = col_mlst, breaks = mlst2) + ylim(0, 37)
mlst_legend <- get_legend(pm)
pm

ar_hm <- meta_k_hm %>% select(AMR_Gene)
ar2 <- c(ar,"NA")
col_ar <- c(brewer.pal(3, "Paired"), "white")
names(col_ar) <- ar2
pa <- gheatmap(k, ar_hm, offset = 0.03, width=0.35, font.size=5, colnames_position= "top", colnames_angle = 90, colnames_offset_y = 0, hjust = 0) + scale_fill_manual(name = "AMR Gene", values = col_ar, breaks = ar2) + ylim(0, 37)
ar_legend <- get_legend(pa)
pa

region_hm <- meta_k_hm %>% select(Region)
region2 <- c(region,"NA")
col_region <- c(brewer.pal(5, "Set2"), "white")
names(col_region) <- region2
pr <- gheatmap(k, region_hm, offset = 0.03, width=0.35, font.size=5, colnames_position= "top", colnames_angle = 90, colnames_offset_y = 0, hjust = 0) + scale_fill_manual(name = "Region", values = col_region, breaks = region2) + ylim(0, 37)
region_legend <- get_legend(pr)
pr

plot_grid(p, mlst_legend, ar_legend, region_legend, ncol=4, rel_widths=c(1, .1, .1, .1))

ggsave("20200731_cgSNP_Kpneumoniae_tree.tiff", plot = last_plot(), dpi = 300, width = 30.5, height = 20, units = c("cm"), limitsize = TRUE)
