# run analysis

source("R/workflow.R")

# TODO:
# - code/oia/2-spend-oia.R
# - code/misc/2-spend-az-picnic.R
# - code/misc/3-year-adjust
# - code/misc/4-profile-2019.R: probably convert to 2019 here (ask Eric)

# - maybe update demographic figure to make gender thinner and income wider
#   proably make bars thinner (they have alot of visual weight)
#   could be generally a smaller figure as well
#   probably use "Other" for "Not white or Hispanic"
#   maybe larger margins between subplots
#   check SA branding doc for recommendation on color shading

# OIA
run_script("code/oia/1-prep-oia.R") # oia-co (for CO svy weighting)
run_script("code/oia/2-spend-oia.R") # oia-spend2016

# Misc. data & final profiles
run_script("code/misc/1-spend-usfws.R") # usfws-spend2016
run_script("code/misc/2-spend-az-picnic.R") # az-picnic-avgSpend2018
run_script("code/misc/3-year-adjust") # cpi, pop
run_script("code/misc/4-profile-2019.R") # profile-2019.xlsx

# CO svy initial testing
run_script("code/0-svy-test/1-load-raw.R")
run_script("code/0-svy-test/2-check-svy.R")

# CO svy prep
run_script("code/1-svy/1-load-raw.R")
run_script("code/1-svy/2-reshape.R")
run_script("code/1-svy/explore-act-rates.R")
run_script("code/1-svy/3-flags.R")
run_script("code/1-svy/4-clean.R")
run_script("code/1-svy/5-recode-demographics.R")
run_script("code/1-svy/6-weight.R")
run_script("code/1-svy/7-recode-outliers.R") # svy-final.rds
# save zipped file by hand for "data-work/1-svy/svy-final-csv/"

# summaries with stats/figures for report
rmarkdown::render("code/1-svy/flag-summary.Rmd")
rmarkdown::render("code/1-svy/weight-summary.Rmd")

# initial outlier work
rmarkdown::render("code/1-svy/outlier-testing.Rmd")
