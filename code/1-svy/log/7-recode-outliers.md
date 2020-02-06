7-recode-outliers.R
================
danka
Thu Feb 06 12:15:13 2020

``` r
# identify days outliers using tukey's rule
# also filtering out respondents flagged for suspicion

library(tidyverse)
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

| act      | arkansas | colorado | gunnison |     metro | n platte |        rio | s platte | southwest | yampa |
| :------- | -------: | -------: | -------: | --------: | -------: | ---------: | -------: | --------: | ----: |
| bike     | 0.000000 | 0.000000 | 0.000000 |  0.000000 | 0.000000 |  50.000000 | 6.250000 | 20.000000 |     0 |
| camp     | 3.125000 | 3.061224 | 2.040816 |  4.166667 | 6.896552 |   0.000000 | 5.555556 | 11.764706 |     0 |
| fish     | 1.639344 | 1.492537 | 2.702703 |  3.225807 | 3.571429 |   0.000000 | 1.538461 |  0.000000 |     0 |
| hunt     | 0.000000 | 0.000000 | 0.000000 |  0.000000 | 0.000000 |   0.000000 | 0.000000 | 66.666667 |     0 |
| picnic   | 1.818182 | 1.470588 | 0.000000 |  1.709402 | 4.081633 |   7.692308 | 2.395210 |  0.000000 |     0 |
| snow     | 0.000000 | 0.000000 | 0.000000 | 50.000000 | 0.000000 | 100.000000 | 0.000000 | 20.000000 |   100 |
| trail    | 0.000000 | 1.052632 | 0.000000 |  1.315789 | 3.125000 |   5.263158 | 0.000000 |  4.761905 |    20 |
| water    | 2.272727 | 2.409639 | 0.000000 |  0.000000 | 0.000000 |  11.111111 | 0.000000 |  0.000000 |     0 |
| wildlife | 0.000000 | 1.176471 | 0.000000 |  0.000000 | 3.030303 |   0.000000 | 5.504587 |  0.000000 |     0 |

``` r
outlier_mean_compare(x, "days_water", "days_cleaned", act, basin) %>%
    knitr::kable()
```

| act      | basin     | days\_water | days\_cleaned |
| :------- | :-------- | ----------: | ------------: |
| bike     | arkansas  |   23.714286 |     23.714286 |
| bike     | colorado  |    9.523810 |      9.523810 |
| bike     | metro     |    9.538462 |      9.538462 |
| bike     | n platte  |    3.500000 |      3.500000 |
| bike     | rio       |    5.000000 |      5.000000 |
| bike     | s platte  |   21.250000 |     11.366720 |
| bike     | southwest |   15.400000 |      6.352847 |
| bike     | yampa     |    8.333333 |      8.333333 |
| camp     | arkansas  |    4.171875 |      4.148882 |
| camp     | colorado  |    3.653061 |      3.387966 |
| camp     | gunnison  |    4.816326 |      4.607433 |
| camp     | metro     |    4.375000 |      2.524519 |
| camp     | n platte  |   18.310345 |      5.798406 |
| camp     | rio       |    3.269231 |      3.269231 |
| camp     | s platte  |    5.486111 |      4.361902 |
| camp     | southwest |   10.411765 |      3.978083 |
| camp     | yampa     |    3.681818 |      3.681818 |
| fish     | arkansas  |    9.524590 |      7.205865 |
| fish     | colorado  |    6.716418 |      6.654258 |
| fish     | gunnison  |    5.108108 |      4.697922 |
| fish     | metro     |    8.096774 |      5.381784 |
| fish     | n platte  |    3.428571 |      2.939775 |
| fish     | s platte  |    6.723077 |      5.889774 |
| fish     | southwest |    6.250000 |      6.250000 |
| fish     | yampa     |    6.058823 |      6.058823 |
| hunt     | arkansas  |    9.833333 |      9.833333 |
| hunt     | colorado  |    5.000000 |      5.000000 |
| hunt     | gunnison  |    3.250000 |      3.250000 |
| hunt     | n platte  |    1.666667 |      1.666667 |
| hunt     | rio       |    6.750000 |      6.750000 |
| hunt     | s platte  |    5.111111 |      5.111111 |
| hunt     | southwest |    1.333333 |      1.333333 |
| hunt     | yampa     |    7.500000 |      7.500000 |
| picnic   | arkansas  |    6.200000 |      5.530489 |
| picnic   | colorado  |    6.838235 |      5.880907 |
| picnic   | gunnison  |    2.978723 |      2.978723 |
| picnic   | metro     |   13.153846 |     12.764211 |
| picnic   | n platte  |   10.204082 |      4.644688 |
| picnic   | rio       |    4.346154 |      3.293362 |
| picnic   | s platte  |    7.491018 |      5.333579 |
| picnic   | southwest |    4.965517 |      4.965517 |
| picnic   | yampa     |    2.666667 |      2.666667 |
| snow     | arkansas  |    2.833333 |      2.833333 |
| snow     | colorado  |    2.291667 |      2.291667 |
| snow     | gunnison  |    2.750000 |      2.750000 |
| snow     | metro     |    1.500000 |      1.500000 |
| snow     | n platte  |    2.250000 |      2.250000 |
| snow     | rio       |    1.000000 |      1.000000 |
| snow     | southwest |    1.600000 |      1.146873 |
| snow     | yampa     |    5.000000 |      5.000000 |
| trail    | arkansas  |    6.745455 |      6.745455 |
| trail    | colorado  |    4.905263 |      4.862123 |
| trail    | gunnison  |    3.866667 |      3.866667 |
| trail    | metro     |   14.763158 |     13.108629 |
| trail    | n platte  |   15.593750 |      5.619853 |
| trail    | rio       |    2.684210 |      2.675557 |
| trail    | s platte  |    6.569767 |      6.569767 |
| trail    | southwest |    4.285714 |      4.036392 |
| trail    | yampa     |    2.000000 |      1.633603 |
| water    | arkansas  |    4.977273 |      4.949187 |
| water    | colorado  |    6.783132 |      6.162587 |
| water    | gunnison  |    3.437500 |      3.437500 |
| water    | metro     |    9.370370 |      9.370370 |
| water    | n platte  |    4.500000 |      4.500000 |
| water    | rio       |    4.166667 |      3.383542 |
| water    | s platte  |    7.312500 |      7.312500 |
| water    | southwest |    8.600000 |      8.600000 |
| water    | yampa     |    3.000000 |      3.000000 |
| wildlife | arkansas  |    5.953125 |      5.953125 |
| wildlife | colorado  |    6.458824 |      5.351785 |
| wildlife | gunnison  |    3.534884 |      3.534884 |
| wildlife | metro     |   10.103896 |     10.103896 |
| wildlife | n platte  |    8.303030 |      5.451567 |
| wildlife | rio       |    3.550000 |      3.550000 |
| wildlife | s platte  |    9.229358 |      6.697812 |
| wildlife | southwest |    5.000000 |      5.000000 |
| wildlife | yampa     |    2.200000 |      2.200000 |

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
    ##  9 157   trail arkansas Unchecked          NA
    ## 10 159   trail arkansas Unchecked          NA
    ## # ... with 22,157 more rows
