# flagging respondents for potentional removal

# possible removal (i.e., if enough flags)
# - didn't answer questions they should have (i.e., completion)
# - checked all activities in Q1
# - checked all basins
# - outrageous days values for individual questions
# - outrageous days values when summed
# - inconsistent days values across dimensions
# - completed survey too quickly

library(tidyverse)
source("R/prep-svy.R") # functions
svy <- readRDS("data-work/1-svy/svy-reshape.rds")

# Prep ------------------------------------------------------------------

# filter: remove incomplete Vrids
svy <- lapply(svy, function(x) semi_join(x, filter(svy$person, Vstatus == "Complete"), by = "Vrid"))

# drop activities which we don't care about
acts_of_interest <- unique(svy$basin$act)
svy_act_all <- svy$act
svy$act <- filter(svy$act, act %in% acts_of_interest)

# initialize flag table
svy$flag <- select(svy$person, Vrid) %>% mutate(flag = 0)

# Flag Details ------------------------------------------------------------

flag_details <- tribble(
    ~group, ~flag_name, ~flag_value, ~description,
    "incomplete", "na_days", 3, "Didn't answer question about total days",
    "incomplete", "na_part_water", 3, paste(
        "Didn't answer the question about whether they participated along the water", 
        "(i.e., missing values instead of Yes, No, or Not Sure)"
    ),
    "incomplete", "na_days_water", 3, "Didn't answer question about water days",
    "incomplete", "na_basin", 3, "Didn't answer question about basins",
    "incomplete", "na_basin_days", 3, "Didn't answer question about basin-days",
    "core_suspicious", "multiple_responses", 3, "Person (identified by id) has more than one Vrid (record)",
    "core_suspicious", "all_activities", 1, "Indicated participating in every single activity",
    "core_suspicious", "all_basins", 1, "Indicated participating in every single basin",
    "core_suspicious", "high_days", 1, "More than 365 days identified for any activity",
    "core_suspicious", "high_sum_days", 1, "More than 1000 days when summed across all activities",
    "suspicious", "high_water_days", 1, "More days along water than total days",
    "suspicious", "high_basin_days", 1, "Sum across basin days are >5 and more than double activity total water days",
    "suspicious", "low_basin_days", 1, "Total water days are >5 and sum across basin is 50% or lower than total water days"
)

# Flag-Completion  -----------------------------------------------------
# lot's of questions got skipped by survey takers

# demographics - these are all complete (i.e., no rows with missing values)
c("age", "sex", "income", "race", "hispanic") %>%
    sapply(function(x) filter(svy$person, is.na(x)), simplify = FALSE) %>%
    bind_rows()

# no answer to total days
new_flags <- svy$act %>%
    filter(part == "Checked", is.na(days))
svy$flag <- svy$flag %>%
    update_flags(new_flags, "na_days", 3, count_once = TRUE)

# no answer to participation along water
# - fish & water don't matter here since they are all along the water
svy$act %>% filter(part == "Checked", days != 0, !is.na(days)) %>% 
    count(act, part, part_water) %>% 
    spread(act, n) %>% knitr::kable()

new_flags <- svy$act %>% 
    filter(part == "Checked", !act %in% c("fish", "water"), is.na(part_water), 
           days != 0, !is.na(days))
svy$flag <- svy$flag %>%
    update_flags(new_flags, "na_part_water", 3, count_once = TRUE)

# no answer to days_water
new_flags <- svy$act %>%
    filter(part_water == "Yes", is.na(days_water))
svy$flag <- svy$flag %>%
    update_flags(new_flags, "na_days_water", 3, count_once = TRUE)

# no answer to basin participation
should_answer <- svy$act %>%
    mutate(days_water = ifelse(act %in% c("water", "fish"), days, days_water)) %>%
    filter(!is.na(days_water), days_water != 0) %>%
    select(Vrid, act, days_water_total = days_water)
new_flags <- svy$basin %>%
    right_join(should_answer, by = c("Vrid", "act")) %>%
    filter(is.na(part))
svy$flag <- svy$flag %>%
    update_flags(new_flags, "na_basin", 3, count_once = TRUE)

# no answer to basin days
should_answer <- svy$basin %>%
    filter(part == "Checked", basin != "none")
length(unique(should_answer$Vrid)) # 723 respondents got to this stage
new_flags <- svy$basin %>%
    semi_join(should_answer, by = c("Vrid", "act", "basin")) %>%
    filter(is.na(days_water))
svy$flag <- svy$flag %>%
    update_flags(new_flags, "na_basin_days", 3, count_once = TRUE)

# Flag-Core ------------------------------------------------------------------
# for determining how IPSOS gets paid

# multiple responses
dups <- svy$person %>% count(id) %>% filter(n > 1)
new_flags <- svy$person %>%
    semi_join(dups, by = "id")
svy$flag <- svy$flag %>%
    update_flags(new_flags, "multiple_responses", 4)

# all activities
new_flags <- svy_act_all %>% filter(part == "Checked") %>% count(Vrid) %>% filter(n == 14)
svy$flag <- svy$flag %>%
    update_flags(new_flags, "all_activities", 1)

# all basins
new_flags <- svy$basin %>% filter(part == "Checked", basin != "none") %>% 
    distinct(Vrid, basin) %>% count(Vrid) %>% filter(n == 9)
svy$flag <- svy$flag %>%
    update_flags(new_flags, "all_basins", 1)

# high days
new_flags <- svy$act %>% filter(days > 365)
# svy$act %>% filter(days_water > 365) # none of these
# svy$basin %>% filter(days > 365) # none of these
svy$flag <- svy$flag %>%
    update_flags(new_flags, "high_days", 1)

# high sum days
# svy$act %>% group_by(Vrid) %>% summarise(days = sum(days_water, na.rm = T)) %>% filter(days > 1000)
# svy$basin %>% group_by(Vrid) %>% summarise(days = sum(days, na.rm = T)) %>% filter(days > 1000)
new_flags <- svy$act %>% group_by(Vrid) %>% summarise(days = sum(days, na.rm = T)) %>% 
    filter(days > 1000)
svy$flag <- svy$flag %>%
    update_flags(new_flags, "high_sum_days", 1)

# Flag-suspicious ---------------------------------------------------------
# additional flags

# high days along water
sum_narm <- function(x) sum(x, na.rm = TRUE)
days_act <- svy$act %>% group_by(Vrid, act) %>% 
    summarise_at(vars(days, days_water), "sum_narm") %>%
    ungroup() %>%
    mutate(days_water = ifelse(act %in% c("fish", "water"), days, days_water))
new_flags <- days_act %>% filter(days_water > days)
svy$flag <- svy$flag %>%
    update_flags(new_flags, "high_water_days", 1)

# high basin days
days_basin <- svy$basin %>% group_by(Vrid, act) %>% 
    summarise(days_water = sum_narm(days_water)) %>%
    ungroup() 
basin_diff <- days_act %>%
    right_join(days_basin, by = c("Vrid", "act")) %>%
    # filter(!act %in% c("fish", "water")) %>%
    mutate(diff = days_water.y - days_water.x, ratio = days_water.y / days_water.x) 
new_flags <- basin_diff %>%
    filter(days_water.y >= 5, ratio >= 2)
svy$flag <- svy$flag %>%
    update_flags(new_flags, "high_basin_days", 1)

# low basin days
# - needs modification to deal with non-response in basin days question
non_response <- svy$basin %>%
    filter(part == "Checked", basin != "none", is.na(days_water)) %>%
    distinct(Vrid, act)
no_basin <- filter(svy$basin, basin == "none", part == "Checked")

new_flags <- basin_diff %>%
    anti_join(no_basin, by = c("Vrid", "act")) %>%
    anti_join(non_response, by = c("Vrid", "act")) %>%
    filter(days_water.x >= 5, ratio <= 0.50)
svy$flag <- svy$flag %>%
    update_flags(new_flags, "low_basin_days", 1)

# Groups ------------------------------------------------------------------

# grouping into 3 categories
# - core_suspicious: those that should be flagged for removal
# - all_suspicious: those that maybe should be flagged for removal
# - incomplete: those that didn't answer all survey questions they were presented

flag_values <- svy$flag %>%
    select(-flag) %>%
    gather(flag_name, value, -Vrid) %>%
    filter(value > 0) %>%
    left_join(flag_details, by = "flag_name") %>%
    select(Vrid, group, flag_name, value)
out <- mget(c("flag_details", "flag_values"))

# attach id
svy_raw <- readRDS("data-work/1-svy/svy-raw.rds")
out$flag_values <- out$flag_values %>%
    left_join(select(svy_raw, id, Vrid), by = "Vrid")

# total flag values by Vrid
out$flag_totals <- out$flag_values %>%
    group_by(Vrid) %>%
    summarise(flag = sum(value))

# Save --------------------------------------------------------------------

# a. flagging data
saveRDS(out, "data-work/1-svy/svy-flag.rds")
write_csv(out$flag_values, "out/1-svy/flags-all.csv")

# b. only those "core suspicious" for communication with IPSOS
core_suspicious <- out$flag_values %>%
    filter(group == "core_suspicious") %>%
    select(id, Vrid, flag_name, value)
core_suspicious %>%
    spread(flag_name, value, fill = 0) %>%
    arrange(id) %>%
    write_csv("out/1-svy/flags-core.csv")

# c. unique IDs to share with IPSOS (those that passed)
# - excludes incompletes and those core_suspicious with 3+ flags
exclude <- core_suspicious %>%
    group_by(id) %>%
    summarise(value = sum(value)) %>%
    filter(value >= 3)
svy$person %>%
    anti_join(exclude, by = "id") %>%
    distinct(id) %>%
    write_csv("out/1-svy/flags-ipsos-okay.csv")

# Double-check ------------------------------------------------------------
# quickly look at some raw data tests (for trail)

# No answer to participation along water
svy_raw %>%
    filter(var2O1 == "Checked", is.na(var47), var94 != 0) %>%
    select(var2O1, var94, var47)

# low basin days
trail_basin_days <- svy_raw %>%
    select(Vrid, var80O197:var80O213) %>%
    gather(var, days, na.rm = T, -Vrid) %>%
    group_by(Vrid) %>%
    summarise(trail_days = sum(days))

svy_raw %>%
    left_join(trail_basin_days, by = "Vrid") %>%
    filter(!is.na(var57), !is.na(trail_days), var57 / 2 >= trail_days, var57 >= 5) %>%
    select(Vrid, var57, trail_days) %>%
    arrange(Vrid)
filter(new_flags, act == "trail", days_water.y != 0) %>% arrange(Vrid)
