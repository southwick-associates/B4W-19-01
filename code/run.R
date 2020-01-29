# Run each R script, storing knitted versions in log subfolders

run_script <- function(script_dir, script_name) {
    rmarkdown::render(
        output_format = "github_document", # try this for md docs
        input = file.path("code", script_dir, script_name),
        output_dir = file.path("code", script_dir, "log"),
        knit_root_dir = getwd()
    )
}

# oia
run_script("oia", "1-prep-oia.R")
# run_script("oia", "2-profile-oia.R")

# initial testing
run_script("0-svy-test", "1-load-raw.R")
run_script("0-svy-test", "2-check-svy.R")

# svy prep
run_script("1-svy", "1-load-raw.R")
run_script("1-svy", "2-reshape.R")
run_script("1-svy", "3-flags.R")
run_script("1-svy", "4-clean.R")
run_script("1-svy", "5-recode-demographics.R")
run_script("1-svy", "6-weight.R")
