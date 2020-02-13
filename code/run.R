# run analysis

source("R/workflow.R") # run_script()

# OIA
run_script("code/oia/1-prep-oia.R") # oia-co (for CO svy weighting)
run_script("code/oia/2-spend-oia.R") # oia-spend2016
# TODO: oia-nonres participation

# CO svy initial testing
run_script("code/svy-test/1-load-raw.R")
run_script("code/svy-test/2-check-svy.R")

# CO svy prep
run_script("code/svy/1-load-raw.R")
run_script("code/svy/2-reshape.R")
run_script("code/svy/explore-act-rates.R")
run_script("code/svy/3-flags.R")
run_script("code/svy/4-clean.R")
run_script("code/svy/5-recode-demographics.R")
run_script("code/svy/6-weight.R")
run_script("code/svy/7-recode-outliers.R") # data/processed/svy.rds
# save zipped file by hand for "data/processed/svy-csv.zip"

# Summaries (with some stats/figures for report)
rmarkdown::render("code/summary/flag-summary.Rmd")
rmarkdown::render("code/summary/weight-summary.Rmd")
rmarkdown::render("code/summary/outlier-testing.Rmd")

# Profiles & spending estimates
run_script("code/est/1-spend-usfws.R") # usfws-spend2016
run_script("code/est/2-year-adjust.R") # cpi, pop
run_script("code/est/3-profile.R") # out/profiles.xlsx
run_script("code/est/4-spend.R") # 2019 CO spending along waterways

# TODO: update code below to make use of package implan

# Economic contributions
run_script("code/implan/0-sector-update.R")
run_script("code/implan/1-implan-input.R") # "data/processed/implan-import.xlsx"
# manually save "implan-import.xlsx" as "implan-import.xls"
# run implan externally & save it's output as csvs: data/raw/implan-out/
run_script("code/implan/2-contributions.R") # data/processed/contributions.xlsx
