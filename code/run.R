# run analysis

source("R/workflow.R")

# OIA
run_script("code/oia/1-prep-oia.R") # oia-co (for CO svy weighting)
run_script("code/oia/2-spend-oia.R") # oia-spend2016

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

# - summaries with stats/figures for report
rmarkdown::render("code/1-svy/flag-summary.Rmd")
rmarkdown::render("code/1-svy/weight-summary.Rmd")
rmarkdown::render("code/1-svy/outlier-testing.Rmd")

# Spending: misc. data & final profiles/estimates
run_script("code/misc/1-spend-usfws.R") # usfws-spend2016
run_script("code/misc/2-year-adjust.R") # cpi, pop
run_script("code/misc/3-profile.R") # out/profiles.xlsx
run_script("code/misc/4-spend.R") # 2019 CO spending along waterways

# Economic contributions
run_script("code/implan/1-implan-convert.R")
run_script("code/implan/2-implan-stage.R")
run_script("code/implan/3-implan-import.R")
run_script("code/implan/4-implan-export.R")
run_script("code/implan/5-contributions.R")
