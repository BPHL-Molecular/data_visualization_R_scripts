#!/usr/bin/env Rscript

#Author: Sarah Schmedes
#Email: sarah.schmedes@flhealth.gov

library(readr)
library(dplyr)
library(tidyr)
library(stringr)

#Parse command-line arguments
args = commandArgs(trailingOnly = TRUE)

if (length(args)==0) {
    stop("Three arguments must be supplied (FL and GIS input files and city/county)", call. = FALSE)
}

#Read in metadata files
fl = read_delim(args[1], col_names = TRUE, delim = "\t")
gis = read_delim(args[2], col_names = TRUE, delim ="\t")

loc = args[3]

#merge metadata dataframes
meta = full_join(gis, fl, by = "strain")
meta = meta %>% replace_na(list(county = '', city = '', state_of_residence = ''))

#Correct string for originating_lab and submitting_lab entries by GISAID for BPHL
meta2 = meta %>% mutate(originating_lab = case_when(str_detect(originating_lab, 'Florida Bureau of Public Health Laboratories') ~ 'Florida Bureau of Public Health Laboratories', TRUE ~ originating_lab))
meta2 = meta2 %>% mutate(submitting_lab = case_when(str_detect(submitting_lab, 'Florida Bureau of Public Health Laboratories') ~ 'Florida Bureau of Public Health Laboratories', TRUE ~ submitting_lab))

#Add county or city to FL-BPHL samples
if (loc == "county") {
    meta_final = meta2 %>% mutate(location = case_when(originating_lab == 'Florida Bureau of Public Health Laboratories' ~ county, TRUE ~ location))
}
if (loc == "city") {
    meta_final = meta2 %>% mutate(location = case_when(originating_lab == 'Florida Bureau of Public Health Laboratories' ~ city, TRUE ~ location))
}

meta_final = meta_final %>% replace_na(list(location = ''))

out_file = paste("metadata_", loc, ".tsv", sep='')

#Write to file
write_tsv(meta_final, out_file, col_names = TRUE)