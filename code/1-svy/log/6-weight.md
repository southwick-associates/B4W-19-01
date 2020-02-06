6-weight.R
================
danka
Thu Feb 06 12:15:03 2020

``` r
# weight survey using OIA
# - based on this template: https://github.com/southwick-associates/rakewt-ashs

library(tidyverse)
source("R/prep-svy.R")

svy <- readRDS("data-work/1-svy/svy-demo.rds")
oia <- readRDS("data-work/oia/oia-co.rds")
flags <- readRDS("data-work/1-svy/svy-flag.rds")

# Add Flags ---------------------------------------------------------------

# Respondents passing the flag threshold will be excluded from analysis (and weighting)
svy$person <- svy$person %>%
    left_join(flags$flag_totals, by = "Vrid") %>%
    mutate(flag = ifelse(is.na(flag), 0, flag))
count(svy$person, flag)
```

    ## # A tibble: 12 x 2
    ##     flag     n
    ##    <dbl> <int>
    ##  1     0   891
    ##  2     1   137
    ##  3     2    54
    ##  4     3   170
    ##  5     4    63
    ##  6     5    10
    ##  7     6     9
    ##  8     7    21
    ##  9     8     1
    ## 10     9     1
    ## 11    11     1
    ## 12    13     1

``` r
svy_wt <- filter(svy$person, flag < 4)
count(svy_wt, flag)
```

    ## # A tibble: 4 x 2
    ##    flag     n
    ##   <dbl> <int>
    ## 1     0   891
    ## 2     1   137
    ## 3     2    54
    ## 4     3   170

``` r
# Get Pop Targets ---------------------------------------------------------

# using OIA survey data for target population
pop_data <- oia %>%
    filter(in_co_pop) %>% # to match CO target pop
    select(Vrid, sex, age_weight, income_weight, race_weight, stwt)

# get population distribution targets
weight_variable_names <- setdiff(names(pop_data), c("Vrid", "stwt"))
pop <- weight_variable_names %>%
    sapply(function(x) weights::wpct(pop_data[[x]], weight = pop_data$stwt))
pop
```

    ## $sex
    ##    Male  Female 
    ## 0.51747 0.48253 
    ## 
    ## $age_weight
    ##     18-34     35-54       55+ 
    ## 0.3514503 0.3486601 0.2998896 
    ## 
    ## $income_weight
    ##      0-25K     25-35K     35-50K     50-75K    75-100K   100-150K 
    ## 0.17353726 0.09405487 0.14064324 0.18922885 0.15252025 0.16103245 
    ##      150K+ 
    ## 0.08898309 
    ## 
    ## $race_weight
    ##                 White              Hispanic Not white or Hispanic 
    ##            0.73559778            0.17719770            0.08720452

``` r
# Weight ------------------------------------------------------------------

# check: distributions of weighting variables
# - more female, older, less hispanic
sapply(names(pop), function(x) weights::wpct(svy_wt[[x]]))
```

    ## $sex
    ##      Male    Female 
    ## 0.4318374 0.5681626 
    ## 
    ## $age_weight
    ##     18-34     35-54       55+ 
    ## 0.2766497 0.2944162 0.4289340 
    ## 
    ## $income_weight
    ##      0-25K     25-35K     35-50K     50-75K    75-100K   100-150K 
    ## 0.15071973 0.12785775 0.14309907 0.20491109 0.15071973 0.15410669 
    ##      150K+ 
    ## 0.06858594 
    ## 
    ## $race_weight
    ##                 White              Hispanic Not white or Hispanic 
    ##            0.82387807            0.09652837            0.07959356

``` r
# run weighting
svy_wt <- svy_wt %>%
    est_wts(pop, print_name = "CO survey", idvar = "Vrid") %>%
    select(Vrid, weight = rake_wt)
```

    ## [1] "Raking converged in 21 iterations"
    ## 
    ## Weight Summary for CO survey -----------------------------
    ## 
    ## $convergence
    ## [1] "Complete convergence was achieved after 21 iterations"
    ## 
    ## $base.weights
    ## [1] "No Base Weights Were Used"
    ## 
    ## $raking.variables
    ## [1] "sex"           "age_weight"    "income_weight" "race_weight"  
    ## 
    ## $weight.summary
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##  0.3568  0.7408  0.9245  1.0000  1.1662  2.6893 
    ## 
    ## $selection.method
    ## [1] "variable selection conducted using _pctlim_ - discrepancies selected using _total_."
    ## 
    ## $general.design.effect
    ## [1] 1.186242
    ## 
    ## $sex
    ##         Target Unweighted N Unweighted %     Wtd N   Wtd % Change in %
    ## Male   0.51747          510    0.4318374  611.2812 0.51747  0.08563258
    ## Female 0.48253          671    0.5681626  570.0070 0.48253 -0.08563258
    ## Total  1.00000         1181    1.0000000 1181.2882 1.00000  0.17126517
    ##        Resid. Disc. Orig. Disc.
    ## Male   0.000000e+00  0.08563258
    ## Female 5.551115e-17 -0.08563258
    ## Total  5.551115e-17  0.17126517
    ## 
    ## $age_weight
    ##          Target Unweighted N Unweighted %     Wtd N     Wtd % Change in %
    ## 18-34 0.3514503          327    0.2766497  415.4143 0.3514503  0.07480056
    ## 35-54 0.3486601          348    0.2944162  412.1162 0.3486601  0.05424384
    ## 55+   0.2998896          507    0.4289340  354.4695 0.2998896 -0.12904440
    ## Total 1.0000000         1182    1.0000000 1182.0000 1.0000000  0.25808881
    ##       Resid. Disc. Orig. Disc.
    ## 18-34 0.000000e+00  0.07480056
    ## 35-54 0.000000e+00  0.05424384
    ## 55+   5.551115e-17 -0.12904440
    ## Total 5.551115e-17  0.25808881
    ## 
    ## $income_weight
    ##              Target Unweighted N Unweighted %     Wtd N      Wtd %
    ## 0-25K    0.17353726          178   0.15071973  204.9975 0.17353726
    ## 25-35K   0.09405487          151   0.12785775  111.1059 0.09405487
    ## 35-50K   0.14064324          169   0.14309907  166.1402 0.14064324
    ## 50-75K   0.18922885          242   0.20491109  223.5338 0.18922885
    ## 75-100K  0.15252025          178   0.15071973  180.1704 0.15252025
    ## 100-150K 0.16103245          182   0.15410669  190.2257 0.16103245
    ## 150K+    0.08898309           81   0.06858594  105.1147 0.08898309
    ## Total    1.00000000         1181   1.00000000 1181.2882 1.00000000
    ##           Change in %  Resid. Disc.  Orig. Disc.
    ## 0-25K     0.022817533 -5.551115e-17  0.022817533
    ## 25-35K   -0.033802878  0.000000e+00 -0.033802878
    ## 35-50K   -0.002455831  2.775558e-17 -0.002455831
    ## 50-75K   -0.015682244  0.000000e+00 -0.015682244
    ## 75-100K   0.001800522 -2.775558e-17  0.001800522
    ## 100-150K  0.006925756  0.000000e+00  0.006925756
    ## 150K+     0.020397142  0.000000e+00  0.020397142
    ## Total     0.103881906  1.110223e-16  0.103881906
    ## 
    ## $race_weight
    ##                           Target Unweighted N Unweighted %     Wtd N
    ## White                 0.73559778          973   0.82387807  868.9530
    ## Hispanic              0.17719770          114   0.09652837  209.3216
    ## Not white or Hispanic 0.08720452           94   0.07959356  103.0137
    ## Total                 1.00000000         1181   1.00000000 1181.2882
    ##                            Wtd %  Change in %  Resid. Disc.  Orig. Disc.
    ## White                 0.73559778 -0.088280289 -1.110223e-16 -0.088280289
    ## Hispanic              0.17719770  0.080669338  2.775558e-17  0.080669338
    ## Not white or Hispanic 0.08720452  0.007610952  0.000000e+00  0.007610952
    ## Total                 1.00000000  0.176560579  1.387779e-16  0.176560579

``` r
svy$person <- left_join(svy$person, svy_wt, by = "Vrid")

# check
summary(svy$person$weight)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.3568  0.7408  0.9245  1.0000  1.1662  2.6893     107

``` r
sapply(names(pop), function(x) weights::wpct(svy$person[[x]], svy$person$weight))
```

    ## $sex
    ##    Male  Female 
    ## 0.51747 0.48253 
    ## 
    ## $age_weight
    ##     18-34     35-54       55+ 
    ## 0.3514503 0.3486601 0.2998896 
    ## 
    ## $income_weight
    ##      0-25K     25-35K     35-50K     50-75K    75-100K   100-150K 
    ## 0.17353726 0.09405487 0.14064324 0.18922885 0.15252025 0.16103245 
    ##      150K+ 
    ## 0.08898309 
    ## 
    ## $race_weight
    ##                 White              Hispanic Not white or Hispanic 
    ##            0.73559778            0.17719770            0.08720452

``` r
# Save --------------------------------------------------------------------

glimpse(svy$person)
```

    ## Observations: 1,359
    ## Variables: 12
    ## $ Vrid          <chr> "98", "99", "100", "101", "102", "103", "104", "...
    ## $ id            <chr> "C2058317730", "C2058321874", "C2058323362", "C2...
    ## $ Vstatus       <chr> "Complete", "Complete", "Partial", "Complete", "...
    ## $ sex           <fct> Female, Female, NA, Male, Female, Male, Female, ...
    ## $ race          <fct> White, Other, NA, White, Black/African-American,...
    ## $ race_other    <chr> "", "unecessary question", "", "", "", "", "", "...
    ## $ hispanic      <fct> No, No, NA, No, No, No, No, No, No, Yes, Yes, No...
    ## $ age_weight    <fct> 35-54, 35-54, NA, 35-54, 35-54, 18-34, 55+, 18-3...
    ## $ income_weight <fct> 0-25K, 0-25K, NA, 25-35K, 50-75K, 25-35K, 75-100...
    ## $ race_weight   <fct> White, Not white or Hispanic, NA, White, Not whi...
    ## $ flag          <dbl> 0, 0, 3, 0, 0, 0, 6, 0, 0, 0, 1, 2, 1, 0, 0, 0, ...
    ## $ weight        <dbl> 0.9596845, 1.0899973, 1.0000000, 0.8747500, 0.96...

``` r
saveRDS(svy, "data-work/1-svy/svy-weight.rds")

# save as csvs (for Eric)
outdir <- "data-work/1-svy/svy-weight-csv"
sapply(names(svy), function(nm) {
    write_list_csv(svy, nm, outdir)
})
```

    ## $person
    ## # A tibble: 1,359 x 12
    ##    Vrid  id    Vstatus sex   race  race_other hispanic age_weight
    ##    <chr> <chr> <chr>   <fct> <fct> <chr>      <fct>    <fct>     
    ##  1 98    C205~ Comple~ Fema~ White ""         No       35-54     
    ##  2 99    C205~ Comple~ Fema~ Other unecessar~ No       35-54     
    ##  3 100   C205~ Partial <NA>  <NA>  ""         <NA>     <NA>      
    ##  4 101   C205~ Comple~ Male  White ""         No       35-54     
    ##  5 102   C205~ Comple~ Fema~ Blac~ ""         No       35-54     
    ##  6 103   C205~ Comple~ Male  White ""         No       18-34     
    ##  7 104   C205~ Comple~ Fema~ White ""         No       55+       
    ##  8 105   C205~ Comple~ Male  White ""         No       18-34     
    ##  9 106   C205~ Comple~ Fema~ Blac~ ""         No       35-54     
    ## 10 107   C205~ Comple~ Male  White ""         Yes      35-54     
    ## # ... with 1,349 more rows, and 4 more variables: income_weight <fct>,
    ## #   race_weight <fct>, flag <dbl>, weight <dbl>
    ## 
    ## $act
    ## # A tibble: 19,026 x 7
    ##    Vrid  act   is_targeted part       days part_water days_water
    ##    <chr> <chr> <lgl>       <chr>     <dbl> <chr>           <dbl>
    ##  1 98    trail TRUE        Unchecked    NA <NA>               NA
    ##  2 99    trail TRUE        Unchecked    NA <NA>               NA
    ##  3 100   trail TRUE        Unchecked    NA <NA>               NA
    ##  4 101   trail TRUE        Unchecked    NA <NA>               NA
    ##  5 102   trail TRUE        Unchecked    NA <NA>               NA
    ##  6 103   trail TRUE        Unchecked    NA <NA>               NA
    ##  7 104   trail TRUE        Unchecked    NA <NA>               NA
    ##  8 105   trail TRUE        Unchecked    NA <NA>               NA
    ##  9 106   trail TRUE        Unchecked    NA <NA>               NA
    ## 10 107   trail TRUE        Checked      15 Yes                10
    ## # ... with 19,016 more rows
    ## 
    ## $basin
    ## # A tibble: 24,174 x 5
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
    ## # ... with 24,164 more rows
