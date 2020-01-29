# Run each R script, storing knitted versions in log subfolders

source("R/workflow.R")

# oia
run_script("code/oia/1-prep-oia.R")
# run_script("code/oia/2-profile-oia.R")

# initial testing
run_script("code/0-svy-test/1-load-raw.R")
run_script("code/0-svy-test/2-check-svy.R")

# svy prep
run_script("code/1-svy/1-load-raw.R")
run_script("code/1-svy/2-reshape.R")
run_script("code/1-svy/explore-act-rates.R")
run_script("code/1-svy/3-flags.R")
run_script("code/1-svy/4-clean.R")
run_script("code/1-svy/5-recode-demographics.R")
run_script("code/1-svy/6-weight.R")
