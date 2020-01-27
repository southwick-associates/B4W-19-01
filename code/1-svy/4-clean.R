# clean survey data
# - days zero recoding (to ensure those who entered zero days aren't counted as participants)
# - fixing the basin dimension (by applying a filter to exclude non-water participants)
# - setting obvious days outliers to missing (i.e, those > 365)

library(tidyverse)
source("R/prep-svy.R") # functions

svy <- readRDS("data-work/1-svy/svy-reshape.rds")
# flag <- readRDS("data-work/1-svy/svy-flag.rds")

# Vstatus -----------------------------------------------------------------

# what does disqualified mean?
# - didn't indicate participating in the activities of particular interest
# - no changes needed here
disqualified <- filter(svy$person, Vstatus == "Disqualified")
svy$act %>%
    semi_join(disqualified) %>%
    filter(part == "Checked")

# Days zero recoding --------------------------------------------------------

# quite a few of these need to be recoded
svy$act <- set_no_check(svy$act, part, days, "Unchecked")
svy$act <- set_no_check(svy$act, part_water, days_water, "No")
svy$basin <- set_no_check(svy$basin, part, days_water, "Unchecked")

# Fix Basin Dimension -----------------------------------------------------

# The filter for the basin question wasn't correctly set
# - people who entered zero in activity water days were excluded
# - but this failed to filter out people who didn't check participation along the water
# - so we end up with a strange dimensional filter
no_water <- filter(svy$act, is.na(part_water))
svy$basin %>%
    semi_join(no_water, by = c("Vrid", "act")) %>% 
    count(part)

# this codes the dimension to represent only those who participated along the water
svy$basin <- svy$basin %>%
    anti_join(no_water, by = c("Vrid", "act")) %>%
    rename(part_water = part)

# Outlier Recoding --------------------------------------------------------

# START HERE
# some obvious outliers for the days values will need to be reset



# TODO --------------------------------------------------------------

# not sure if any additional cleaning will be needed
# might also consider doing this recoding pre-flagging given the new basin filter

# these are all good
svy$basin %>% filter(is.na(part), !is.na(days_water))
