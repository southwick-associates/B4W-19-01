7-recode-outliers.R
================
danka
Fri Jan 31 16:00:44 2020

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
outlier_pct(x, act) %>% knitr::kable()
```

| act      | is\_outlier |  n | pct\_outliers |
| :------- | :---------- | -: | ------------: |
| camp     | TRUE        |  6 |     1.3793103 |
| fish     | TRUE        |  3 |     0.9803922 |
| hunt     | TRUE        |  1 |     0.6802721 |
| picnic   | TRUE        | 15 |     1.7241379 |
| snow     | TRUE        |  2 |     0.7168459 |
| trail    | TRUE        |  4 |     1.0204082 |
| water    | TRUE        |  4 |     1.1142061 |
| wildlife | TRUE        | 13 |     2.6530612 |

``` r
outlier_mean_compare(x, "days", "days_cleaned", act) %>% knitr::kable()
```

| act      |      days | days\_cleaned |
| :------- | --------: | ------------: |
| bike     | 31.581395 |     31.581395 |
| camp     | 11.163218 |      8.582751 |
| fish     | 11.640523 |      9.396040 |
| hunt     |  9.374150 |      8.342466 |
| picnic   | 17.478161 |     13.095906 |
| snow     |  9.989247 |      9.292419 |
| trail    | 28.418367 |     25.502577 |
| water    | 12.353760 |     10.521127 |
| wildlife | 30.524490 |     21.828092 |

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
outlier_pct(x, act) %>% knitr::kable()
```

| act      | is\_outlier | n | pct\_outliers |
| :------- | :---------- | -: | ------------: |
| bike     | TRUE        | 4 |     2.2598870 |
| camp     | TRUE        | 5 |     1.5974441 |
| fish     | TRUE        | 3 |     1.0000000 |
| picnic   | TRUE        | 7 |     1.1532125 |
| trail    | TRUE        | 4 |     1.4492754 |
| water    | TRUE        | 3 |     0.9493671 |
| wildlife | TRUE        | 4 |     1.1396011 |

``` r
outlier_mean_compare(x, "days_water", "days_cleaned", act) %>% knitr::kable()
```

| act      | days\_water | days\_cleaned |
| :------- | ----------: | ------------: |
| bike     |   15.344633 |     10.670520 |
| camp     |    7.904153 |      5.771987 |
| fish     |   11.776667 |      9.488216 |
| hunt     |    5.846154 |      5.607843 |
| picnic   |   10.650741 |      7.627090 |
| snow     |    2.929578 |      2.929578 |
| trail    |   14.873188 |     11.033210 |
| water    |   11.731013 |      9.926518 |
| wildlife |   13.019943 |     11.043732 |

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

# summarize
x <- filter(svy$basin, !is.na(days_water))
filter(x, days_water > 0) %>% outlier_plot("days_water", c("act", "basin")) + 
    facet_wrap(~ basin)
```

![](7-recode-outliers_files/figure-gfm/unnamed-chunk-1-3.png)<!-- -->

``` r
outlier_pct(x, act, basin) %>% ungroup() %>% select(-n, -is_outlier) %>% 
    spread(basin, pct_outliers, fill = 0) %>% knitr::kable()
```

| act      | arkansas |  colorado | gunnison |     metro | n platte |        rio | s platte | southwest | yampa |
| :------- | -------: | --------: | -------: | --------: | -------: | ---------: | -------: | --------: | ----: |
| bike     | 0.000000 | 0.0000000 | 0.000000 |  0.000000 | 0.000000 |  33.333333 | 5.769231 | 14.285714 |     0 |
| camp     | 3.030303 | 0.9615385 | 2.040816 |  4.166667 | 6.666667 |   0.000000 | 5.405405 |  5.555556 |     0 |
| fish     | 1.538461 | 1.3888889 | 2.439024 |  2.941177 | 6.666667 |   0.000000 | 2.898551 |  0.000000 |     0 |
| hunt     | 0.000000 | 0.0000000 | 0.000000 |  0.000000 | 0.000000 |   0.000000 | 0.000000 | 66.666667 |     0 |
| picnic   | 1.769912 | 1.3157895 | 0.000000 |  2.419355 | 3.636364 |   7.142857 | 2.312139 |  0.000000 |     0 |
| snow     | 0.000000 | 0.0000000 | 0.000000 | 50.000000 | 0.000000 | 100.000000 | 0.000000 |  0.000000 |   100 |
| trail    | 0.000000 | 0.0000000 | 0.000000 |  1.265823 | 2.857143 |   0.000000 | 0.000000 |  4.347826 |     0 |
| water    | 2.083333 | 6.1855670 | 0.000000 |  0.000000 | 3.846154 |  10.000000 | 0.000000 |  0.000000 |     0 |
| wildlife | 0.000000 | 3.0303030 | 2.173913 |  0.000000 | 5.000000 |   0.000000 | 6.140351 |  0.000000 |     0 |

``` r
outlier_mean_compare(x, "days_water", "days_cleaned", act, basin) %>%
    knitr::kable()
```

| act      | basin     | days\_water | days\_cleaned |
| :------- | :-------- | ----------: | ------------: |
| bike     | arkansas  |   23.714286 |     23.714286 |
| bike     | colorado  |    8.936170 |      8.936170 |
| bike     | metro     |    9.527273 |      9.527273 |
| bike     | n platte  |    3.538461 |      3.538461 |
| bike     | rio       |    3.333333 |      3.333333 |
| bike     | s platte  |   20.000000 |     11.899456 |
| bike     | southwest |   11.571429 |      5.878381 |
| bike     | yampa     |    8.333333 |      8.333333 |
| camp     | arkansas  |    4.106061 |      4.083765 |
| camp     | colorado  |    3.673077 |      3.526579 |
| camp     | gunnison  |    4.816326 |      4.607433 |
| camp     | metro     |    4.375000 |      2.524519 |
| camp     | n platte  |   18.366667 |      6.708077 |
| camp     | rio       |    3.148148 |      3.148148 |
| camp     | s platte  |    5.432432 |      4.338607 |
| camp     | southwest |    9.888889 |      4.593076 |
| camp     | yampa     |    3.681818 |      3.681818 |
| fish     | arkansas  |    8.969231 |      6.879256 |
| fish     | colorado  |    6.486111 |      6.428268 |
| fish     | gunnison  |    5.024390 |      4.654223 |
| fish     | metro     |    7.441177 |      4.841923 |
| fish     | n platte  |    4.233333 |      3.884282 |
| fish     | s platte  |    8.840580 |      7.289855 |
| fish     | southwest |    6.250000 |      6.250000 |
| fish     | yampa     |    5.833333 |      5.833333 |
| hunt     | arkansas  |    9.833333 |      9.833333 |
| hunt     | colorado  |    4.941177 |      4.941177 |
| hunt     | gunnison  |    3.250000 |      3.250000 |
| hunt     | n platte  |    1.666667 |      1.666667 |
| hunt     | rio       |    6.800000 |      6.800000 |
| hunt     | s platte  |    5.111111 |      5.111111 |
| hunt     | southwest |    1.333333 |      1.333333 |
| hunt     | yampa     |    7.500000 |      7.500000 |
| picnic   | arkansas  |    6.150442 |      5.498706 |
| picnic   | colorado  |    6.473684 |      5.617128 |
| picnic   | gunnison  |    2.916667 |      2.916667 |
| picnic   | metro     |   12.564516 |      8.646153 |
| picnic   | n platte  |    9.327273 |      4.869153 |
| picnic   | rio       |    4.392857 |      3.415265 |
| picnic   | s platte  |    7.404624 |      5.322010 |
| picnic   | southwest |    4.870968 |      4.870968 |
| picnic   | yampa     |    2.724138 |      2.724138 |
| snow     | arkansas  |    2.833333 |      2.833333 |
| snow     | colorado  |    2.461539 |      2.461539 |
| snow     | gunnison  |    2.750000 |      2.750000 |
| snow     | metro     |    1.500000 |      1.500000 |
| snow     | n platte  |    2.250000 |      2.250000 |
| snow     | rio       |    1.000000 |      1.000000 |
| snow     | southwest |    2.000000 |      2.000000 |
| snow     | yampa     |    5.000000 |      5.000000 |
| trail    | arkansas  |    6.803571 |      6.803571 |
| trail    | colorado  |    4.940000 |      4.940000 |
| trail    | gunnison  |    3.942857 |      3.942857 |
| trail    | metro     |   14.468354 |     13.329904 |
| trail    | n platte  |   16.257143 |      9.022954 |
| trail    | rio       |    3.000000 |      3.000000 |
| trail    | s platte  |    6.377778 |      6.377778 |
| trail    | southwest |    4.130435 |      3.902793 |
| trail    | yampa     |    2.083333 |      2.083333 |
| water    | arkansas  |    4.729167 |      4.703422 |
| water    | colorado  |    6.412371 |      4.923561 |
| water    | gunnison  |    3.157895 |      3.157895 |
| water    | metro     |    8.333333 |      8.333333 |
| water    | n platte  |    4.884615 |      4.683240 |
| water    | rio       |    4.000000 |      3.845349 |
| water    | s platte  |    7.452830 |      7.452830 |
| water    | southwest |    7.777778 |      7.777778 |
| water    | yampa     |    3.250000 |      3.250000 |
| wildlife | arkansas  |    6.015385 |      6.015385 |
| wildlife | colorado  |   10.989899 |      7.601464 |
| wildlife | gunnison  |    4.652174 |      4.043478 |
| wildlife | metro     |   10.192771 |     10.192771 |
| wildlife | n platte  |    8.725000 |      5.636967 |
| wildlife | rio       |    3.550000 |      3.550000 |
| wildlife | s platte  |    9.464912 |      6.791565 |
| wildlife | southwest |    4.857143 |      4.857143 |
| wildlife | yampa     |    2.333333 |      2.333333 |

``` r
# clean-up
svy$basin <- svy$basin %>%
    select(Vrid:part_water, days_water = days_cleaned)

# Save --------------------------------------------------------------------

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
    ## # A tibble: 22,167 x 5
    ##    Vrid  act   basin    part_water days_water
    ##    <chr> <chr> <chr>    <chr>           <dbl>
    ##  1 107   trail arkansas Checked             5
    ##  2 108   trail arkansas Unchecked          NA
    ##  3 110   trail arkansas Unchecked          NA
    ##  4 113   trail arkansas Checked             8
    ##  5 119   trail arkansas Unchecked          NA
    ##  6 129   trail arkansas Checked             1
    ##  7 131   trail arkansas Unchecked          NA
    ##  8 140   trail arkansas Checked            12
    ##  9 152   trail arkansas Unchecked          NA
    ## 10 157   trail arkansas Unchecked          NA
    ## # ... with 22,157 more rows
