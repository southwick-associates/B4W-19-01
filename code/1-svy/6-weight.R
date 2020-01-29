# weight survey using OIA
# - based on this template: https://github.com/southwick-associates/rakewt-ashs

library(tidyverse)
source("R/prep-svy.R")

svy <- readRDS("data-work/1-svy/svy-demo.rds")
oia <- readRDS("data-work/oia/oia-co.rds")
flags <- readRDS("data-work/1-svy/svy-flag.rds")

# Add Flags ---------------------------------------------------------------

# Respondents passing the flag threshold will be excluded from analysis (and weighting)
svy$person <- svy$person %>%
    left_join(flags$flag_totals, by = "Vrid") %>%
    mutate(flag = ifelse(is.na(flag), 0, flag))
count(svy$person, flag)

svy_wt <- filter(svy$person, flag < 4)
count(svy_wt, flag)

# Get Pop Targets ---------------------------------------------------------

# using OIA survey data for target population
pop_data <- oia %>%
    filter(in_co_pop) %>% # to match CO target pop
    select(Vrid, sex, age_weight, income_weight, race_weight, stwt)

# get population distribution targets
weight_variable_names <- setdiff(names(pop_data), c("Vrid", "stwt"))
pop <- weight_variable_names %>%
    sapply(function(x) weights::wpct(pop_data[[x]], weight = pop_data$stwt))
pop

# Weight ------------------------------------------------------------------

# check: distributions of weighting variables
# - more female, older, less hispanic
sapply(names(pop), function(x) weights::wpct(svy_wt[[x]]))

# run weighting
svy_wt <- mutate(svy_wt, Vrid = as.integer(Vrid)) %>% data.frame()
svy_wt <- svy_wt %>%
    est_wts(pop, print_name = "CO survey", idvar = "Vrid") %>%
    mutate(Vrid = as.character(Vrid)) %>%
    select(Vrid, weight = rake_wt)
svy$person <- left_join(svy$person, svy_wt, by = "Vrid")

# check
summary(svy$person$weight)
sapply(names(pop), function(x) weights::wpct(svy$person[[x]], svy$person$weight))

# Save --------------------------------------------------------------------

glimpse(svy$person)
saveRDS(svy, "data-work/1-svy/svy-weight.rds")

# save as csvs (for Eric)
outdir <- "data-work/1-svy/svy-weight-csv"
sapply(names(svy), function(nm) {
    write_list_csv(svy, nm, outdir)
})
