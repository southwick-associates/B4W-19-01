# reshape (i.e., tidy) survey data to facilitate analysis
# - https://r4ds.had.co.nz/tidy-data.html

# 3 output tables (1 per dimension) stored in a list
# - person
# - act (person by activity)
# - basin (person by activity by basin)

library(tidyverse)
source("R/prep-svy.R") # functions

infile <- "data/interim/svy-raw.rds"
outfile <- "data/interim/svy-reshape.rds"
outfile_csv <- "data/interim/svy-reshape-csv/"

# Load Data ---------------------------------------------------------------

svy <- readRDS(infile)

# check ID uniqueness, should show TRUE
length(unique(svy$Vrid)) == nrow(svy)

# Person ------------------------------------------------------------

person <- select(svy, Vrid, id, Vstatus, age = var9, sex = var10, income = var11,
                 race = var12, race_other = var12O59Othr, hispanic = var13)

# check IDs
length(unique(svy$id)) # not unique in records, same person tho?
length(unique(svy$Vrid))
dups <- count(svy, id) %>% filter(n > 1)
semi_join(person, dups, by = "id") %>%
    arrange(id) %>%
    write_csv("data/interim/svy-id-dups.csv")

# Person-Activity ----------------------------------------------------------------

# Did you participate in any of the following activities in Colorado between 
# December 1, 2018 and November 30, 2019?
part <- svy %>%
    reshape_vars(var2O1:var2O15, dim_file = "data/raw/svy/act_labs.xlsx") %>%
    select(Vrid, act, part = val)

# along water?
part_water <- svy %>%
    reshape_vars(var47:var55, dim_file = "data/raw/svy/act_labs.xlsx") %>%
    select(Vrid, act, part_water = val)

# how many days?
days <- svy %>% 
    reshape_vars(var94:var103, dim_file = "data/raw/svy/act_labs.xlsx") %>%
    select(Vrid, act, days = val)

# days along water?
days_water <- svy %>%
    reshape_vars(var57:var66, dim_file = "data/raw/svy/act_labs.xlsx",
                 func = function(x) separate(x, "lab", c("lab1", "lab2"), sep = "\\[")) %>%
    select(Vrid, act, days_water = val)

# combine
act <- part %>%
    left_join(part_water) %>%
    left_join(days) %>%
    left_join(days_water)

# Person-Activity-Basin ----------------------------------------------------------

part <- svy %>%
    reshape_vars(var70O197:var78O294, dim_file = "data/raw/svy/pipe_labs.xlsx", dim_var = "lab2") %>%
    recode_basin() %>%
    select(Vrid, act, basin, part = val)

days <- svy %>%
    reshape_vars(var80O197:var88O293, dim_file = "data/raw/svy/pipe_labs.xlsx", dim_var = "lab2") %>%
    recode_basin() %>%
    select(Vrid, act, basin, days_water = val)

basin <- left_join(part, days)

# Save --------------------------------------------------------------------

out <- mget(c("person", "act", "basin"))
saveRDS(out, outfile)

# in csv format
sapply(names(out), function(nm) {
    write_list_csv(out, nm, outfile_csv)
})

# Summaries ---------------------------------------------------------------

# person
plot_choice(person, age)
plot_choice(person, sex)
plot_choice(person, income)
plot_choice(person, race)
plot_choice(person, race_other)
plot_choice(person, hispanic)

# act
plot_choice_multi(act, part, act) + ggtitle("Overall Participation")
plot_choice_multi(act, part_water, act, part) + facet_wrap(~ part) + 
    ggtitle("Participation along the water (facetted by overall participation)")
plot_num(act, days, act, part) + facet_wrap(~ part) +
    ggtitle("Overall Days (facetted by overall participation)")
plot_num(act, days_water, act, part_water) + facet_wrap(~ part_water)+
    ggtitle("Days along water (facetted by water participation)")

# basin
plot_choice_multi(basin, part, basin, act) + facet_wrap(~ act)
plot_num(basin, days_water, basin, part) + facet_wrap(~ part)
plot_num(basin, days_water, basin, act) + facet_wrap(~ act)
