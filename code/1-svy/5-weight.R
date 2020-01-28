# weight survey using OIA

library(tidyverse)
source("R/prep-svy.R")

svy <- readRDS("data-work/1-svy/svy-clean.rds")
flags <- readRDS("data-work/1-svy/svy-flag.rds")

# Add Flags ---------------------------------------------------------------

svy$person <- svy$person %>%
    left_join(flags$flag_totals, by = "Vrid") %>%
    mutate(flag = ifelse(is.na(flag), 0, flag))

# Weight ------------------------------------------------------------------

# temporarily store weight as 1 for non-excluded respondents
svy$person <- svy$person %>%
    mutate(weight = ifelse(flag >= 4, NA, 1))

# Save --------------------------------------------------------------------

# save as RDS
saveRDS(svy, "data-work/1-svy/svy-weight.rds")

# save as csvs (for Eric)
# - created zip file by hand
outdir <- "data-work/1-svy/svy-weight-csv"
sapply(names(svy), function(nm) {
    write_list_csv(svy, nm, outdir)
})

# not working, need to set command line stuff in Windows, bla
# files_to_zip <- dir(outdir, full.names = TRUE)
# zip(zipfile = "testZip", files = files_to_zip, flags = " a -tzip",
#     zip = "C:\\Program Files\\7-Zip\7z.exe")
