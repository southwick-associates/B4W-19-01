# clean survey data

# 0. Drop those who checked "none" for activities
# 1. Set fishing/water activities participation along water
# 2. Set days to missing where days_water > days
# 2a. Set basin days to missing that are flagged "high" or "low"
# 3. Recode those who entered "none" for basins
#    act$part_water = "No", act$days_water = NA
# 4. Add act$is_targeted to identify 9 activities of interest for the study
# 5. Set obvious days outliers to missing (i.e, those > 365)

library(tidyverse)
source("R/prep-svy.R") # functions

outfile <- "data/interim/svy-clean.rds"
svy <- readRDS("data/interim/svy-reshape.rds")

# 0. Filter out respondents with "none" -----------------------------------

# IPSOS pre-screened with this same question so no respondents should
#  be indicating none
drop_vrids <- filter(svy$act, act == "none", part == "Checked") %>% distinct(Vrid)
svy$person <- anti_join(svy$person, drop_vrids, by = "Vrid")
svy$act <- anti_join(svy$act, drop_vrids, by = "Vrid") %>%
    filter(act != "none")

# 1. Fishing & Water ---------------------------------------------------------

# For the fishing/water activities, we assumed that all their activity
#  is along the water, so the water-specific questions weren't asked.
# Recoding water-specific here to "Checked", "Yes", etc. to make that explicit

# recode
svy$act <- svy$act %>% mutate(
    part_water = case_when(
        act %in% c("water", "fish") & part == "Checked" ~ "Yes", 
        act %in% c("water", "fish") & part == "Unchecked" ~ "No", 
        TRUE ~ part_water
    ),
    days_water = case_when(
        act %in% c("water", "fish") ~ days, TRUE ~ days_water
    )
)

# check recoding
x <- svy$act %>% filter(act %in% c("water", "fish"), part == "Checked")
count(x, part, part_water)
all.equal(x$days, x$days_water)

# 2. Days Recoding -------------------------------------------------------------

# Some respondents entered larger values for days_water than days
# All days values for these respondents (for given activity) are set to missing
#  since the days entered by these people are unreliable
high_water_days <- filter(svy$act, part_water == "Yes", days < days_water)
high_water_days

svy$act <- bind_rows(
    anti_join(svy$act, high_water_days, by = c("Vrid", "act")),
    semi_join(svy$act, high_water_days, by = c("Vrid", "act")) %>%
        mutate(days = NA, days_water = NA)
)

svy$basin <- bind_rows(
    anti_join(svy$basin, high_water_days, by = c("Vrid", "act")),
    semi_join(svy$basin, high_water_days, by = c("Vrid", "act")) %>%
        mutate(days_water = NA)
)

# 2a. Basin Days Recoding -------------------------------------------------

# Basin days can be highly inconsistent with water days
# All basin days where this occurs are set to missing (unreliable)

# - get relevant sums
days_act <- svy$act %>%
    filter(!is.na(days_water), days_water != 0)
days_basin <- svy$basin %>% 
    group_by(Vrid, act) %>% 
    summarise(days_water = sum(days_water, na.rm = TRUE)) %>%
    ungroup() 

# - get difference (basin - days_water)
basin_diff <- days_act %>%
    inner_join(days_basin, by = c("Vrid", "act"), suffix = c(".all", ".basin")) %>%
    mutate(
        diff = days_water.basin - days_water.all, 
        ratio = days_water.basin / days_water.all
) 

# - identify inconsistencies
flagged <- bind_rows(
    filter(basin_diff, days_water.basin >= 5, ratio >= 2) %>% mutate(flag = "high"),
    filter(basin_diff, days_water.all >= 5, ratio <= 0.5) %>% mutate(flag = "low")
)
count(flagged, flag)

# - set flagged to missing
svy$basin <- bind_rows(
    anti_join(svy$basin, flagged, by = c("Vrid", "act")),
    semi_join(svy$basin, flagged, by = c("Vrid", "act")) %>%
        mutate(days_water = NA)
)

# 3. Recode "none" in basins ----------------------------------------------

# The basins completey cover NE, so those who enter "none" shouldn't be
#  counted as along-the-water participants
no_basin <- filter(svy$basin, basin == "none", part == "Checked")
no_basin

svy$act <- bind_rows(
    anti_join(svy$act, no_basin, by = c("Vrid", "act")),
    semi_join(svy$act, no_basin, by = c("Vrid", "act")) %>%
        mutate(part_water = "No", days_water = NA)
)

# no longer need the "none" identifier
svy$basin <- filter(svy$basin, basin != "none")

# 4. Add is_targeted variable --------------------------------------------

# for the svy$act table, to identify activities of interest for the study
svy$act <- svy$act %>% mutate(
    is_targeted = case_when(
        act %in% unique(svy$basin$act) ~ TRUE, TRUE ~ FALSE
    )
)
count(svy$act, is_targeted, act)

# 5. Days Outliers --------------------------------------------------------

# some obvious outliers for days will be set to missing
filter(svy$act, days > 365 | days_water > 365)
filter(svy$basin, days_water > 365)
set_missing <- function(x) ifelse(!is.na(x) & x > 365, NA, x)

svy$basin <- mutate(svy$basin, days_water = set_missing(days_water))
svy$act <- mutate_at(svy$act, vars(days, days_water), "set_missing")

# Misc -----------------------------------------------------------------

# what does Vstatus == Disqualified mean?
# - didn't indicate participating in the activities of particular interest
# - no changes needed here
disqualified <- filter(svy$person, Vstatus == "Disqualified")
svy$act %>%
    semi_join(disqualified) %>%
    filter(part == "Checked")

# Save --------------------------------------------------------------------

svy$act <- select(svy$act, Vrid, act, is_targeted, part, days,
                  part_water, days_water)
svy$basin <- rename(svy$basin, part_water = part)

glimpse(svy$person)
glimpse(svy$act)
glimpse(svy$basin)

saveRDS(svy, outfile)
