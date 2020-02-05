# get OIA-based profiles

library(tidyverse)

# tgtRate -----------------------------------------------------------------
# percent of whole CO resident population in the CO svy target audience

svy_oia <- readRDS("data-work/oia/oia-co.rds")
count(svy_oia, in_co_pop)

# This rate is higher than the "All activities" reported in OIA (71.2%)
#  because those OIA numbers don't count team & individual sports (included here)
svy_oia %>%
    group_by(in_co_pop) %>%
    summarise(n = n(), wtn = sum(stwt)) %>%
    mutate(pct = wtn / sum(wtn)) %>%
    knitr::kable()

# Spend2016 ---------------------------------------------------------------

# AZ picnic
readRDS("data/misc/spend_picnic.rds")$avg %>%
    mutate(act = "picnic", year = 2018, type = "trip")
