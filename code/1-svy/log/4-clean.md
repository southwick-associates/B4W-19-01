4-clean.R
================
danka
Thu Feb 06 12:14:32 2020

``` r
# clean survey data

# 0. Drop those who checked "none" for activities
# 1. Set fishing/water activities participation along water
# 2. Set days to missing where days_water > days
# 2a. Set basin days to missing that are flagged "high" or "low"
# 3. Recode those who entered "none" for basins
#    act$part_water = "No", act$days_water = NA
# 4. Add act$is_targeted to identify 9 activities of interest for the study
# 5. Set obvious days outliers to missing (i.e, those > 365)

library(tidyverse)
```

    ## -- Attaching packages --------------------------------------- tidyverse 1.2.1 --

    ## v ggplot2 3.0.0     v purrr   0.2.5
    ## v tibble  1.4.2     v dplyr   0.7.6
    ## v tidyr   0.8.1     v stringr 1.3.1
    ## v readr   1.1.1     v forcats 0.3.0

    ## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
source("R/prep-svy.R") # functions
svy <- readRDS("data-work/1-svy/svy-reshape.rds")

# 0. Filter out respondents with "none" -----------------------------------

# IPSOS pre-screened with this same question so no respondents should
#  be indicating none
drop_vrids <- filter(svy$act, act == "none", part == "Checked") %>% distinct(Vrid)
svy$person <- anti_join(svy$person, drop_vrids, by = "Vrid")
svy$act <- anti_join(svy$act, drop_vrids, by = "Vrid") %>%
    filter(act != "none")

# 1. Fishing & Water ---------------------------------------------------------

# For the fishing/water activities, we assumed that all their activity
#  is along the water, so the water-specific questions weren't asked.
# Recoding water-specific here to "Checked", "Yes", etc. to make that explicit

# recode
svy$act <- svy$act %>% mutate(
    part_water = case_when(
        act %in% c("water", "fish") & part == "Checked" ~ "Yes", 
        act %in% c("water", "fish") & part == "Unchecked" ~ "No", 
        TRUE ~ part_water
    ),
    days_water = case_when(
        act %in% c("water", "fish") ~ days, TRUE ~ days_water
    )
)

# check recoding
x <- svy$act %>% filter(act %in% c("water", "fish"), part == "Checked")
count(x, part, part_water)
```

    ## # A tibble: 1 x 3
    ##   part    part_water     n
    ##   <chr>   <chr>      <int>
    ## 1 Checked Yes          757

``` r
all.equal(x$days, x$days_water)
```

    ## [1] TRUE

``` r
# 2. Days Recoding -------------------------------------------------------------

# Some respondents entered larger values for days_water than days
# All days values for these respondents (for given activity) are set to missing
#  since the days entered by these people are unreliable
high_water_days <- filter(svy$act, part_water == "Yes", days < days_water)
high_water_days
```

    ## # A tibble: 72 x 6
    ##    Vrid  act   part    part_water  days days_water
    ##    <chr> <chr> <chr>   <chr>      <dbl>      <dbl>
    ##  1 127   trail Checked Yes            5         10
    ##  2 299   trail Checked Yes            8         15
    ##  3 306   trail Checked Yes            2          4
    ##  4 508   trail Checked Yes            5         10
    ##  5 549   trail Checked Yes            5         30
    ##  6 856   trail Checked Yes           15         26
    ##  7 928   trail Checked Yes            2          3
    ##  8 1136  trail Checked Yes            7         12
    ##  9 1188  trail Checked Yes            5         15
    ## 10 1302  trail Checked Yes            3         50
    ## # ... with 62 more rows

``` r
svy$act <- bind_rows(
    anti_join(svy$act, high_water_days, by = c("Vrid", "act")),
    semi_join(svy$act, high_water_days, by = c("Vrid", "act")) %>%
        mutate(days = NA, days_water = NA)
)

svy$basin <- bind_rows(
    anti_join(svy$basin, high_water_days, by = c("Vrid", "act")),
    semi_join(svy$basin, high_water_days, by = c("Vrid", "act")) %>%
        mutate(days_water = NA)
)
```

    ## Warning: Column `Vrid` has different attributes on LHS and RHS of join
    
    ## Warning: Column `Vrid` has different attributes on LHS and RHS of join

``` r
# 2a. Basin Days Recoding -------------------------------------------------

# Basin days can be highly inconsistent with water days
# All basin days where this occurs are set to missing (unreliable)

# - get relevant sums
days_act <- svy$act %>%
    filter(!is.na(days_water), days_water != 0)
days_basin <- svy$basin %>% 
    group_by(Vrid, act) %>% 
    summarise(days_water = sum(days_water, na.rm = TRUE)) %>%
    ungroup() 

# - get difference (basin - days_water)
basin_diff <- days_act %>%
    inner_join(days_basin, by = c("Vrid", "act"), suffix = c(".all", ".basin")) %>%
    mutate(
        diff = days_water.basin - days_water.all, 
        ratio = days_water.basin / days_water.all
) 

# - identify inconsistencies
flagged <- bind_rows(
    filter(basin_diff, days_water.basin >= 5, ratio >= 2) %>% mutate(flag = "high"),
    filter(basin_diff, days_water.all >= 5, ratio <= 0.5) %>% mutate(flag = "low")
)
count(flagged, flag)
```

    ## # A tibble: 2 x 2
    ##   flag      n
    ##   <chr> <int>
    ## 1 high     38
    ## 2 low     368

``` r
# - set flagged to missing
svy$basin <- bind_rows(
    anti_join(svy$basin, flagged, by = c("Vrid", "act")),
    semi_join(svy$basin, flagged, by = c("Vrid", "act")) %>%
        mutate(days_water = NA)
)

# 3. Recode "none" in basins ----------------------------------------------

# The basins completey cover NE, so those who enter "none" shouldn't be
#  counted as along-the-water participants
no_basin <- filter(svy$basin, basin == "none", part == "Checked")
no_basin
```

    ## # A tibble: 96 x 5
    ##    Vrid  act   basin part    days_water
    ##    <chr> <chr> <chr> <chr>        <dbl>
    ##  1 223   bike  none  Checked         NA
    ##  2 736   bike  none  Checked         NA
    ##  3 329   camp  none  Checked         NA
    ##  4 371   camp  none  Checked         NA
    ##  5 500   camp  none  Checked         NA
    ##  6 588   camp  none  Checked         NA
    ##  7 730   camp  none  Checked         NA
    ##  8 987   camp  none  Checked         NA
    ##  9 1099  camp  none  Checked         NA
    ## 10 1462  camp  none  Checked         NA
    ## # ... with 86 more rows

``` r
svy$act <- bind_rows(
    anti_join(svy$act, no_basin, by = c("Vrid", "act")),
    semi_join(svy$act, no_basin, by = c("Vrid", "act")) %>%
        mutate(part_water = "No", days_water = NA)
)

# no longer need the "none" identifier
svy$basin <- filter(svy$basin, basin != "none")

# 4. Add is_targeted variable --------------------------------------------

# for the svy$act table, to identify activities of interest for the study
svy$act <- svy$act %>% mutate(
    is_targeted = case_when(
        act %in% unique(svy$basin$act) ~ TRUE, TRUE ~ FALSE
    )
)
count(svy$act, is_targeted, act)
```

    ## # A tibble: 14 x 3
    ##    is_targeted act            n
    ##    <lgl>       <chr>      <int>
    ##  1 FALSE       motorcycle  1359
    ##  2 FALSE       offroad     1359
    ##  3 FALSE       playground  1359
    ##  4 FALSE       sport       1359
    ##  5 FALSE       team        1359
    ##  6 TRUE        bike        1359
    ##  7 TRUE        camp        1359
    ##  8 TRUE        fish        1359
    ##  9 TRUE        hunt        1359
    ## 10 TRUE        picnic      1359
    ## 11 TRUE        snow        1359
    ## 12 TRUE        trail       1359
    ## 13 TRUE        water       1359
    ## 14 TRUE        wildlife    1359

``` r
# 5. Days Outliers --------------------------------------------------------

# some obvious outliers for days will be set to missing
filter(svy$act, days > 365 | days_water > 365)
```

    ## # A tibble: 6 x 7
    ##   Vrid  act      part    part_water  days days_water is_targeted
    ##   <chr> <chr>    <chr>   <chr>      <dbl>      <dbl> <lgl>      
    ## 1 1297  trail    Checked Yes          580        365 TRUE       
    ## 2 1353  trail    Checked Yes         1000        150 TRUE       
    ## 3 1297  bike     Checked No           580         NA TRUE       
    ## 4 900   picnic   Checked Yes          400         50 TRUE       
    ## 5 1027  picnic   Checked Yes         2019          2 TRUE       
    ## 6 1030  wildlife Checked No          2000         NA TRUE

``` r
filter(svy$basin, days_water > 365)
```

    ## # A tibble: 0 x 5
    ## # ... with 5 variables: Vrid <chr>, act <chr>, basin <chr>, part <chr>,
    ## #   days_water <dbl>

``` r
set_missing <- function(x) ifelse(!is.na(x) & x > 365, NA, x)

svy$basin <- mutate(svy$basin, days_water = set_missing(days_water))
svy$act <- mutate_at(svy$act, vars(days, days_water), "set_missing")

# Misc -----------------------------------------------------------------

# what does Vstatus == Disqualified mean?
# - didn't indicate participating in the activities of particular interest
# - no changes needed here
disqualified <- filter(svy$person, Vstatus == "Disqualified")
svy$act %>%
    semi_join(disqualified) %>%
    filter(part == "Checked")
```

    ## Joining, by = "Vrid"

    ## Warning: Column `Vrid` has different attributes on LHS and RHS of join

    ## # A tibble: 16 x 7
    ##    Vrid  act        part    part_water  days days_water is_targeted
    ##    <chr> <chr>      <chr>   <chr>      <dbl>      <dbl> <lgl>      
    ##  1 120   team       Checked <NA>          NA         NA FALSE      
    ##  2 222   team       Checked <NA>          NA         NA FALSE      
    ##  3 774   team       Checked <NA>          NA         NA FALSE      
    ##  4 325   offroad    Checked <NA>          NA         NA FALSE      
    ##  5 1428  offroad    Checked <NA>          NA         NA FALSE      
    ##  6 120   sport      Checked <NA>          NA         NA FALSE      
    ##  7 222   sport      Checked <NA>          NA         NA FALSE      
    ##  8 774   sport      Checked <NA>          NA         NA FALSE      
    ##  9 1341  sport      Checked <NA>          NA         NA FALSE      
    ## 10 1424  sport      Checked <NA>          NA         NA FALSE      
    ## 11 1428  motorcycle Checked <NA>          NA         NA FALSE      
    ## 12 385   playground Checked <NA>          NA         NA FALSE      
    ## 13 460   playground Checked <NA>          NA         NA FALSE      
    ## 14 840   playground Checked <NA>          NA         NA FALSE      
    ## 15 1341  playground Checked <NA>          NA         NA FALSE      
    ## 16 1424  playground Checked <NA>          NA         NA FALSE

``` r
# Save --------------------------------------------------------------------

svy$act <- select(svy$act, Vrid, act, is_targeted, part, days,
                  part_water, days_water)
svy$basin <- rename(svy$basin, part_water = part)

glimpse(svy$person)
```

    ## Observations: 1,359
    ## Variables: 9
    ## $ Vrid       <chr> "98", "99", "100", "101", "102", "103", "104", "105...
    ## $ id         <chr> "C2058317730", "C2058321874", "C2058323362", "C2058...
    ## $ Vstatus    <chr> "Complete", "Complete", "Partial", "Complete", "Com...
    ## $ age        <fct> 45 to 54, 45 to 54, NA, 35 to 44, 35 to 44, 18 to 2...
    ## $ sex        <fct> Female, Female, NA, Male, Female, Male, Female, Mal...
    ## $ income     <fct> Less than $25,000, Less than $25,000, NA, $25,000 t...
    ## $ race       <fct> White, Other, NA, White, Black/African-American, Wh...
    ## $ race_other <chr> "", "unecessary question", "", "", "", "", "", "", ...
    ## $ hispanic   <fct> No, No, NA, No, No, No, No, No, No, Yes, Yes, No, Y...

``` r
glimpse(svy$act)
```

    ## Observations: 19,026
    ## Variables: 7
    ## $ Vrid        <chr> "98", "99", "100", "101", "102", "103", "104", "10...
    ## $ act         <chr> "trail", "trail", "trail", "trail", "trail", "trai...
    ## $ is_targeted <lgl> TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TR...
    ## $ part        <chr> "Unchecked", "Unchecked", "Unchecked", "Unchecked"...
    ## $ days        <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 15, 10, NA, 2,...
    ## $ part_water  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, "Yes", "Yes", ...
    ## $ days_water  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 10, 5, NA, 1, ...

``` r
glimpse(svy$basin)
```

    ## Observations: 24,174
    ## Variables: 5
    ## $ Vrid       <chr> "107", "108", "110", "113", "119", "129", "131", "1...
    ## $ act        <chr> "trail", "trail", "trail", "trail", "trail", "trail...
    ## $ basin      <chr> "arkansas", "arkansas", "arkansas", "arkansas", "ar...
    ## $ part_water <chr> "Checked", "Unchecked", "Unchecked", "Checked", "Un...
    ## $ days_water <dbl> 5, NA, NA, 8, NA, 1, NA, 12, NA, NA, 2, NA, NA, 2, ...

``` r
saveRDS(svy, "data-work/1-svy/svy-clean.rds")
```
