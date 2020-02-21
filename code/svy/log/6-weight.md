6-weight.R
================
danka
2020-02-21

``` r
# weight survey using OIA

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
library(sastats)

outfile_svy <- "data/interim/svy-weight.rds" # updated svy data frame
outfile_wt <- "data/interim/svy-weight-object.rds" # list returned by sastats::rake_weight()
    
svy <- readRDS("data/interim/svy-demo.rds")
oia <- readRDS("data/interim/oia-co.rds")
flags <- readRDS("data/interim/svy-flag.rds")

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
wt_vars <- setdiff(names(pop_data), c("Vrid", "stwt"))
pop <- sapply(wt_vars, function(x) weights::wpct(pop_data[[x]], pop_data$stwt))
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
    ##      0-25K     25-35K     35-50K     50-75K    75-100K   100-150K      150K+ 
    ## 0.17353726 0.09405487 0.14064324 0.18922885 0.15252025 0.16103245 0.08898309 
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
    ##      0-25K     25-35K     35-50K     50-75K    75-100K   100-150K      150K+ 
    ## 0.15071973 0.12785775 0.14309907 0.20491109 0.15071973 0.15410669 0.06858594 
    ## 
    ## $race_weight
    ##                 White              Hispanic Not white or Hispanic 
    ##            0.82387807            0.09652837            0.07959356

``` r
# run weighting
rake_output <- rake_weight(svy_wt, pop, "Vrid")
```

    ## [1] "Raking converged in 21 iterations"

``` r
svy_wt <- select(rake_output$svy, Vrid, weight)
svy$person <- left_join(svy$person, svy_wt, by = "Vrid")

# check - should show TRUE
x <- sapply(names(pop), function(x) weights::wpct(svy$person[[x]], svy$person$weight))
all.equal(x, pop)
```

    ## [1] TRUE

``` r
# Save --------------------------------------------------------------------

saveRDS(svy, outfile_svy)
saveRDS(rake_output, outfile_wt)

# summarize
glimpse(svy$person)
```

    ## Observations: 1,359
    ## Variables: 12
    ## $ Vrid          <chr> "98", "99", "100", "101", "102", "103", "104", "105", "106", "...
    ## $ id            <chr> "C2058317730", "C2058321874", "C2058323362", "C2058324714", "C...
    ## $ Vstatus       <chr> "Complete", "Complete", "Partial", "Complete", "Complete", "Co...
    ## $ sex           <fct> Female, Female, NA, Male, Female, Male, Female, Male, Female, ...
    ## $ race          <fct> White, Other, NA, White, Black/African-American, White, White,...
    ## $ race_other    <chr> "", "unecessary question", "", "", "", "", "", "", "", "", "",...
    ## $ hispanic      <fct> No, No, NA, No, No, No, No, No, No, Yes, Yes, No, Yes, No, No,...
    ## $ age_weight    <fct> 35-54, 35-54, NA, 35-54, 35-54, 18-34, 55+, 18-34, 35-54, 35-5...
    ## $ income_weight <fct> 0-25K, 0-25K, NA, 25-35K, 50-75K, 25-35K, 75-100K, 50-75K, 35-...
    ## $ race_weight   <fct> White, Not white or Hispanic, NA, White, Not white or Hispanic...
    ## $ flag          <dbl> 0, 0, 3, 0, 0, 0, 6, 0, 0, 0, 1, 2, 1, 0, 0, 0, 3, 1, 0, 0, 0,...
    ## $ weight        <dbl> 0.9596845, 1.0899973, 1.0000000, 0.8747500, 0.9641894, 0.92452...

``` r
summary(rake_output$wts)
```

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
    ##         Target Unweighted N Unweighted %     Wtd N   Wtd % Change in % Resid. Disc.
    ## Male   0.51747          510    0.4318374  611.2812 0.51747  0.08563258 0.000000e+00
    ## Female 0.48253          671    0.5681626  570.0070 0.48253 -0.08563258 5.551115e-17
    ## Total  1.00000         1181    1.0000000 1181.2882 1.00000  0.17126517 5.551115e-17
    ##        Orig. Disc.
    ## Male    0.08563258
    ## Female -0.08563258
    ## Total   0.17126517
    ## 
    ## $age_weight
    ##          Target Unweighted N Unweighted %     Wtd N     Wtd % Change in % Resid. Disc.
    ## 18-34 0.3514503          327    0.2766497  415.4143 0.3514503  0.07480056 0.000000e+00
    ## 35-54 0.3486601          348    0.2944162  412.1162 0.3486601  0.05424384 0.000000e+00
    ## 55+   0.2998896          507    0.4289340  354.4695 0.2998896 -0.12904440 5.551115e-17
    ## Total 1.0000000         1182    1.0000000 1182.0000 1.0000000  0.25808881 5.551115e-17
    ##       Orig. Disc.
    ## 18-34  0.07480056
    ## 35-54  0.05424384
    ## 55+   -0.12904440
    ## Total  0.25808881
    ## 
    ## $income_weight
    ##              Target Unweighted N Unweighted %     Wtd N      Wtd %  Change in %
    ## 0-25K    0.17353726          178   0.15071973  204.9975 0.17353726  0.022817533
    ## 25-35K   0.09405487          151   0.12785775  111.1059 0.09405487 -0.033802878
    ## 35-50K   0.14064324          169   0.14309907  166.1402 0.14064324 -0.002455831
    ## 50-75K   0.18922885          242   0.20491109  223.5338 0.18922885 -0.015682244
    ## 75-100K  0.15252025          178   0.15071973  180.1704 0.15252025  0.001800522
    ## 100-150K 0.16103245          182   0.15410669  190.2257 0.16103245  0.006925756
    ## 150K+    0.08898309           81   0.06858594  105.1147 0.08898309  0.020397142
    ## Total    1.00000000         1181   1.00000000 1181.2882 1.00000000  0.103881906
    ##           Resid. Disc.  Orig. Disc.
    ## 0-25K    -5.551115e-17  0.022817533
    ## 25-35K    0.000000e+00 -0.033802878
    ## 35-50K    2.775558e-17 -0.002455831
    ## 50-75K    0.000000e+00 -0.015682244
    ## 75-100K  -2.775558e-17  0.001800522
    ## 100-150K  0.000000e+00  0.006925756
    ## 150K+     0.000000e+00  0.020397142
    ## Total     1.110223e-16  0.103881906
    ## 
    ## $race_weight
    ##                           Target Unweighted N Unweighted %     Wtd N      Wtd %
    ## White                 0.73559778          973   0.82387807  868.9530 0.73559778
    ## Hispanic              0.17719770          114   0.09652837  209.3216 0.17719770
    ## Not white or Hispanic 0.08720452           94   0.07959356  103.0137 0.08720452
    ## Total                 1.00000000         1181   1.00000000 1181.2882 1.00000000
    ##                        Change in %  Resid. Disc.  Orig. Disc.
    ## White                 -0.088280289 -1.110223e-16 -0.088280289
    ## Hispanic               0.080669338  2.775558e-17  0.080669338
    ## Not white or Hispanic  0.007610952  0.000000e+00  0.007610952
    ## Total                  0.176560579  1.387779e-16  0.176560579
