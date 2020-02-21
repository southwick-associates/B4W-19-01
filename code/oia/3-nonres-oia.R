# Get nonresident participation percentages in Colorado
# 1. estimate to-Colorado participation profiles from oia survey
# 2. estimate to-Coloardo participation rates by multiplying profiles
# 3. estimate % nonres participants from rates
# 4. estimate % res trips (as stand-in for days) from OIA results dataset

library(tidyverse)
library(readxl)

state_slct <- "Colorado"
statenum <- 6
outfile <- "data/interim/oia-nonres.rds"

# Load Data ---------------------------------------------------------------

# OIA survey data
load("data/raw/oia/svy-wtd.RDATA") # svy_wtd

# OIA results
load("data/raw/oia/results.RDATA") # out, stat, tot

# - total population in 2016
pop <- select(tot$pop, state, pop)

# - participation rate (by state of residence) in 2016
meta <- select(out$act_meta, act:act2, choice)
rate <- select(out$part, act, act2, state, rate_mon, rate) %>% 
    left_join(meta, by = c("act", "act2"))
rm(out, stat, meta)

# - oia to co svy, for aggregating to the necessary activity level
acts <- read_excel("data/raw/oia/oia-activities.xlsx", sheet = "co-oia-acts") %>%
    filter(!is.na(co_activity))

# Profile -----------------------------------------------------------------
# 1. all: What % of activity participants (by state of residence) went to another state?
# 2. tgt: What % of respondents (by state of residency) who went to target state

svy_wtd <- as_tibble(svy_wtd)

# for pulling selected survey variables that we need
slct_vars <- function(svy_wtd, statenum, type = "nmtr") {
    slct <- c(
        "Vrid", "state", "stwt", paste0("trip.", type, ".all_2"), 
        paste0("trip.", type, ".all_4"), paste0("slct.", type, ".all"), 
        paste0("state.", type, ".all.dy.out_", statenum), 
        paste0("state.", type, ".all.nt.out_", statenum)
    )
    print(slct)
    x <- svy_wtd[slct]
    names(x) <- c(slct[1:3], "dy_trip", "nt_trip", "act", "dy_tgt", "nt_tgt")
    filter(x, !is.na(act), !is.na(dy_trip), !is.na(nt_trip))
}

# for getting what percent (by state res) visited another state
outstate_all <- function(df) {
    df %>%
        mutate(out = ifelse(dy_trip > 0 | nt_trip > 0, 1, 0)) %>%
        group_by(state, act) %>%
        summarise(out_rate = weighted.mean(out, stwt), n = n()) %>%
        ungroup()
}

# for getting what percent of all out-of-state participants went to target state
outstate_tgt <- function(df) {
    df %>%
        filter(!is.na(dy_tgt) | !is.na(nt_tgt)) %>%
        mutate(
            dy_tgt = as.character(dy_tgt), nt_tgt = as.character(nt_tgt),
            dy_tgt = ifelse(is.na(dy_tgt), "Unchecked", dy_tgt),
            nt_tgt = ifelse(is.na(nt_tgt), "Unchecked", nt_tgt),
            tgt = ifelse(dy_tgt == "Checked" | nt_tgt == "Checked", 1, 0)
        ) %>%
        group_by(state, act) %>%
        summarise(tgt_rate = weighted.mean(tgt, stwt), n = n()) %>%
        ungroup()
}

nmtr <- list()
nmtr$svy <- slct_vars(svy_wtd, statenum, "nmtr")
nmtr$all <- outstate_all(nmtr$svy)
nmtr$tgt <- outstate_tgt(nmtr$svy)

mtr <- list()
mtr$svy <- slct_vars(svy_wtd, statenum, "mtr")
mtr$all <- outstate_all(mtr$svy)
mtr$tgt <- outstate_tgt(mtr$svy)

# combine
out_rate <- bind_rows(nmtr$all, mtr$all)
tgt_rate <- bind_rows(nmtr$tgt, mtr$tgt)
rm(nmtr, mtr, svy_wtd)

# Estimate Part Rates --------------------------------------------------------

# what % of participants from each state visited target state (i.e., nonres participants)
# - part_tgt(A,S) = pop(S) * rate(A,S) * out_rate(A,S) * tgt_rate(A,S)
#   + pop(S) = population of state
#   + rate(A,S) = resident participation rate by state-activity
#   + out_rate(A,S) = profile 1 above
#   + tgt_rate(A,S) = profile 2 above

# join tables
est <- select(out_rate, -n) %>%
    left_join(tgt_rate, by = c("state", "act")) %>%
    left_join(pop, by = "state") %>%
    rename(choice = "act") %>%
    left_join(rate, by = c("state", "choice")) %>%
    select(state, act, act1, act2, pop, rate = rate_mon, out_rate, tgt_rate, n)

# set zeroes for tgt_rate where n == 0, and estimate nonres participants
est <- est %>%
    mutate(
        tgt_rate = ifelse(is.na(tgt_rate), 0, tgt_rate),
        n = ifelse(is.na(n), 0, n),
        part = pop * rate * out_rate * tgt_rate,
        IR = part / pop
    )

# Estimate Nres Part % -------------------------------------------------------

nres <- filter(est, state != state_slct) %>%
    group_by(act, act1, act2) %>%
    summarise(part_nres = round(sum(part), 0))

res <- filter(est, state == state_slct) %>%
    mutate(part_res = pop * rate) %>%
    select(act, act1, act2, part_res)

pct_part_act2 <- left_join(res, nres, by = c("act", "act1", "act2")) %>%
    mutate(
        part_all = part_nres + part_res,
        pct_nres = part_nres / part_all
    )

# to get by activity groups, need to weight by act2
# - participants by act2 seems like our best weighting variable
pct_part_act <- pct_part_act2 %>%
    right_join(acts, by = c("act", "act1")) %>%
    group_by(co_activity) %>%
    summarise(pct_nres = weighted.mean(pct_nres, part_all))

# Estimate Nres Trip % ----------------------------------------------------
# the necessary estimates were included in the OIA results

# total for day & overnight separately
x <- tot$trip %>%
    filter(state == state_slct) %>%
    right_join(acts, by = c("act", "act1")) %>%
    group_by(co_activity, stay, dest) %>%
    summarise(trips = sum(trip_tot)) %>%
    ungroup() %>%
    spread(dest, trips) %>%
    mutate(all = `in` + out, pct_nres = out / all)

# get % nres, weighting day vs. overnight based on total number of trips
# - this is a bit hacky, but probably not terrible
# - it overweights day trips, but that is conservative for estimating % nres
pct_trip_act <- x %>% 
    group_by(co_activity) %>%
    summarise(pct_nres = weighted.mean(pct_nres, all))

# Save --------------------------------------------------------------------

mget(c("pct_part_act2", "pct_part_act", "pct_trip_act")) %>%
    saveRDS(outfile)

# Summarize ---------------------------------------------------------------

knitr::kable(pct_part_act2, format.args = list(big.mark = ","))
knitr::kable(pct_part_act)
knitr::kable(pct_trip_act)
