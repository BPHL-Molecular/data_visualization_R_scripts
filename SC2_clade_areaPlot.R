#!/usr/bin/env Rscript

library(readr)
library(dplyr)
library(stringr)
library(ggplot2)

#Parse command-line arguments
args = commandArgs(trailingOnly = TRUE)

if (length(args)==0) {
  stop("Must specify one argument, file (<date>_samples_by_date_Week#.txt)")
}

#Get today's date
d <- format(Sys.Date(), "%Y%m%d")

#Set output file names
out <- paste(d, "_SC2_clade_areaPlot.png", sep='')


#Read in file
meta <- read_tsv(args[1])


meta <- meta%>% filter(`Admin Division` == "Florida")
clades <- meta %>% select(Clade, `Collection Data`)

p <- ggplot(clades, aes(`Collection Data`, after_stat(count), fill = Clade)) + geom_area(stat = "bin", binwidth = 7) + ylab("SARS-CoV-2 Samples") + xlab("Sample Collection Date") + scale_fill_manual(values = c("#ffa500", "#ffd700",  "#c5db65", "#6ec6b3", "#1b8ae6")) + scale_x_date(date_breaks = "months", date_labels = "%B") + theme_classic()

ggsave(out, plot = p, dpi = 300, width = 16, height = 10, units = c("cm"))