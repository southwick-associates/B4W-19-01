# recode survey data

# alot of modifications made here, general outline:
# 1. set fishing/water activities participation along water
# 2. recode participation questions to "Unchecked" if days == 0
# 3. set missing values for certain questions based on dimensional filtering

# Additions, etc.
# - adding svy$act$is_targeted to identify 9 activities of interest for the study
# - attach aggregate flag variable

# Outliers
# - setting obvious days outliers to missing (i.e, those > 365)

# Filters (maybe another script)
# - fixing the basin dimension (by applying a filter to exclude non-water participants)

library(tidyverse)
source("R/prep-svy.R") # functions
svy <- readRDS("data-work/1-svy/svy-reshape.rds")

# 1. Fishing & Water ---------------------------------------------------------

# For the fishing/water activities, we assumed that all their activity
#  is along the water, so the water-specific questions weren't asked.
# Recoding water-specific here to "Checked", "Yes", etc. to make that explicit

# demonstrate the need to recode
x <- svy$act %>% filter(act %in% c("water", "fish"), part == "Checked")
count(x, part, part_water)
summary(x)

# recode
svy$act <- svy$act %>% mutate(
    part_water = case_when(
        act %in% c("water", "fish") & part == "Checked" ~ "Yes", 
        act %in% c("water", "fish") & part == "Unchecked" ~ "No", 
        TRUE ~ part_water
    ),
    days_water = case_when(
        act %in% c("water", "fish") ~ days, TRUE ~ days
    )
)

# 2. Days zero recoding --------------------------------------------------------

# need to ensure those who entered zero days aren't counted as participants
# - for example, those who enter zero but currently counted as participants
filter(svy$act, days == 0, part == "Checked") %>% count(part, days)
filter(svy$act, days_water == 0, part_water == "Yes") %>% count(part_water, days_water)
filter(svy$basin, days_water == 0, part == "Checked") %>% count(part, days_water)

# recode
svy$act <- set_no_check(svy$act, part, days, "Unchecked")
svy$act <- set_no_check(svy$act, part_water, days_water, "No")
svy$basin <- set_no_check(svy$basin, part, days_water, "Unchecked")

# 3. Dimensional Issues from Missing values ----------------------------------

# Missing values caused problems in question filters.
# For example, those who didn't answer the "participation along water" question
#  still received the "how many days along water" question,
#  which some of them answered.

# This happened for all question-dependent filters in the survey.
# Downstream questions will be set to missing to preserve
#  the integrity of the filters (as they were intended to be set).
# some respondents have values for days_water when they skipped part_water
filter(svy$act, !is.na(days_water), is.na(part_water)) %>% count(act, part_water)

# this is caused by filters not being correctly set
# survey gizmo wasn't set up to deal with missing values

# Add svy$act$is_target variable --------------------------------------------

# for the svy$act table, to identify activities of interest for the study
svy$act <- svy$act %>% mutate(
    is_targeted = case_when(
        act %in% unique(svy$basin$act) ~ TRUE, TRUE ~ FALSE
    )
)
count(svy$act, is_targeted, act)

# Fix Basin Dimension -----------------------------------------------------

# The filter for the basin question wasn't correctly set
# - people who entered zero in activity water days were excluded
# - but this failed to filter out people who didn't check participation along the water
# - so we end up with a strange dimensional filter for this question

# - note: might need to consider activities like boating/fishing here
# - make sure you aren't missing anything
no_water <- filter(svy$act, is.na(part_water))
svy$basin %>%
    semi_join(no_water, by = c("Vrid", "act")) %>% 
    count(part)

# this filters to represent only those who participated along the water
svy$basin <- svy$basin %>%
    anti_join(no_water, by = c("Vrid", "act")) %>%
    rename(part_water = part)

# Outlier Recoding --------------------------------------------------------

# START HERE
# some obvious outliers for the days values will need to be reset


# Misc -----------------------------------------------------------------

# what does Vstatus == Disqualified mean?
# - didn't indicate participating in the activities of particular interest
# - no changes needed here
disqualified <- filter(svy$person, Vstatus == "Disqualified")
svy$act %>%
    semi_join(disqualified) %>%
    filter(part == "Checked")

# TODO --------------------------------------------------------------

# not sure if any additional cleaning will be needed
# might also consider doing this recoding pre-flagging given the new basin filter
# alternatively changing the flag code to deal with the basin dimension

# these are all good
svy$basin %>% filter(is.na(part), !is.na(days_water))
