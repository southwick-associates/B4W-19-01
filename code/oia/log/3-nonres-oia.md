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
```

| act  | act1       | act2            |     part\_res | part\_nres |    part\_all | pct\_nres |
| :--- | :--------- | :-------------- | ------------: | ---------: | -----------: | --------: |
| nmtr | run        | run             |   307,657.453 |    716,455 | 1,024,112.45 | 0.6995863 |
| nmtr | hike       | hike            |   817,499.564 |  1,514,213 | 2,331,712.56 | 0.6493995 |
| nmtr | mountain   | backpack        |   348,562.098 |    554,437 |   902,999.10 | 0.6139951 |
| nmtr | mountain   | climb           |   112,495.722 |    244,928 |   357,423.72 | 0.6852595 |
| nmtr | horse      | horse           |   149,550.885 |    211,402 |   360,952.88 | 0.5856775 |
| nmtr | mountain   | mountaineering  |    48,129.582 |    217,047 |   265,176.58 | 0.8184999 |
| nmtr | wheel      | bike\_road      |   364,439.797 |    161,109 |   525,548.80 | 0.3065538 |
| nmtr | wheel      | bike\_mtn       |   209,182.884 |    144,696 |   353,878.88 | 0.4088857 |
| nmtr | wheel      | skateboard      |    49,212.293 |     83,908 |   133,120.29 | 0.6303171 |
| nmtr | camp       | camp            | 1,292,685.323 |  1,161,238 | 2,453,923.32 | 0.4732169 |
| nmtr | nordic     | cross\_country  |    20,402.180 |    227,996 |   248,398.18 | 0.9178650 |
| nmtr | alpine     | ski\_downhill   |   399,216.217 |  1,357,394 | 1,756,610.22 | 0.7727349 |
| nmtr | alpine     | ski\_telemark   |    15,552.749 |      2,835 |    18,387.75 | 0.1541787 |
| nmtr | alpine     | snowboard       |   313,250.261 |    911,274 | 1,224,524.26 | 0.7441862 |
| nmtr | nordic     | snowshoe        |    81,023.739 |    166,709 |   247,732.74 | 0.6729389 |
| nmtr | paddle     | kayak           |   168,110.920 |    167,953 |   336,063.92 | 0.4997650 |
| nmtr | paddle     | raft            |   164,963.559 |    235,651 |   400,614.56 | 0.5882238 |
| nmtr | paddle     | canoe           |    84,838.065 |    115,654 |   200,492.06 | 0.5768508 |
| nmtr | paddle     | surf            |    35,379.735 |      2,799 |    38,178.74 | 0.0733131 |
| nmtr | scuba      | scuba           |    71,231.222 |      8,399 |    79,630.22 | 0.1054750 |
| nmtr | sail       | sail            |    29,679.554 |     25,544 |    55,223.55 | 0.4625562 |
| nmtr | paddle     | paddle\_board   |    90,554.180 |     33,917 |   124,471.18 | 0.2724888 |
| mtr  | motorcycle | motorcycle\_on  |   275,283.999 |    268,936 |   544,220.00 | 0.4941678 |
| mtr  | motorcycle | motorcycle\_off |   105,521.051 |     37,180 |   142,701.05 | 0.2605447 |
| mtr  | off\_road  | atv             |   203,945.456 |    181,653 |   385,598.46 | 0.4710937 |
| mtr  | off\_road  | rov             |    27,826.335 |     30,378 |    58,204.33 | 0.5219199 |
| mtr  | off\_road  | buggy           |    37,637.766 |     27,295 |    64,932.77 | 0.4203579 |
| mtr  | off\_road  | truck           |   298,229.077 |    197,941 |   496,170.08 | 0.3989378 |
| mtr  | boat       | waterski        |    54,665.904 |     14,980 |    69,645.90 | 0.2150880 |
| mtr  | boat       | wakeboard       |    36,072.689 |     20,789 |    56,861.69 | 0.3656064 |
| mtr  | boat       | kneeboard       |     5,678.749 |     15,178 |    20,856.75 | 0.7277261 |
| mtr  | boat       | tube            |   142,621.156 |     38,474 |   181,095.16 | 0.2124518 |
| mtr  | boat       | power\_boat     |   159,623.288 |    124,783 |   284,406.29 | 0.4387491 |
| mtr  | snowmobile | snowmobile      |   118,728.714 |    139,552 |   258,280.71 | 0.5403113 |
| mtr  | rv         | rv              |   250,980.644 |    441,663 |   692,643.64 | 0.6376482 |

``` r
knitr::kable(pct_part_act)
```

| co\_activity | pct\_nres |
| :----------- | --------: |
| bike         | 0.3848835 |
| camp         | 0.5094126 |
| snow         | 0.7627210 |
| trail        | 0.6597163 |
| water        | 0.4352387 |

``` r
knitr::kable(pct_trip_act)
```

| co\_activity | pct\_nres |
| :----------- | --------: |
| bike         | 0.1018457 |
| camp         | 0.3318146 |
| snow         | 0.4777663 |
| trail        | 0.3378155 |
| water        | 0.3725105 |
