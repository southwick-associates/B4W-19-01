# pull together spending profiles

library(tidyverse)
library(readxl)
library(workflow) # xlsx_write_table()

source("R/results.R")
outfile <- "out/profiles.xlsx"

# Load Data --------------------------------------------------

# year adjust
pop <- read_excel(outfile, sheet = "pop")
cpi <- read_excel(outfile, sheet = "cpi")

# CO svy profiles
co_prof <- read_excel("data/raw/Participation Profiles - B4W coh2o.xlsx", 
           sheet = "StateWide Worksheet", skip = 1, n_max = 9) %>%
    select(act = ...1, svyRate:tgtRate) %>%
    mutate(act = str_replace(act, "picni", "picnic") %>% str_replace("wildl", "wildlife"))
co_prof

# spend profiles
spend_picnic <- readRDS("data/raw/spend_picnic-az.rds")$avg
spend_oia <- readRDS("data/interim/oia-spend2016.rds")
spend_usfws <- readRDS("data/interim/usfws-spend2016.rds")

# oia nonres
oia_nonres <- readRDS("data/interim/oia-nonres.rds")

# tgtRate -----------------------------------------------------------------
# percent of whole CO resident population in the CO svy target audience

svy_oia <- readRDS("data/interim/oia-co.rds")
count(svy_oia, in_co_pop)

# This rate is higher than the "All activities" reported in OIA (71.2%)
#  because those OIA numbers don't count team & individual sports (included here)
svy_oia %>%
    group_by(in_co_pop) %>%
    summarise(n = n(), wtn = sum(stwt)) %>%
    mutate(pct = wtn / sum(wtn)) %>%
    knitr::kable()

# AZ avgSpend2018 ---------------------------------------------------------
# for picnicking

avgSpendPicnic <- spend_picnic %>%
    mutate(
        act = "picnic", type = "trip",
        cpiAdjust = get_year_adjust(cpi, 2018, 2019)
    ) %>%
    left_join(co_prof, by = "act") %>%
    select(act, type, item, avgSpend2018 = avgSpend, Pop, tgtRate, svyRate, 
           waterRate, avgDays, waterShare, cpiAdjust)
xlsx_write_table(avgSpendPicnic, outfile)

# Spend2016 ---------------------------------------------------------------
# from OIA & USFWS

# by activity-item
spend <- bind_rows(spend_oia, spend_usfws) %>%
    mutate(
        cpiAdjust = get_year_adjust(cpi, 2016, 2019),
        popAdjust = get_year_adjust(pop, 2016, 2019)
    ) %>%
    left_join(co_prof, by = "act") %>%
    select(act, type, item, spend2016 = spend, waterRate, waterShare, cpiAdjust, popAdjust)
xlsx_write_table(spend, outfile)

# by activity
spendAll <- spend %>%
    group_by(act) %>%
    mutate(spend2016 = sum(spend2016)) %>%
    summarise_all("first") %>%
    select(-type, -item)
xlsx_write_table(spendAll, outfile)

# nresPct ----------------------------------------------------------------
# percent of CO recreation done by nonresidents (participants, trips)
# - comes directly from OIA

nresPct <- left_join(
    rename(oia_nonres$pct_part_act, part_pct_nres = pct_nres),
    rename(oia_nonres$pct_trip_act, trip_pct_nres = pct_nres)
) %>%
    rename(act = co_activity)
xlsx_write_table(nresPct, outfile)
