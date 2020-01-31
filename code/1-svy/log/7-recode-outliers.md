7-recode-outliers.R
================
danka
Fri Jan 31 15:08:36 2020

``` r
# identify days outliers using tukey's rule
# also filtering out respondents flagged for suspicion

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
source("R/outliers.R")
source("R/prep-svy.R")
svy <- readRDS("data-work/1-svy/svy-weight.rds")

# exclude suspicious respondents
suspicious <- filter(svy$person, flag > 3)
svy <- lapply(svy, function(df) anti_join(df, suspicious, by = "Vrid"))
```

    ## Warning: Column `Vrid` has different attributes on LHS and RHS of join
    
    ## Warning: Column `Vrid` has different attributes on LHS and RHS of join

``` r
# Overall Days ------------------------------------------------------------

# identify outliers & set to NA
svy$act <- svy$act %>%
    group_by(act) %>%
    mutate(
        is_outlier = tukey_outlier(days, ignore_zero = TRUE, apply_log = TRUE),
        days_cleaned = ifelse(is_outlier, NA, days)
    ) %>%
    ungroup()

# summarize
x <- filter(svy$act, is_targeted, !is.na(days))
filter(x, days > 0) %>% outlier_plot() + ggtitle("Overall days outliers")
```

![](7-recode-outliers_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

``` r
outlier_pct(x, act)
```

    ## # A tibble: 8 x 4
    ## # Groups:   act [8]
    ##   act      is_outlier     n pct_outliers
    ##   <chr>    <lgl>      <int>        <dbl>
    ## 1 camp     TRUE           6        1.38 
    ## 2 fish     TRUE           3        0.980
    ## 3 hunt     TRUE           1        0.680
    ## 4 picnic   TRUE          15        1.72 
    ## 5 snow     TRUE           2        0.717
    ## 6 trail    TRUE           4        1.02 
    ## 7 water    TRUE           4        1.11 
    ## 8 wildlife TRUE          13        2.65

``` r
outlier_mean_compare(x, "days", "days_cleaned", act)
```

    ## # A tibble: 9 x 3
    ##   act       days days_cleaned
    ##   <chr>    <dbl>        <dbl>
    ## 1 bike     31.6         31.6 
    ## 2 camp     11.2          8.58
    ## 3 fish     11.6          9.40
    ## 4 hunt      9.37         8.34
    ## 5 picnic   17.5         13.1 
    ## 6 snow      9.99         9.29
    ## 7 trail    28.4         25.5 
    ## 8 water    12.4         10.5 
    ## 9 wildlife 30.5         21.8

``` r
# clean-up
svy$act <- svy$act %>%
    select(-days) %>%
    rename(days = days_cleaned, is_overall_outlier = is_outlier)

# Water Days --------------------------------------------------------------

# run outlier test specific to water days
# also any records with corresponding overall outliers will have water days set to missing
svy$act <- svy$act %>%
    group_by(act) %>%
    mutate(
        is_outlier = tukey_outlier(days_water, ignore_zero = TRUE, apply_log = TRUE),
        days_cleaned = ifelse(is_outlier | is_overall_outlier, NA, days_water)
    ) %>%
    ungroup()

# summarize
x <- filter(svy$act, is_targeted, !is.na(days_water))
filter(x, days_water > 0) %>% outlier_plot("days_water") + ggtitle("Water days outliers")
```

![](7-recode-outliers_files/figure-gfm/unnamed-chunk-1-2.png)<!-- -->

``` r
outlier_pct(x, act)
```

    ## # A tibble: 7 x 4
    ## # Groups:   act [7]
    ##   act      is_outlier     n pct_outliers
    ##   <chr>    <lgl>      <int>        <dbl>
    ## 1 bike     TRUE           4        2.26 
    ## 2 camp     TRUE           5        1.60 
    ## 3 fish     TRUE           3        1    
    ## 4 picnic   TRUE           7        1.15 
    ## 5 trail    TRUE           4        1.45 
    ## 6 water    TRUE           3        0.949
    ## 7 wildlife TRUE           4        1.14

``` r
outlier_mean_compare(x, "days_water", "days_cleaned", act)
```

    ## # A tibble: 9 x 3
    ##   act      days_water days_cleaned
    ##   <chr>         <dbl>        <dbl>
    ## 1 bike          15.3         10.7 
    ## 2 camp           7.90         5.77
    ## 3 fish          11.8          9.49
    ## 4 hunt           5.85         5.61
    ## 5 picnic        10.7          7.63
    ## 6 snow           2.93         2.93
    ## 7 trail         14.9         11.0 
    ## 8 water         11.7          9.93
    ## 9 wildlife      13.0         11.0

``` r
# clean-up
svy$act <- svy$act %>%
    select(Vrid:part, days, part_water, days_water = days_cleaned)

# Basin Water Days --------------------------------------------------------

# outliers are identified specific to act-basin
# use top-coding for these to avoid losing information about the share of 
#  days allocated to each basin
svy$basin <- svy$basin %>%
    group_by(act, basin) %>%
    mutate(
        is_outlier = tukey_outlier(days_water, ignore_zero = TRUE, apply_log = TRUE),
        topcode_value = tukey_top(days_water, ignore_zero = TRUE, apply_log = TRUE),
        days_cleaned = ifelse(is_outlier, topcode_value, days_water)
    ) %>%
    ungroup()

x <- filter(svy$basin, !is.na(days_water))
filter(x, days_water > 0) %>% outlier_plot("days_water", c("act", "basin")) + 
    facet_wrap(~ basin)
```

![](7-recode-outliers_files/figure-gfm/unnamed-chunk-1-3.png)<!-- -->

``` r
outlier_pct(x, act, basin) %>% ungroup() %>% select(-n, -is_outlier) %>% 
    spread(basin, pct_outliers, fill = 0)
```

    ## # A tibble: 9 x 10
    ##   act   arkansas colorado gunnison metro `n platte`    rio `s platte`
    ##   <chr>    <dbl>    <dbl>    <dbl> <dbl>      <dbl>  <dbl>      <dbl>
    ## 1 bike      0       0         0     0          0     33.3        5.77
    ## 2 camp      3.03    0.962     2.04  4.17       6.67   0          5.41
    ## 3 fish      1.54    1.39      2.44  2.94       6.67   0          2.90
    ## 4 hunt      0       0         0     0          0      0          0   
    ## 5 picn~     1.77    1.32      0     2.42       3.64   7.14       2.31
    ## 6 snow      0       0         0    50          0    100          0   
    ## 7 trail     0       0         0     1.27       2.86   0          0   
    ## 8 water     2.08    6.19      0     0          3.85  10          0   
    ## 9 wild~     0       3.03      2.17  0          5      0          6.14
    ## # ... with 2 more variables: southwest <dbl>, yampa <dbl>

``` r
outlier_mean_compare(x, "days_water", "days_cleaned", act, basin) %>%
    data.frame()
```

    ##         act     basin days_water days_cleaned
    ## 1      bike  arkansas  23.714286    23.714286
    ## 2      bike  colorado   8.936170     8.936170
    ## 3      bike     metro   9.527273     9.527273
    ## 4      bike  n platte   3.538462     3.538462
    ## 5      bike       rio   3.333333     3.333333
    ## 6      bike  s platte  20.000000    11.899456
    ## 7      bike southwest  11.571429     5.878381
    ## 8      bike     yampa   8.333333     8.333333
    ## 9      camp  arkansas   4.106061     4.083765
    ## 10     camp  colorado   3.673077     3.526579
    ## 11     camp  gunnison   4.816327     4.607433
    ## 12     camp     metro   4.375000     2.524519
    ## 13     camp  n platte  18.366667     6.708077
    ## 14     camp       rio   3.148148     3.148148
    ## 15     camp  s platte   5.432432     4.338607
    ## 16     camp southwest   9.888889     4.593076
    ## 17     camp     yampa   3.681818     3.681818
    ## 18     fish  arkansas   8.969231     6.879256
    ## 19     fish  colorado   6.486111     6.428268
    ## 20     fish  gunnison   5.024390     4.654223
    ## 21     fish     metro   7.441176     4.841923
    ## 22     fish  n platte   4.233333     3.884282
    ## 23     fish  s platte   8.840580     7.289855
    ## 24     fish southwest   6.250000     6.250000
    ## 25     fish     yampa   5.833333     5.833333
    ## 26     hunt  arkansas   9.833333     9.833333
    ## 27     hunt  colorado   4.941176     4.941176
    ## 28     hunt  gunnison   3.250000     3.250000
    ## 29     hunt  n platte   1.666667     1.666667
    ## 30     hunt       rio   6.800000     6.800000
    ## 31     hunt  s platte   5.111111     5.111111
    ## 32     hunt southwest   1.333333     1.333333
    ## 33     hunt     yampa   7.500000     7.500000
    ## 34   picnic  arkansas   6.150442     5.498706
    ## 35   picnic  colorado   6.473684     5.617128
    ## 36   picnic  gunnison   2.916667     2.916667
    ## 37   picnic     metro  12.564516     8.646153
    ## 38   picnic  n platte   9.327273     4.869153
    ## 39   picnic       rio   4.392857     3.415265
    ## 40   picnic  s platte   7.404624     5.322010
    ## 41   picnic southwest   4.870968     4.870968
    ## 42   picnic     yampa   2.724138     2.724138
    ## 43     snow  arkansas   2.833333     2.833333
    ## 44     snow  colorado   2.461538     2.461538
    ## 45     snow  gunnison   2.750000     2.750000
    ## 46     snow     metro   1.500000     1.500000
    ## 47     snow  n platte   2.250000     2.250000
    ## 48     snow       rio   1.000000     1.000000
    ## 49     snow southwest   2.000000     2.000000
    ## 50     snow     yampa   5.000000     5.000000
    ## 51    trail  arkansas   6.803571     6.803571
    ## 52    trail  colorado   4.940000     4.940000
    ## 53    trail  gunnison   3.942857     3.942857
    ## 54    trail     metro  14.468354    13.329904
    ## 55    trail  n platte  16.257143     9.022954
    ## 56    trail       rio   3.000000     3.000000
    ## 57    trail  s platte   6.377778     6.377778
    ## 58    trail southwest   4.130435     3.902793
    ## 59    trail     yampa   2.083333     2.083333
    ## 60    water  arkansas   4.729167     4.703422
    ## 61    water  colorado   6.412371     4.923561
    ## 62    water  gunnison   3.157895     3.157895
    ## 63    water     metro   8.333333     8.333333
    ## 64    water  n platte   4.884615     4.683240
    ## 65    water       rio   4.000000     3.845349
    ## 66    water  s platte   7.452830     7.452830
    ## 67    water southwest   7.777778     7.777778
    ## 68    water     yampa   3.250000     3.250000
    ## 69 wildlife  arkansas   6.015385     6.015385
    ## 70 wildlife  colorado  10.989899     7.601464
    ## 71 wildlife  gunnison   4.652174     4.043478
    ## 72 wildlife     metro  10.192771    10.192771
    ## 73 wildlife  n platte   8.725000     5.636967
    ## 74 wildlife       rio   3.550000     3.550000
    ## 75 wildlife  s platte   9.464912     6.791565
    ## 76 wildlife southwest   4.857143     4.857143
    ## 77 wildlife     yampa   2.333333     2.333333

``` r
# Save --------------------------------------------------------------------

glimpse(svy$person)
```

    ## Observations: 1,252
    ## Variables: 12
    ## $ Vrid          <chr> "98", "99", "100", "101", "102", "103", "105", "...
    ## $ id            <chr> "C2058317730", "C2058321874", "C2058323362", "C2...
    ## $ Vstatus       <chr> "Complete", "Complete", "Partial", "Complete", "...
    ## $ sex           <fct> Female, Female, NA, Male, Female, Male, Male, Fe...
    ## $ race          <fct> White, Other, NA, White, Black/African-American,...
    ## $ race_other    <chr> "", "unecessary question", "", "", "", "", "", "...
    ## $ hispanic      <fct> No, No, NA, No, No, No, No, No, Yes, Yes, No, Ye...
    ## $ age_weight    <fct> 35-54, 35-54, NA, 35-54, 35-54, 18-34, 18-34, 35...
    ## $ income_weight <fct> 0-25K, 0-25K, NA, 25-35K, 50-75K, 25-35K, 50-75K...
    ## $ race_weight   <fct> White, Not white or Hispanic, NA, White, Not whi...
    ## $ flag          <dbl> 0, 0, 3, 0, 0, 0, 0, 0, 0, 1, 2, 1, 0, 0, 0, 3, ...
    ## $ weight        <dbl> 0.9596845, 1.0899973, 1.0000000, 0.8747500, 0.96...

``` r
saveRDS(svy, "data-work/1-svy/svy-final.rds")

# save as csvs (for Eric)
outdir <- "data-work/1-svy/svy-final-csv"
sapply(names(svy), function(nm) {
    write_list_csv(svy, nm, outdir)
})
```

    ## $person
    ## # A tibble: 1,252 x 12
    ##    Vrid  id    Vstatus sex   race  race_other hispanic age_weight
    ##    <chr> <chr> <chr>   <fct> <fct> <chr>      <fct>    <fct>     
    ##  1 98    C205~ Comple~ Fema~ White ""         No       35-54     
    ##  2 99    C205~ Comple~ Fema~ Other unecessar~ No       35-54     
    ##  3 100   C205~ Partial <NA>  <NA>  ""         <NA>     <NA>      
    ##  4 101   C205~ Comple~ Male  White ""         No       35-54     
    ##  5 102   C205~ Comple~ Fema~ Blac~ ""         No       35-54     
    ##  6 103   C205~ Comple~ Male  White ""         No       18-34     
    ##  7 105   C205~ Comple~ Male  White ""         No       18-34     
    ##  8 106   C205~ Comple~ Fema~ Blac~ ""         No       35-54     
    ##  9 107   C205~ Comple~ Male  White ""         Yes      35-54     
    ## 10 108   C205~ Comple~ Fema~ Asian ""         Yes      18-34     
    ## # ... with 1,242 more rows, and 4 more variables: income_weight <fct>,
    ## #   race_weight <fct>, flag <dbl>, weight <dbl>
    ## 
    ## $act
    ## # A tibble: 17,528 x 7
    ##    Vrid  act   is_targeted part       days part_water days_water
    ##    <chr> <chr> <lgl>       <chr>     <dbl> <chr>           <dbl>
    ##  1 98    trail TRUE        Unchecked    NA <NA>               NA
    ##  2 99    trail TRUE        Unchecked    NA <NA>               NA
    ##  3 100   trail TRUE        Unchecked    NA <NA>               NA
    ##  4 101   trail TRUE        Unchecked    NA <NA>               NA
    ##  5 102   trail TRUE        Unchecked    NA <NA>               NA
    ##  6 103   trail TRUE        Unchecked    NA <NA>               NA
    ##  7 105   trail TRUE        Unchecked    NA <NA>               NA
    ##  8 106   trail TRUE        Unchecked    NA <NA>               NA
    ##  9 107   trail TRUE        Checked      15 Yes                10
    ## 10 108   trail TRUE        Checked      10 Yes                 5
    ## # ... with 17,518 more rows
    ## 
    ## $basin
    ## # A tibble: 22,167 x 8
    ##    Vrid  act   basin part_water days_water is_outlier topcode_value
    ##    <chr> <chr> <chr> <chr>           <dbl> <lgl>              <dbl>
    ##  1 107   trail arka~ Checked             5 FALSE               112.
    ##  2 108   trail arka~ Unchecked          NA FALSE               112.
    ##  3 110   trail arka~ Unchecked          NA FALSE               112.
    ##  4 113   trail arka~ Checked             8 FALSE               112.
    ##  5 119   trail arka~ Unchecked          NA FALSE               112.
    ##  6 129   trail arka~ Checked             1 FALSE               112.
    ##  7 131   trail arka~ Unchecked          NA FALSE               112.
    ##  8 140   trail arka~ Checked            12 FALSE               112.
    ##  9 152   trail arka~ Unchecked          NA FALSE               112.
    ## 10 157   trail arka~ Unchecked          NA FALSE               112.
    ## # ... with 22,157 more rows, and 1 more variable: days_cleaned <dbl>
