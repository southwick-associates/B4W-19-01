# run analysis

source("R/workflow.R")

# OIA
run_script("code/oia/1-prep-oia.R")
run_script("code/oia/2-spend-oia.R") # spending details by item
run_script("code/oia/3-profile-oia.R") # tgtRate, spend2016, avgSpendPicnic (AZ)

# initial CO svy testing
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
run_script("code/1-svy/7-recode-outliers.R") # output "svy-final.rds"
# save zipped file by hand for "data-work/1-svy/svy-final-csv/"

# summaries with stats/figures for report
rmarkdown::render("code/1-svy/flag-summary.Rmd")
rmarkdown::render("code/1-svy/weight-summary.Rmd")

# initial outlier work
rmarkdown::render("code/1-svy/outlier-testing.Rmd")
