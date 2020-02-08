5-recode-demographics.R
================
danka
Sat Feb 08 10:59:19 2020

``` r
# recode certain demographic variables for weighting
# b/c we need categories that match between CO and OIA surveys

library(tidyverse)
source("R/prep-svy.R")

outfile <- "data/interim/svy-demo.rds"
svy <- readRDS("data/interim/svy-clean.rds")

# age_weight
svy$person <- svy$person %>% recode_cat(
    oldvar = "age", 
    newvar = "age_weight",
    newcat = c(rep(1, 2), rep(2, 2), rep(3, 3)), 
    newlab = c("18-34", "35-54", "55+")
)
```

    ## # A tibble: 8 x 3
    ##   age_weight age             n
    ##   <fct>      <fct>       <int>
    ## 1 18-34      18 to 24      119
    ## 2 18-34      25 to 34      220
    ## 3 35-54      35 to 44      200
    ## 4 35-54      45 to 54      172
    ## 5 55+        55 to 64      239
    ## 6 55+        65 to 74      250
    ## 7 55+        75 or older    65
    ## 8 <NA>       <NA>           94

``` r
# income_weight
svy$person <- svy$person %>% recode_cat(
    oldvar = "income", 
    newvar = "income_weight",
    newcat = c(1:5, 6, 6, 7),
    newlab = c("0-25K", "25-35K", "35-50K", "50-75K", "75-100K", "100-150K", "150K+")
)
```

    ## # A tibble: 9 x 3
    ##   income_weight income                   n
    ##   <fct>         <fct>                <int>
    ## 1 0-25K         Less than $25,000      195
    ## 2 25-35K        $25,000 to $34,999     160
    ## 3 35-50K        $35,000 to $49,999     177
    ## 4 50-75K        $50,000 to $74,999     257
    ## 5 75-100K       $75,000 to $99,999     192
    ## 6 100-150K      $100,000 to $124,999   111
    ## 7 100-150K      $125,000 to $149,999    82
    ## 8 150K+         $150,000 or more        90
    ## 9 <NA>          <NA>                    95

``` r
# race_weight
# race & hispanic variables are combined into much broader categorization
race_labs <- c("White", "Hispanic", "Not white or Hispanic")
svy$person <- svy$person %>% 
    mutate(
        race_weight = case_when(
            is.na(race) | is.na(hispanic) ~ NA_character_, 
            hispanic == "Yes" ~ "Hispanic",
            race != "White" ~ "Not white or Hispanic", 
            TRUE ~ "White"
        ) %>%
            factor(levels = race_labs)
    ) 
count(svy$person, race_weight, race, hispanic)
```

    ## # A tibble: 13 x 4
    ##    race_weight          race                                hispanic     n
    ##    <fct>                <fct>                               <fct>    <int>
    ##  1 White                White                               No        1043
    ##  2 Hispanic             Asian                               Yes          1
    ##  3 Hispanic             Native Hawaiian or Other Pacific I~ Yes          1
    ##  4 Hispanic             Black/African-American              Yes          6
    ##  5 Hispanic             White                               Yes         73
    ##  6 Hispanic             American Indian/Alaska Native       Yes          5
    ##  7 Hispanic             Other                               Yes         35
    ##  8 Not white or Hispan~ Asian                               No          31
    ##  9 Not white or Hispan~ Native Hawaiian or Other Pacific I~ No           2
    ## 10 Not white or Hispan~ Black/African-American              No          43
    ## 11 Not white or Hispan~ American Indian/Alaska Native       No           9
    ## 12 Not white or Hispan~ Other                               No          15
    ## 13 <NA>                 <NA>                                <NA>        95

``` r
# save
saveRDS(svy, outfile)
```
