3-profile.R
================
danka
2020-02-21

``` r
# pull together spending profiles

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
```

    ## New names:
    ## * `` -> ...1
    ## * `` -> ...2
    ## * `` -> ...11
    ## * `` -> ...12

``` r
co_prof
```

    ## # A tibble: 9 x 7
    ##   act      svyRate avgDays waterRate waterShare     Pop tgtRate
    ##   <chr>      <dbl>   <dbl>     <dbl>      <dbl>   <dbl>   <dbl>
    ## 1 bike       0.304   30.4      0.530      0.326 4499217   0.771
    ## 2 camp       0.375    8.29     0.747      0.671 4499217   0.771
    ## 3 fish       0.258    8.95     0.985      1     4499217   0.771
    ## 4 hunt       0.138    7.70     0.420      0.637 4499217   0.771
    ## 5 picnic     0.695   13.6      0.745      0.539 4499217   0.771
    ## 6 snow       0.247    9.03     0.305      0.486 4499217   0.771
    ## 7 trail      0.361   24.6      0.746      0.433 4499217   0.771
    ## 8 water      0.301   10.2      0.886      1     4499217   0.771
    ## 9 wildlife   0.386   20.7      0.787      0.555 4499217   0.771

``` r
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
```

    ## # A tibble: 2 x 2
    ##   in_co_pop     n
    ##   <lgl>     <int>
    ## 1 FALSE       280
    ## 2 TRUE        877

``` r
# This rate is higher than the "All activities" reported in OIA (71.2%)
#  because those OIA numbers don't count team & individual sports (included here)
svy_oia %>%
    group_by(in_co_pop) %>%
    summarise(n = n(), wtn = sum(stwt)) %>%
    mutate(pct = wtn / sum(wtn)) %>%
    knitr::kable()
```

| in\_co\_pop |   n |      wtn |       pct |
| :---------- | --: | -------: | --------: |
| FALSE       | 280 | 264.8946 | 0.2289495 |
| TRUE        | 877 | 892.1054 | 0.7710505 |

``` r
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
```

    ## Joining, by = "co_activity"

``` r
xlsx_write_table(nresPct, outfile)
```
