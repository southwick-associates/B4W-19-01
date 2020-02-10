2-reshape.R
================
danka
2020-02-10

``` r
# reshape (i.e., tidy) survey data to facilitate analysis
# - https://r4ds.had.co.nz/tidy-data.html

# 3 output tables (1 per dimension) stored in a list
# - person
# - act (person by activity)
# - basin (person by activity by basin)

library(tidyverse)
source("R/prep-svy.R") # functions

infile <- "data/interim/svy-raw.rds"
outfile <- "data/interim/svy-reshape.rds"
outfile_csv <- "data/interim/svy-reshape-csv/"

# Load Data ---------------------------------------------------------------

svy <- readRDS(infile)

# check ID uniqueness, should show TRUE
length(unique(svy$Vrid)) == nrow(svy)
```

    ## [1] TRUE

``` r
# Person ------------------------------------------------------------

person <- select(svy, Vrid, id, Vstatus, age = var9, sex = var10, income = var11,
                 race = var12, race_other = var12O59Othr, hispanic = var13)

# check IDs
length(unique(svy$id)) # not unique in records, same person tho?
```

    ## [1] 1341

``` r
length(unique(svy$Vrid))
```

    ## [1] 1373

``` r
dups <- count(svy, id) %>% filter(n > 1)
semi_join(person, dups, by = "id") %>%
    arrange(id) %>%
    write_csv("data/interim/svy-id-dups.csv")

# Person-Activity ----------------------------------------------------------------

# Did you participate in any of the following activities in Colorado between 
# December 1, 2018 and November 30, 2019?
part <- svy %>%
    reshape_vars(var2O1:var2O15, dim_file = "data/raw/svy/act_labs.xlsx") %>%
    select(Vrid, act, part = val)
```

    ## Parsed with column specification:
    ## cols(
    ##   var = col_character(),
    ##   lab = col_character()
    ## )

    ## Warning: Expected 2 pieces. Additional pieces discarded in 14 rows [2, 3, 4, 5, 6,
    ## 7, 8, 9, 10, 11, 12, 13, 14, 15].

    ## Warning: attributes are not identical across measure variables;
    ## they will be dropped

    ## 
    ## --- Labelling Summary ---
    ## 
    ## # A tibble: 15 x 3
    ##    act       lab1                                                                 n
    ##    <chr>     <chr>                                                            <int>
    ##  1 bike      bicycling or skateboarding (on paved road or off-road)            1373
    ##  2 camp      camping (rv at campsite, tent campsite, or at a rustic lodge)     1373
    ##  3 fish      fishing (recreational fly and non-fly)                            1373
    ##  4 hunt      hunting & shooting (shotgun, rifle, or bow)                       1373
    ##  5 motorcyc~ motorcycling (on-road, off-road)                                  1373
    ##  6 none      i didn't participate in any of these activities                   1373
    ##  7 offroad   off-roading with atvs, 4x4 trucks                                 1373
    ##  8 picnic    picnicking or relaxing                                            1373
    ##  9 playgrou~ playground activities                                             1373
    ## 10 snow      snow sports (skiing cross-country/downhill/telemark, snowboardi~  1373
    ## 11 sport     individual competitive sports (golf, tennis)                      1373
    ## 12 team      team competitive sports (softball/baseball, volleyball, soccer,~  1373
    ## 13 trail     trail sports (running 3+ miles, day-hiking, backpacking, climbi~  1373
    ## 14 water     water sports (swimming, canoeing, kayaking, rafting, paddle-boa~  1373
    ## 15 wildlife  wildlife-watching (viewing, feeding, or photographing animals, ~  1373

``` r
# along water?
part_water <- svy %>%
    reshape_vars(var47:var55, dim_file = "data/raw/svy/act_labs.xlsx") %>%
    select(Vrid, act, part_water = val)
```

    ## Parsed with column specification:
    ## cols(
    ##   var = col_character(),
    ##   lab = col_character()
    ## )

    ## Warning: attributes are not identical across measure variables;
    ## they will be dropped

    ## 
    ## --- Labelling Summary ---
    ## 
    ## # A tibble: 7 x 3
    ##   act      lab1                                                                   n
    ##   <chr>    <chr>                                                              <int>
    ## 1 bike     bicycling or skateboarding (on paved road or off-road)               378
    ## 2 camp     camping (rv at campsite, tent campsite, or at a rustic lodge)        488
    ## 3 hunt     hunting & shooting (shotgun, rifle, or bow)                          166
    ## 4 picnic   picnicking or relaxing                                               910
    ## 5 snow     snow sports (skiing cross-country/downhill/telemark, snowboarding~   303
    ## 6 trail    trail sports (running 3+ miles, day-hiking, backpacking, climbing~   428
    ## 7 wildlife wildlife-watching (viewing, feeding, or photographing animals, bi~   514

``` r
# how many days?
days <- svy %>% 
    reshape_vars(var94:var103, dim_file = "data/raw/svy/act_labs.xlsx") %>%
    select(Vrid, act, days = val)
```

    ## Parsed with column specification:
    ## cols(
    ##   var = col_character(),
    ##   lab = col_character()
    ## )

    ## Warning: Expected 2 pieces. Missing pieces filled with `NA` in 9 rows [1, 2, 3, 4, 5, 6, 7, 8, 9].
    
    ## Warning: attributes are not identical across measure variables;
    ## they will be dropped

    ## 
    ## --- Labelling Summary ---
    ## 
    ## # A tibble: 9 x 3
    ##   act      lab1                                                                   n
    ##   <chr>    <chr>                                                              <int>
    ## 1 bike     bicycling or skateboarding (on paved road or off-road)               396
    ## 2 camp     camping (rv at campsite, tent campsite, or at a rustic lodge)        500
    ## 3 fish     fishing (recreational fly and non-fly)                               342
    ## 4 hunt     hunting & shooting (shotgun, rifle, or bow)                          171
    ## 5 picnic   picnicking or relaxing                                               948
    ## 6 snow     snow sports (skiing cross-country/downhill/telemark, snowboarding~   319
    ## 7 trail    trail sports (running 3+ miles, day-hiking, backpacking, climbing~   447
    ## 8 water    water sports (swimming, canoeing, kayaking, rafting, paddle-board~   391
    ## 9 wildlife wildlife-watching (viewing, feeding, or photographing animals, bi~   539

``` r
# days along water?
days_water <- svy %>%
    reshape_vars(var57:var66, dim_file = "data/raw/svy/act_labs.xlsx",
                 func = function(x) separate(x, "lab", c("lab1", "lab2"), sep = "\\[")) %>%
    select(Vrid, act, days_water = val)
```

    ## Parsed with column specification:
    ## cols(
    ##   var = col_character(),
    ##   lab = col_character()
    ## )

    ## Warning: attributes are not identical across measure variables;
    ## they will be dropped

    ## 
    ## --- Labelling Summary ---
    ## 
    ## # A tibble: 7 x 3
    ##   act      lab1                                                                   n
    ##   <chr>    <chr>                                                              <int>
    ## 1 bike     bicycling or skateboarding (on paved road or off-road)               216
    ## 2 camp     camping (rv at campsite, tent campsite, or at a rustic lodge)        375
    ## 3 hunt     hunting & shooting (shotgun, rifle, or bow)                           70
    ## 4 picnic   picnicking or relaxing                                               675
    ## 5 snow     snow sports (skiing cross-country/downhill/telemark, snowboarding~    92
    ## 6 trail    trail sports (running 3+ miles, day-hiking, backpacking, climbing~   314
    ## 7 wildlife wildlife-watching (viewing, feeding, or photographing animals, bi~   386

``` r
# combine
act <- part %>%
    left_join(part_water) %>%
    left_join(days) %>%
    left_join(days_water)
```

    ## Joining, by = c("Vrid", "act")

    ## Warning: Column `Vrid` has different attributes on LHS and RHS of join

    ## Joining, by = c("Vrid", "act")

    ## Warning: Column `Vrid` has different attributes on LHS and RHS of join

    ## Joining, by = c("Vrid", "act")

    ## Warning: Column `Vrid` has different attributes on LHS and RHS of join

``` r
# Person-Activity-Basin ----------------------------------------------------------

part <- svy %>%
    reshape_vars(var70O197:var78O294, dim_file = "data/raw/svy/pipe_labs.xlsx", dim_var = "lab2") %>%
    recode_basin() %>%
    select(Vrid, act, basin, part = val)
```

    ## Parsed with column specification:
    ## cols(
    ##   var = col_character(),
    ##   lab = col_character()
    ## )

    ## Warning: attributes are not identical across measure variables;
    ## they will be dropped

    ## 
    ## --- Labelling Summary ---
    ## 
    ## # A tibble: 9 x 3
    ##   act      lab2          n
    ##   <chr>    <chr>     <int>
    ## 1 bike     bicycling  2020
    ## 2 camp     camp       3600
    ## 3 fish     fish       3110
    ## 4 hunt     hunt        580
    ## 5 picnic   picnic     6460
    ## 6 snow     snow        680
    ## 7 trail    trail      3080
    ## 8 water    water      3610
    ## 9 wildlife wildlife   3720
    ## 
    ## --- Basin Summary ---
    ## 
    ## # A tibble: 18 x 3
    ##    basin     lab1                                                                 n
    ##    <chr>     <chr>                                                            <int>
    ##  1 arkansas  Arkansas River Basin                                              2686
    ##  2 colorado  Colorado River Basin                                              2686
    ##  3 gunnison  Gunnison River Basin                                              2686
    ##  4 metro     Metro Area                                                        2686
    ##  5 n platte  North Platte River Basin                                          2686
    ##  6 none      I did not engage in bicycling or skateboarding on or along the ~   202
    ##  7 none      I did not engage in camping on or along the water during this t~   360
    ##  8 none      I did not engage in fishing on or along the water during this t~   311
    ##  9 none      I did not engage in hunting and shooting on or along the water ~    58
    ## 10 none      I did not engage in picnicking or relaxing on or along the wate~   646
    ## 11 none      I did not engage in snow sports on or along the water during th~    68
    ## 12 none      I did not engage in trail sports on or along the water during t~   308
    ## 13 none      I did not engage in water sports on or along the water during t~   361
    ## 14 none      I did not engage in wildlife-watching on or along the water dur~   372
    ## 15 rio       Rio Grande River Basin                                            2686
    ## 16 s platte  South Platte River Basin (excluding Metro Area)                   2686
    ## 17 southwest Southwest River Basin                                             2686
    ## 18 yampa     Yampa-White River Basin                                           2686

``` r
days <- svy %>%
    reshape_vars(var80O197:var88O293, dim_file = "data/raw/svy/pipe_labs.xlsx", dim_var = "lab2") %>%
    recode_basin() %>%
    select(Vrid, act, basin, days_water = val)
```

    ## Parsed with column specification:
    ## cols(
    ##   var = col_character(),
    ##   lab = col_character()
    ## )

    ## Warning: attributes are not identical across measure variables;
    ## they will be dropped

    ## 
    ## --- Labelling Summary ---
    ## 
    ## # A tibble: 9 x 3
    ##   act      lab2          n
    ##   <chr>    <chr>     <int>
    ## 1 bike     bicycling   233
    ## 2 camp     camp        483
    ## 3 fish     fish        380
    ## 4 hunt     hunt         62
    ## 5 picnic   picnic      805
    ## 6 snow     snow         68
    ## 7 trail    trail       508
    ## 8 water    water       398
    ## 9 wildlife wildlife    548
    ## 
    ## --- Basin Summary ---
    ## 
    ## # A tibble: 9 x 3
    ##   basin     lab1                                                n
    ##   <chr>     <chr>                                           <int>
    ## 1 arkansas  Arkansas River Basin                              494
    ## 2 colorado  Colorado River Basin                              798
    ## 3 gunnison  Gunnison River Basin                              277
    ## 4 metro     Metro Area                                        500
    ## 5 n platte  North Platte River Basin                          259
    ## 6 rio       Rio Grande River Basin                            155
    ## 7 s platte  South Platte River Basin (excluding Metro Area)   689
    ## 8 southwest Southwest River Basin                             165
    ## 9 yampa     Yampa-White River Basin                           148

``` r
basin <- left_join(part, days)
```

    ## Joining, by = c("Vrid", "act", "basin")

``` r
# Save --------------------------------------------------------------------

out <- mget(c("person", "act", "basin"))
saveRDS(out, outfile)

# in csv format
sapply(names(out), function(nm) {
    write_list_csv(out, nm, outfile_csv)
})
```

    ## $person
    ## # A tibble: 1,373 x 9
    ##    Vrid  id      Vstatus  age    sex    income    race       race_other    hispanic
    ##    <chr> <chr>   <chr>    <chr>  <chr>  <chr>     <chr>      <chr>         <chr>   
    ##  1 98    C20583~ Complete 45 to~ Female Less tha~ White      ""            No      
    ##  2 99    C20583~ Complete 45 to~ Female Less tha~ Other      "unecessary ~ No      
    ##  3 100   C20583~ Partial  <NA>   <NA>   <NA>      <NA>       ""            <NA>    
    ##  4 101   C20583~ Complete 35 to~ Male   $25,000 ~ White      ""            No      
    ##  5 102   C20583~ Complete 35 to~ Female $50,000 ~ Black/Afr~ ""            No      
    ##  6 103   C20583~ Complete 18 to~ Male   $25,000 ~ White      ""            No      
    ##  7 104   C20583~ Complete 55 to~ Female $75,000 ~ White      ""            No      
    ##  8 105   C20583~ Complete 25 to~ Male   $50,000 ~ White      ""            No      
    ##  9 106   C20583~ Complete 45 to~ Female $35,000 ~ Black/Afr~ ""            No      
    ## 10 107   C20583~ Complete 35 to~ Male   $25,000 ~ White      ""            Yes     
    ## # ... with 1,363 more rows
    ## 
    ## $act
    ## # A tibble: 20,595 x 6
    ##    Vrid  act   part      part_water  days days_water
    ##    <chr> <chr> <chr>     <chr>      <dbl>      <dbl>
    ##  1 98    trail Unchecked <NA>          NA         NA
    ##  2 99    trail Unchecked <NA>          NA         NA
    ##  3 100   trail Unchecked <NA>          NA         NA
    ##  4 101   trail Unchecked <NA>          NA         NA
    ##  5 102   trail Unchecked <NA>          NA         NA
    ##  6 103   trail Unchecked <NA>          NA         NA
    ##  7 104   trail Unchecked <NA>          NA         NA
    ##  8 105   trail Unchecked <NA>          NA         NA
    ##  9 106   trail Unchecked <NA>          NA         NA
    ## 10 107   trail Checked   Yes           15         10
    ## # ... with 20,585 more rows
    ## 
    ## $basin
    ## # A tibble: 26,860 x 5
    ##    Vrid  act   basin    part      days_water
    ##    <chr> <chr> <chr>    <chr>          <dbl>
    ##  1 107   trail arkansas Checked            5
    ##  2 108   trail arkansas Unchecked         NA
    ##  3 110   trail arkansas Unchecked         NA
    ##  4 113   trail arkansas Checked            8
    ##  5 119   trail arkansas Unchecked         NA
    ##  6 127   trail arkansas Unchecked         NA
    ##  7 129   trail arkansas Checked            1
    ##  8 131   trail arkansas Unchecked         NA
    ##  9 140   trail arkansas Checked           12
    ## 10 152   trail arkansas Unchecked         NA
    ## # ... with 26,850 more rows

``` r
# Summaries ---------------------------------------------------------------

# person
plot_choice(person, age)
```

    ## Warning: Factor `age` contains implicit NA, consider using
    ## `forcats::fct_explicit_na`

![](2-reshape_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

``` r
plot_choice(person, sex)
```

    ## Warning: Factor `sex` contains implicit NA, consider using
    ## `forcats::fct_explicit_na`

![](2-reshape_files/figure-gfm/unnamed-chunk-1-2.png)<!-- -->

``` r
plot_choice(person, income)
```

    ## Warning: Factor `income` contains implicit NA, consider using
    ## `forcats::fct_explicit_na`

![](2-reshape_files/figure-gfm/unnamed-chunk-1-3.png)<!-- -->

``` r
plot_choice(person, race)
```

    ## Warning: Factor `race` contains implicit NA, consider using
    ## `forcats::fct_explicit_na`

![](2-reshape_files/figure-gfm/unnamed-chunk-1-4.png)<!-- -->

``` r
plot_choice(person, race_other)
```

![](2-reshape_files/figure-gfm/unnamed-chunk-1-5.png)<!-- -->

``` r
plot_choice(person, hispanic)
```

    ## Warning: Factor `hispanic` contains implicit NA, consider using
    ## `forcats::fct_explicit_na`

![](2-reshape_files/figure-gfm/unnamed-chunk-1-6.png)<!-- -->

``` r
# act
plot_choice_multi(act, part, act) + ggtitle("Overall Participation")
```

![](2-reshape_files/figure-gfm/unnamed-chunk-1-7.png)<!-- -->

``` r
plot_choice_multi(act, part_water, act, part) + facet_wrap(~ part) + 
    ggtitle("Participation along the water (facetted by overall participation)")
```

![](2-reshape_files/figure-gfm/unnamed-chunk-1-8.png)<!-- -->

``` r
plot_num(act, days, act, part) + facet_wrap(~ part) +
    ggtitle("Overall Days (facetted by overall participation)")
```

    ## Warning: Transformation introduced infinite values in continuous y-axis

    ## Warning: Removed 57 rows containing non-finite values (stat_boxplot).

![](2-reshape_files/figure-gfm/unnamed-chunk-1-9.png)<!-- -->

``` r
plot_num(act, days_water, act, part_water) + facet_wrap(~ part_water)+
    ggtitle("Days along water (facetted by water participation)")
```

    ## Warning: Transformation introduced infinite values in continuous y-axis

    ## Warning: Removed 84 rows containing non-finite values (stat_boxplot).

![](2-reshape_files/figure-gfm/unnamed-chunk-1-10.png)<!-- -->

``` r
# basin
plot_choice_multi(basin, part, basin, act) + facet_wrap(~ act)
```

![](2-reshape_files/figure-gfm/unnamed-chunk-1-11.png)<!-- -->

``` r
plot_num(basin, days_water, basin, part) + facet_wrap(~ part)
```

    ## Warning: Transformation introduced infinite values in continuous y-axis

    ## Warning: Removed 205 rows containing non-finite values (stat_boxplot).

![](2-reshape_files/figure-gfm/unnamed-chunk-1-12.png)<!-- -->

``` r
plot_num(basin, days_water, basin, act) + facet_wrap(~ act)
```

    ## Warning: Transformation introduced infinite values in continuous y-axis
    
    ## Warning: Removed 205 rows containing non-finite values (stat_boxplot).

![](2-reshape_files/figure-gfm/unnamed-chunk-1-13.png)<!-- -->
