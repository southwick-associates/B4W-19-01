# run analysis

# OIA
workflow::run("code/oia/1-prep-oia.R") # for CO svy weighting
workflow::run("code/oia/2-spend-oia.R")
workflow::run("code/oia/3-nonres-oia.R")

# CO svy initial testing
workflow::run("code/svy-test/1-load-raw.R")
workflow::run("code/svy-test/2-check-svy.R")

# CO svy prep
workflow::run("code/svy/1-load-raw.R")
workflow::run("code/svy/2-reshape.R")
workflow::run("code/svy/explore-act-rates.R")
workflow::run("code/svy/3-flags.R")
workflow::run("code/svy/4-clean.R")
workflow::run("code/svy/5-recode-demographics.R")
workflow::run("code/svy/6-weight.R")
workflow::run("code/svy/7-recode-outliers.R") # data/processed/svy.rds
# save zipped file by hand for "data/processed/svy-csv.zip"

# Summaries (with some stats/figures for report)
rmarkdown::render("code/summary/flag-summary.Rmd")
rmarkdown::render("code/summary/weight-summary.Rmd")
rmarkdown::render("code/summary/outlier-testing.Rmd")
rmarkdown::render("code/summary/compare-implan-sectoring.Rmd")

# Profiles & spending estimates
workflow::run("code/est/1-spend-usfws.R") # usfws-spend2016
workflow::run("code/est/2-year-adjust.R") # cpi, pop
workflow::run("code/est/3-profile.R") # out/profiles.xlsx
workflow::run("code/est/4-spend.R") # 2019 CO spending along waterways

# Economic contributions
workflow::run("code/implan/1-implan-input.R") # "data/processed/implan-import.xlsx"
# manually save "implan-import.xlsx" as "implan-import.xls"
# run implan externally & save it's output as csvs: data/raw/implan-out/
workflow::run("code/implan/2-contributions.R") # data/processed/contributions.xlsx
