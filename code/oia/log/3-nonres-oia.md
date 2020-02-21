3-nonres-oia.R
================
danka
2020-02-21

``` r
# Get nonresident participation percentages in Colorado
# 1. estimate to-Colorado participation profiles from oia survey
# 2. estimate to-Coloardo participation rates by multiplying profiles
# 3. estimate % nonres participants from rates
# 4. estimate % res trips (as stand-in for days) from OIA results dataset

library(tidyverse)
```

    ## -- Attaching packages --------------------------------------- tidyverse 1.3.0 --

    ## v ggplot2 3.2.1     v purrr   0.3.3
    ## v tibble  2.1.3     v dplyr   0.8.4
    ## v tidyr   1.0.2     v stringr 1.4.0
    ## v readr   1.3.1     v forcats 0.4.0

    ## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
state_slct <- "Colorado"
statenum <- 6
outfile <- "data/interim/nonres-oia.rds"

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
```

    ## [1] "Vrid"                    "state"                   "stwt"                   
    ## [4] "trip.nmtr.all_2"         "trip.nmtr.all_4"         "slct.nmtr.all"          
    ## [7] "state.nmtr.all.dy.out_6" "state.nmtr.all.nt.out_6"

``` r
nmtr$all <- outstate_all(nmtr$svy)
nmtr$tgt <- outstate_tgt(nmtr$svy)

mtr <- list()
mtr$svy <- slct_vars(svy_wtd, statenum, "mtr")
```

    ## [1] "Vrid"                   "state"                  "stwt"                  
    ## [4] "trip.mtr.all_2"         "trip.mtr.all_4"         "slct.mtr.all"          
    ## [7] "state.mtr.all.dy.out_6" "state.mtr.all.nt.out_6"

``` r
mtr$all <- outstate_all(mtr$svy)
mtr$tgt <- outstate_tgt(mtr$svy)

# combine
out_rate <- bind_rows(nmtr$all, mtr$all)
```

    ## Warning in bind_rows_(x, .id): Unequal factor levels: coercing to character

    ## Warning in bind_rows_(x, .id): binding character and factor vector, coercing into
    ## character vector
    
    ## Warning in bind_rows_(x, .id): binding character and factor vector, coercing into
    ## character vector

``` r
tgt_rate <- bind_rows(nmtr$tgt, mtr$tgt)
```

    ## Warning in bind_rows_(x, .id): Unequal factor levels: coercing to character
    
    ## Warning in bind_rows_(x, .id): binding character and factor vector, coercing into
    ## character vector
    
    ## Warning in bind_rows_(x, .id): binding character and factor vector, coercing into
    ## character vector

``` r
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
pct_part_act1 <- pct_part_act2 %>%
    group_by(act, act1) %>%
    summarise(pct_nres = weighted.mean(pct_nres, part_all))

# Estimate Nres Trip % ----------------------------------------------------
# the necessary estimates were included in the OIA results

# total for day & overnight separately
pct_trip_act2 <- tot$trip %>%
    filter(state == state_slct) %>%
    group_by(act, act1, stay, dest) %>%
    summarise(trips = sum(trip_tot)) %>%
    ungroup() %>%
    spread(dest, trips) %>%
    mutate(all = `in` + out, pct_nres = out / all)

# get % nres, weighting day vs. overnight based on total number of trips
# - this is a bit hacky, but probably not terrible
# - it overweights day trips, but that is conservative for estimating % nres
pct_trip_act1 <- pct_trip_act2 %>% 
    group_by(act, act1) %>%
    summarise(pct_nres = weighted.mean(pct_nres, all))

# Save --------------------------------------------------------------------
# a list of 4 elements
# - % part/trip by act1
# - % part/trip by act2

mget(c("pct_part_act2", "pct_part_act1", "pct_trip_act2", "pct_trip_act1")) %>%
    saveRDS(outfile)

# Summarize ---------------------------------------------------------------

knitr::kable(pct_part_act1)
```

| act  | act1       | pct\_nres |
| :--- | :--------- | --------: |
| mtr  | boat       | 0.3495121 |
| mtr  | motorcycle | 0.4456349 |
| mtr  | off\_road  | 0.4351324 |
| mtr  | rv         | 0.6376482 |
| mtr  | snowmobile | 0.5403113 |
| nmtr | alpine     | 0.7572883 |
| nmtr | camp       | 0.4732169 |
| nmtr | hike       | 0.6493995 |
| nmtr | horse      | 0.5856775 |
| nmtr | mountain   | 0.6662378 |
| nmtr | nordic     | 0.7955662 |
| nmtr | paddle     | 0.5055134 |
| nmtr | run        | 0.6995863 |
| nmtr | sail       | 0.4625562 |
| nmtr | scuba      | 0.1054750 |
| nmtr | wheel      | 0.3848835 |

``` r
knitr::kable(pct_trip_act1)
```

| act  | act1       | pct\_nres |
| :--- | :--------- | --------: |
| mtr  | boat       | 0.3154783 |
| mtr  | motorcycle | 0.1096197 |
| mtr  | off\_road  | 0.2023028 |
| mtr  | rv         | 0.4611569 |
| mtr  | snowmobile | 0.5749151 |
| nmtr | alpine     | 0.4599618 |
| nmtr | camp       | 0.3063708 |
| nmtr | hike       | 0.2879584 |
| nmtr | horse      | 0.3054256 |
| nmtr | mountain   | 0.3778148 |
| nmtr | nordic     | 0.5994792 |
| nmtr | paddle     | 0.4020676 |
| nmtr | run        | 0.4838764 |
| nmtr | sail       | 0.7143388 |
| nmtr | scuba      | 0.1341959 |
| nmtr | wheel      | 0.1018457 |
