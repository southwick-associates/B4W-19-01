1-prep-oia.R
================
danka
Wed Feb 05 17:15:30 2020

``` r
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
```

| var     | act        | lab1                                                                                                                                    |
| :------ | :--------- | :-------------------------------------------------------------------------------------------------------------------------------------- |
| var2O1  | trail      | Trail Sports (running 3+ miles on paved/unpaved trail, day-hiking, backpacking, climbing ice or rock, mountaineering, horseback riding) |
| var2O2  | bike       | Bicycling or skateboarding (on paved road or off-road)                                                                                  |
| var2O3  | camp       | Camping (RV at campsite, tent campsite, or at a rustic lodge)                                                                           |
| var2O4  | picnic     | Picnicking or relaxing                                                                                                                  |
| var2O5  | water      | Water sports (swimming, canoeing, kayaking, rafting, paddle-boarding, sailing, recreating with motorized boat)                          |
| var2O6  | snow       | Snow sports (skiing cross-country/downhill/telemark, snowboarding, snowshoeing)                                                         |
| var2O7  | hunt       | Hunting & shooting (shotgun, rifle, or bow)                                                                                             |
| var2O8  | fish       | Fishing (recreational fly and non-fly)                                                                                                  |
| var2O9  | wildlife   | Wildlife-watching (viewing, feeding, or photographing animals, bird watching)                                                           |
| var2O10 | team       | Team competitive sports (softball/baseball, volleyball, soccer, ultimate frisbee)                                                       |
| var2O11 | offroad    | Off-roading with ATVs, 4x4 trucks                                                                                                       |
| var2O12 | sport      | Individual competitive sports (golf, tennis)                                                                                            |
| var2O13 | motorcycle | Motorcycling (on-road, off-road)                                                                                                        |
| var2O14 | playground | Playground activities                                                                                                                   |

``` r
# using an approximate correspondence with the OIA survey activity questions
oia_activities <- read_excel("data/oia/oia-activities.xlsx", sheet = "oia-screener")
knitr::kable(oia_activities)
```

| option                                                                                                | variable         | question | in\_co\_screener |
| :---------------------------------------------------------------------------------------------------- | :--------------- | -------: | ---------------: |
| Trail sports (trail running, hiking/backpacking, horseback riding, etc )                              | grp.nmtr.all\_1  |        4 |                1 |
| Climbing sports (indoor/outdoor rock climbing, ice climbing, mountaineering, etc )                    | grp.nmtr.all\_2  |        4 |                1 |
| Wheel sports (bicycling, skateboarding                                                                | grp.nmtr.all\_3  |        4 |                1 |
| Camping (in a tent or rustic lodge)                                                                   | grp.nmtr.all\_4  |        4 |                1 |
| Snow sports (skiing, snowboarding, snowshoeing, etc )                                                 | grp.nmtr.all\_5  |        4 |                1 |
| Water sports (canoeing/kayaking, sailing, surfing, SCUBA diving, rafting, stand up paddleboard, etc ) | grp.nmtr.all\_6  |        4 |                1 |
| Recreational team sports (softball, football, basketball, soccer, etc )                               | grp.nmtr.all\_7  |        4 |                1 |
| Individual sports (golf, tennis, squash, racquetball, etc )                                           | grp.nmtr.all\_8  |        4 |                1 |
| High adventure / extreme sports (skydiving, paragliding, windsurfing, bungee jumping, etc )           | grp.nmtr.all\_9  |        4 |               NA |
| Road running (generally 3 miles or more at a time)                                                    | grp.nmtr.all\_10 |        4 |                1 |
| Fishing                                                                                               | grp.nmtr.all\_11 |        4 |                1 |
| Hunting                                                                                               | grp.nmtr.all\_12 |        4 |                1 |
| Wildlife Viewing                                                                                      | grp.nmtr.all\_13 |        4 |                1 |
| Riding motorcycles on the high                                                                        | act.mtr.all\_1   |       11 |                1 |
| Riding motorcycles off-road                                                                           | act.mtr.all\_2   |       11 |                1 |
| Riding ATVs (3 or 4-wheeled al                                                                        | act.mtr.all\_3   |       11 |                1 |
| Riding ROVs (motorized off-roa                                                                        | act.mtr.all\_4   |       11 |                1 |
| Riding dune buggies, swamp bug                                                                        | act.mtr.all\_5   |       11 |               NA |
| Driving trucks, jeeps and othe                                                                        | act.mtr.all\_6   |       11 |                1 |
| Waterskiing                                                                                           | act.mtr.all\_7   |       11 |                1 |
| Wakeboarding                                                                                          | act.mtr.all\_8   |       11 |                1 |
| Kneeboarding                                                                                          | act.mtr.all\_9   |       11 |                1 |
| Tubing                                                                                                | act.mtr.all\_10  |       11 |                1 |
| Cruising / sightseeing in a po                                                                        | act.mtr.all\_11  |       11 |                1 |
| Snowmobiling                                                                                          | act.mtr.all\_12  |       11 |               NA |
| RVâ€™ing (any trips you have t                                                                        | act.mtr.all\_13  |       11 |                1 |

``` r
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
```

    ## Observations: 1,157
    ## Variables: 31
    ## $ Vrid            <dbl> 189, 5851, 7919, 8878, 10726, 667, 8439, 1751,...
    ## $ Vstatus         <fct> Complete, Complete, Complete, Complete, Comple...
    ## $ qualify         <dbl> 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0...
    ## $ race            <fct> White, White, Hispanic, White, Not white or Hi...
    ## $ sex             <fct> Female, Female, Female, Male, Female, Female, ...
    ## $ agecat          <fct> 18-34, 18-34, 18-34, 18-34, 35-54, 18-34, 35-5...
    ## $ income          <fct> $75,000 - $99,999, $35,000 - $49,999, Under $1...
    ## $ stwt            <dbl> 0.8927761, 0.8927761, 1.1913576, 1.1056643, 0....
    ## $ grp.nmtr.all_1  <fct> Checked, Checked, Unchecked, Checked, Unchecke...
    ## $ grp.nmtr.all_2  <fct> Checked, Unchecked, Checked, Unchecked, Unchec...
    ## $ grp.nmtr.all_3  <fct> Unchecked, Unchecked, Unchecked, Checked, Unch...
    ## $ grp.nmtr.all_4  <fct> Checked, Checked, Unchecked, Checked, Unchecke...
    ## $ grp.nmtr.all_5  <fct> Checked, Unchecked, Unchecked, Checked, Unchec...
    ## $ grp.nmtr.all_6  <fct> Checked, Checked, Unchecked, Unchecked, Unchec...
    ## $ grp.nmtr.all_7  <fct> Unchecked, Unchecked, Checked, Unchecked, Unch...
    ## $ grp.nmtr.all_8  <fct> Checked, Unchecked, Unchecked, Checked, Unchec...
    ## $ grp.nmtr.all_10 <fct> Checked, Unchecked, Unchecked, Checked, Unchec...
    ## $ grp.nmtr.all_11 <fct> Checked, Unchecked, Unchecked, Checked, Unchec...
    ## $ grp.nmtr.all_12 <fct> Unchecked, Unchecked, Unchecked, Unchecked, Un...
    ## $ grp.nmtr.all_13 <fct> Checked, Unchecked, Unchecked, Checked, Unchec...
    ## $ act.mtr.all_1   <fct> Unchecked, Unchecked, Unchecked, Unchecked, Un...
    ## $ act.mtr.all_2   <fct> Checked, Unchecked, Unchecked, Unchecked, Unch...
    ## $ act.mtr.all_3   <fct> Checked, Unchecked, Unchecked, Checked, Unchec...
    ## $ act.mtr.all_4   <fct> Unchecked, Unchecked, Unchecked, Unchecked, Un...
    ## $ act.mtr.all_6   <fct> Checked, Checked, Unchecked, Checked, Unchecke...
    ## $ act.mtr.all_7   <fct> Unchecked, Unchecked, Unchecked, Unchecked, Un...
    ## $ act.mtr.all_8   <fct> Checked, Unchecked, Unchecked, Checked, Unchec...
    ## $ act.mtr.all_9   <fct> Unchecked, Unchecked, Unchecked, Unchecked, Un...
    ## $ act.mtr.all_10  <fct> Checked, Unchecked, Unchecked, Checked, Unchec...
    ## $ act.mtr.all_11  <fct> Unchecked, Unchecked, Unchecked, Unchecked, Un...
    ## $ act.mtr.all_13  <fct> Checked, Unchecked, Unchecked, Unchecked, Unch...

``` r
# Identify CO Target Pop --------------------------------------------------

# identify OIA respondents who would have passed the CO survey sreener
in_co_pop <- svy_all %>%
    select(Vrid, grp.nmtr.all_1:act.mtr.all_13) %>%
    gather(var, val, -Vrid) %>%
    filter(val == "Checked") %>%
    distinct(Vrid)
```

    ## Warning: attributes are not identical across measure variables;
    ## they will be dropped

``` r
# add identifier variable "in_co_pop" for downstream filtering/summarizing
svy_all <- bind_rows(
    semi_join(svy_all, in_co_pop, by = "Vrid") %>% mutate(in_co_pop = TRUE),
    anti_join(svy_all, in_co_pop, by = "Vrid") %>% mutate(in_co_pop = FALSE)
)

# summarize
group_by(svy_all, in_co_pop) %>%
    summarise(n = n(), wtn = sum(stwt)) %>%
    mutate(pct = wtn / sum(wtn))
```

    ## # A tibble: 2 x 4
    ##   in_co_pop     n   wtn   pct
    ##   <lgl>     <int> <dbl> <dbl>
    ## 1 FALSE       280  265. 0.229
    ## 2 TRUE        877  892. 0.771

``` r
# Recode Demographics --------------------------------------------------------

# We need categories that correspond between OIA and CO surveys
# - age_weight, sex, income_weight, race_weight

svy_all$age_weight <- svy_all$agecat
count(svy_all, age_weight, agecat)
```

    ## # A tibble: 3 x 3
    ##   age_weight agecat     n
    ##   <fct>      <fct>  <int>
    ## 1 18-34      18-34    369
    ## 2 35-54      35-54    361
    ## 3 55+        55+      427

``` r
svy_all <- svy_all %>% recode_cat(
    oldvar = "income",
    newvar = "income_weight",
    newcat = c(rep(1, 3), 2, 3, 4, 5, 6, rep(7, 2)),
    newlab = c("0-25K", "25-35K", "35-50K", "50-75K", "75-100K", "100-150K", "150K+")
)
```

    ## # A tibble: 11 x 3
    ##    income_weight income                  n
    ##    <fct>         <fct>               <int>
    ##  1 0-25K         Under $10,000          69
    ##  2 0-25K         $10,000 - $14,999      51
    ##  3 0-25K         $15,000 - $24,999      82
    ##  4 25-35K        $25,000 - $34,999     111
    ##  5 35-50K        $35,000 - $49,999     160
    ##  6 50-75K        $50,000 - $74,999     206
    ##  7 75-100K       $75,000 - $99,999     139
    ##  8 100-150K      $100,000 - $149,999   141
    ##  9 150K+         $150,000 - $199,999    42
    ## 10 150K+         $200,000 or more       33
    ## 11 <NA>          <NA>                  123

``` r
svy_all$race_weight <- svy_all$race
count(svy_all, race_weight, race)
```

    ## # A tibble: 4 x 3
    ##   race_weight           race                      n
    ##   <fct>                 <fct>                 <int>
    ## 1 White                 White                   883
    ## 2 Hispanic              Hispanic                139
    ## 3 Not white or Hispanic Not white or Hispanic   129
    ## 4 <NA>                  <NA>                      6

``` r
# Save --------------------------------------------------------------------

svy_all <- select(svy_all, Vrid:stwt, in_co_pop:race_weight, grp.nmtr.all_1:act.mtr.all_13)
glimpse(svy_all)
```

    ## Observations: 1,157
    ## Variables: 34
    ## $ Vrid            <dbl> 189, 5851, 7919, 8878, 667, 8439, 1751, 2356, ...
    ## $ Vstatus         <fct> Complete, Complete, Complete, Complete, Comple...
    ## $ qualify         <dbl> 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0...
    ## $ race            <fct> White, White, Hispanic, White, White, White, W...
    ## $ sex             <fct> Female, Female, Female, Male, Female, Female, ...
    ## $ agecat          <fct> 18-34, 18-34, 18-34, 18-34, 18-34, 35-54, 35-5...
    ## $ stwt            <dbl> 0.8927761, 0.8927761, 1.1913576, 1.1056643, 0....
    ## $ in_co_pop       <lgl> TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE...
    ## $ age_weight      <fct> 18-34, 18-34, 18-34, 18-34, 18-34, 35-54, 35-5...
    ## $ income_weight   <fct> 75-100K, 35-50K, 0-25K, 150K+, 0-25K, 25-35K, ...
    ## $ race_weight     <fct> White, White, Hispanic, White, White, White, W...
    ## $ grp.nmtr.all_1  <fct> Checked, Checked, Unchecked, Checked, Checked,...
    ## $ grp.nmtr.all_2  <fct> Checked, Unchecked, Checked, Unchecked, Checke...
    ## $ grp.nmtr.all_3  <fct> Unchecked, Unchecked, Unchecked, Checked, Unch...
    ## $ grp.nmtr.all_4  <fct> Checked, Checked, Unchecked, Checked, Checked,...
    ## $ grp.nmtr.all_5  <fct> Checked, Unchecked, Unchecked, Checked, Unchec...
    ## $ grp.nmtr.all_6  <fct> Checked, Checked, Unchecked, Unchecked, Unchec...
    ## $ grp.nmtr.all_7  <fct> Unchecked, Unchecked, Checked, Unchecked, Unch...
    ## $ grp.nmtr.all_8  <fct> Checked, Unchecked, Unchecked, Checked, Unchec...
    ## $ grp.nmtr.all_10 <fct> Checked, Unchecked, Unchecked, Checked, Unchec...
    ## $ grp.nmtr.all_11 <fct> Checked, Unchecked, Unchecked, Checked, Checke...
    ## $ grp.nmtr.all_12 <fct> Unchecked, Unchecked, Unchecked, Unchecked, Ch...
    ## $ grp.nmtr.all_13 <fct> Checked, Unchecked, Unchecked, Checked, Checke...
    ## $ act.mtr.all_1   <fct> Unchecked, Unchecked, Unchecked, Unchecked, Un...
    ## $ act.mtr.all_2   <fct> Checked, Unchecked, Unchecked, Unchecked, Unch...
    ## $ act.mtr.all_3   <fct> Checked, Unchecked, Unchecked, Checked, Unchec...
    ## $ act.mtr.all_4   <fct> Unchecked, Unchecked, Unchecked, Unchecked, Un...
    ## $ act.mtr.all_6   <fct> Checked, Checked, Unchecked, Checked, Unchecke...
    ## $ act.mtr.all_7   <fct> Unchecked, Unchecked, Unchecked, Unchecked, Un...
    ## $ act.mtr.all_8   <fct> Checked, Unchecked, Unchecked, Checked, Unchec...
    ## $ act.mtr.all_9   <fct> Unchecked, Unchecked, Unchecked, Unchecked, Un...
    ## $ act.mtr.all_10  <fct> Checked, Unchecked, Unchecked, Checked, Unchec...
    ## $ act.mtr.all_11  <fct> Unchecked, Unchecked, Unchecked, Unchecked, Un...
    ## $ act.mtr.all_13  <fct> Checked, Unchecked, Unchecked, Unchecked, Unch...

``` r
saveRDS(svy_all, "data-work/oia/oia-co.rds")
write_csv(svy_all, "data-work/oia/oia-co.csv")
```
