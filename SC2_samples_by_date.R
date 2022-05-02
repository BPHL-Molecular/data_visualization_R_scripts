#!/usr/bin/env Rscript

library(readr)
library(tidyr)
library(dplyr)
library(ggplot2)

#Parse command-line arguments
args = commandArgs(trailingOnly = TRUE)

if (length(args)==0) {
  stop("Must specify one argument, file (<date>_samples_by_date_Week#.txt)")
}

#Get today's date
d <- format(Sys.Date(), "%Y%m%d")

#Set output file names
out.date <- paste(d, "_SC2_PassingSamplesByDate.pdf", sep='')
out.week <- paste(d, "_SC2_PassingSamplesByWeek.pdf", sep='')

#Read in file
df <- read_tsv(args[1])

df <- df %>% select(Sample, Date)
df[2] <- as.Date(df$Date)

pd <- ggplot(df, aes(Date)) + geom_histogram(binwidth = 3, fill = "#69b3a2", color = "#e9ecef") + ylab("SARS-CoV-2 Samples") + xlab("SARS-CoV-2 Collection Date") + scale_x_date(date_breaks = "months", date_labels = "%B")

ggsave(out.date, plot = pd, width = 16, height = 14, units = c("cm"))

pw <- ggplot(df, aes(Date)) + geom_histogram(binwidth = 7, fill = "#69b3a2", color = "#e9ecef") + ylab("SARS-CoV-2 Samples") + xlab("SARS-CoV-2 Collection Date") + scale_x_date(date_breaks = "months", date_labels = "%B")


ggsave(out.week, plot = pw, width = 16, height = 14, units = c("cm"))