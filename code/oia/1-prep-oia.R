# prepare OIA survey data for CO analysis
# - filtering to include CO residents & selecting necessary variables 
# - identify target population of CO survey
# - recode demographics for weighting CO survey data

library(tidyverse)
library(readxl)
source("R/prep-svy.R")

# Identify OIA Activities of Interest -------------------------------------

# The CO 2019 survey has a target population of CO residents who engaged
#  in at least one of 14 activities
read_excel("data/act_labs.xlsx") %>% filter(act != "none") %>% knitr::kable()

# using an approximate correspondence with the OIA survey activity questions
oia_activities <- read_excel("data/oia/oia-activities.xlsx", sheet = "oia-screener")
knitr::kable(oia_activities)

# variable names from OIA svy that represent activities in CO survey screener
co_activities <- oia_activities %>%
    filter(in_co_screener == 1) %>%
    pull(variable)
    
# Load OIA Svy Data ---------------------------------------------------------------

# pull in OIA 2016 survey data for CO residents
load("data/oia/svy-wtd.RDATA")

# data representative of the whole Colorado resident population
svy_all <- svy_wtd %>%
    filter(flag < 3, state == "Colorado") %>% 
    rename(income = d5) %>%
    as_tibble()

# only a small set of variables are needed
oia_vars <- c("Vrid", "Vstatus", "qualify", "race", "sex", "agecat", "income", "stwt")
svy_all <- svy_all[c(oia_vars, co_activities)]
glimpse(svy_all)

# Identify CO Target Pop --------------------------------------------------

# identify OIA respondents who would have passed the CO survey sreener
in_co_pop <- svy_all %>%
    select(Vrid, grp.nmtr.all_1:act.mtr.all_13) %>%
    gather(var, val, -Vrid) %>%
    filter(val == "Checked") %>%
    distinct(Vrid)

# add identifier variable "in_co_pop" for downstream filtering/summarizing
svy_all <- bind_rows(
    semi_join(svy_all, in_co_pop, by = "Vrid") %>% mutate(in_co_pop = TRUE),
    anti_join(svy_all, in_co_pop, by = "Vrid") %>% mutate(in_co_pop = FALSE)
)

# summarize
group_by(svy_all, in_co_pop) %>%
    summarise(n = n(), wtn = sum(stwt)) %>%
    mutate(pct = wtn / sum(wtn))

# Recode Demographics --------------------------------------------------------

# We need categories that correspond between OIA and CO surveys
# - age_weight, sex, income_weight, race_weight

svy_all$age_weight <- svy_all$agecat
count(svy_all, age_weight, agecat)

svy_all <- svy_all %>% recode_cat(
    oldvar = "income",
    newvar = "income_weight",
    newcat = c(rep(1, 3), 2, 3, 4, 5, 6, rep(7, 2)),
    newlab = c("0-25K", "25-35K", "35-50K", "50-75K", "75-100K", "100-150K", "150K+")
)

svy_all$race_weight <- svy_all$race
count(svy_all, race_weight, race)

# Save --------------------------------------------------------------------

svy_all <- select(svy_all, Vrid:stwt, in_co_pop:race_weight, grp.nmtr.all_1:act.mtr.all_13)
glimpse(svy_all)

saveRDS(svy_all, "data-work/oia/oia-co.rds")
write_csv(svy_all, "data-work/oia/oia-co.csv")
