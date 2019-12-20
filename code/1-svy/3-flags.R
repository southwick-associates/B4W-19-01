# flagging respondents for potentional removal

# possible removal (i.e., if enough flags)
# - didn't answer questions they should have (i.e., completion)
# - checked all activities in Q1
# - checked all basins
# - outrageous days values for individual questions
# - outrageous days values when summed
# - inconsistent days values across dimensions

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
    ~core, ~flag_name, ~flag_value, ~description,
    1, "na_days", 3, "Didn't answer question about total days",
    1, "na_part_water", 3, paste(
        "Didn't answer the question about whether they participated along the water", 
        "(i.e., missing values instead of Yes, No, or Not Sure)"
    ),
    1, "na_days_water", 3, "Didn't answer question about water days",
    1, "na_basin", 3, "Didn't answer question about basins",
    1, "na_basin_days", 3, "Didn't answer question about basin-days",
    1, "multiple_responses", 3, "Person (identified by id) has more than one Vrid (record)",
    1, "all_activities", 1, "Indicated participating in every single activity",
    1, "all_basins", 1, "Indicated participating in every single basin",
    1, "high_days", 1, "More than 365 days identified for any activity",
    1, "high_sum_days", 1, "More than 1000 days when summed across all activities",
    0, "high_water_days", 1, "More days along water than total days",
    0, "high_basin_days", 1, "Sum across basin days are >5 and more than double activity total water days",
    0, "low_basin_days", 1, "Total water days are >5 and sum across basin is 50% or lower than total water days"
)

# Identify Completion -----------------------------------------------------

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

# Other Flags ------------------------------------------------------------------

# multiple responses
dups <- svy$person %>% count(id) %>% filter(n > 1)
new_flags <- svy$person %>%
    semi_join(dups, by = "id")
svy$flag <- svy$flag %>%
    update_flags(new_flags, "multiple_responses", 3)

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
no_basin <- svy$basin %>% filter(basin == "none", part == "Checked")
new_flags <- basin_diff %>%
    anti_join(no_basin, by = c("Vrid", "act")) %>%
    filter(days_water.x >= 5, ratio <= 0.50)
svy$flag <- svy$flag %>%
    update_flags(new_flags, "low_basin_days", 1)

# Save --------------------------------------------------------------------

# combine
filter(flag_details, core == 0) # show non-core flags
flag_values <- svy$flag %>%
    # the core_flag ignores tests which we might not use
    mutate(core_flag = flag - high_water_days - high_basin_days - low_basin_days) %>%
    select(Vrid, core_flag, flag, na_days:low_basin_days)
out <- mget(c("flag_details", "flag_values"))

# attach id
svy <- readRDS("data-work/1-svy/svy-raw.rds")
out$flag_values <- right_join(select(svy, id, Vrid), out$flag_values, by = "Vrid")

# save
saveRDS(out, "data-work/1-svy/svy-flag.rds")
write_csv(out$flag_values, "data-work/1-svy/svy-flag.csv")

# Double-check ------------------------------------------------------------
# quickly look at some raw data tests (for trail)

# No answer to participation along water
svy %>%
    filter(var2O1 == "Checked", is.na(var47), var94 != 0) %>%
    select(var2O1, var94, var47)

# low basin days
trail_basin_days <- svy %>%
    select(Vrid, var80O197:var80O213) %>%
    gather(var, days, na.rm = T, -Vrid) %>%
    group_by(Vrid) %>%
    summarise(trail_days = sum(days))

svy %>%
    left_join(trail_basin_days, by = "Vrid") %>%
    filter(!is.na(var57), !is.na(trail_days), var57 / 2 >= trail_days, var57 >= 5) %>%
    select(Vrid, var57, trail_days) %>%
    arrange(Vrid)
filter(new_flags, act == "trail", days_water.y != 0) %>% arrange(Vrid)
