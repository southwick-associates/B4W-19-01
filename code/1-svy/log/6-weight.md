6-weight.R
================
danka
Wed Jan 29 17:15:40 2020

``` r
# weight survey using OIA
# - based on this template: https://github.com/southwick-associates/rakewt-ashs

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
library(weights)
```

    ## Loading required package: Hmisc

    ## Loading required package: lattice

    ## Loading required package: survival

    ## Loading required package: Formula

    ## 
    ## Attaching package: 'Hmisc'

    ## The following objects are masked from 'package:dplyr':
    ## 
    ##     src, summarize

    ## The following objects are masked from 'package:base':
    ## 
    ##     format.pval, units

    ## Loading required package: gdata

    ## gdata: Unable to locate valid perl interpreter
    ## gdata: 
    ## gdata: read.xls() will be unable to read Excel XLS and XLSX files
    ## gdata: unless the 'perl=' argument is used to specify the location
    ## gdata: of a valid perl intrpreter.
    ## gdata: 
    ## gdata: (To avoid display of this message in the future, please
    ## gdata: ensure perl is installed and available on the executable
    ## gdata: search path.)

    ## gdata: Unable to load perl libaries needed by read.xls()
    ## gdata: to support 'XLX' (Excel 97-2004) files.

    ## 

    ## gdata: Unable to load perl libaries needed by read.xls()
    ## gdata: to support 'XLSX' (Excel 2007+) files.

    ## 

    ## gdata: Run the function 'installXLSXsupport()'
    ## gdata: to automatically download and install the perl
    ## gdata: libaries needed to support Excel XLS and XLSX formats.

    ## 
    ## Attaching package: 'gdata'

    ## The following objects are masked from 'package:dplyr':
    ## 
    ##     combine, first, last

    ## The following object is masked from 'package:purrr':
    ## 
    ##     keep

    ## The following object is masked from 'package:stats':
    ## 
    ##     nobs

    ## The following object is masked from 'package:utils':
    ## 
    ##     object.size

    ## The following object is masked from 'package:base':
    ## 
    ##     startsWith

    ## Loading required package: mice

    ## 
    ## Attaching package: 'mice'

    ## The following object is masked from 'package:tidyr':
    ## 
    ##     complete

    ## The following objects are masked from 'package:base':
    ## 
    ##     cbind, rbind

``` r
library(anesrake)
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

    ## # A tibble: 9 x 2
    ##    flag     n
    ##   <dbl> <int>
    ## 1     0   965
    ## 2     1   136
    ## 3     2    53
    ## 4     3   126
    ## 5     4    55
    ## 6     5     8
    ## 7     6     5
    ## 8     7    10
    ## 9     9     1

``` r
svy_wt <- filter(svy$person, flag < 4)
count(svy_wt, flag)
```

    ## # A tibble: 4 x 2
    ##    flag     n
    ##   <dbl> <int>
    ## 1     0   965
    ## 2     1   136
    ## 3     2    53
    ## 4     3   126

``` r
# Get Pop Targets ---------------------------------------------------------

# using OIA survey data for target population
pop_data <- oia %>%
    filter(in_co_pop) %>% # to match CO target pop
    select(Vrid, sex, age_weight, income_weight, race_weight, stwt)

# get population distribution targets
weight_variable_names <- setdiff(names(pop_data), c("Vrid", "stwt"))
pop <- weight_variable_names %>%
    sapply(function(x) wpct(pop_data[[x]], weight = pop_data$stwt))
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
    ## 0.4312236 0.5687764 
    ## 
    ## $age_weight
    ##     18-34     35-54       55+ 
    ## 0.2757167 0.2934233 0.4308600 
    ## 
    ## $income_weight
    ##      0-25K     25-35K     35-50K     50-75K    75-100K   100-150K 
    ## 0.15105485 0.12742616 0.14261603 0.20421941 0.15189873 0.15443038 
    ##      150K+ 
    ## 0.06835443 
    ## 
    ## $race_weight
    ##                 White              Hispanic Not white or Hispanic 
    ##            0.82447257            0.09620253            0.07932489

``` r
# run weighting
svy_wt <- mutate(svy_wt, Vrid = as.integer(Vrid)) %>% data.frame()
svy_wt <- svy_wt %>%
    est_wts(pop, print_name = "CO survey", idvar = "Vrid") %>%
    mutate(Vrid = as.character(Vrid)) %>%
    select(Vrid, weight = rake_wt)
```

    ## [1] "Raking converged in 22 iterations"
    ## 
    ## Weight Summary for CO survey -----------------------------
    ## 
    ## $convergence
    ## [1] "Complete convergence was achieved after 22 iterations"
    ## 
    ## $base.weights
    ## [1] "No Base Weights Were Used"
    ## 
    ## $raking.variables
    ## [1] "sex"           "age_weight"    "income_weight" "race_weight"  
    ## 
    ## $weight.summary
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##  0.3553  0.7402  0.9321  1.0000  1.1666  2.6919 
    ## 
    ## $selection.method
    ## [1] "variable selection conducted using _pctlim_ - discrepancies selected using _total_."
    ## 
    ## $general.design.effect
    ## [1] 1.185323
    ## 
    ## $sex
    ##         Target Unweighted N Unweighted %     Wtd N   Wtd % Change in %
    ## Male   0.51747          511    0.4312236  613.3526 0.51747  0.08624638
    ## Female 0.48253          674    0.5687764  571.9385 0.48253 -0.08624638
    ## Total  1.00000         1185    1.0000000 1185.2911 1.00000  0.17249276
    ##        Resid. Disc. Orig. Disc.
    ## Male   0.000000e+00  0.08624638
    ## Female 5.551115e-17 -0.08624638
    ## Total  5.551115e-17  0.17249276
    ## 
    ## $age_weight
    ##          Target Unweighted N Unweighted %     Wtd N     Wtd % Change in %
    ## 18-34 0.3514503          327    0.2757167  416.8201 0.3514503  0.07573361
    ## 35-54 0.3486601          348    0.2934233  413.5109 0.3486601  0.05523681
    ## 55+   0.2998896          511    0.4308600  355.6691 0.2998896 -0.13097043
    ## Total 1.0000000         1186    1.0000000 1186.0000 1.0000000  0.26194086
    ##        Resid. Disc. Orig. Disc.
    ## 18-34  5.551115e-17  0.07573361
    ## 35-54  0.000000e+00  0.05523681
    ## 55+   -5.551115e-17 -0.13097043
    ## Total  1.110223e-16  0.26194086
    ## 
    ## $income_weight
    ##              Target Unweighted N Unweighted %     Wtd N      Wtd %
    ## 0-25K    0.17353726          179   0.15105485  205.6922 0.17353726
    ## 25-35K   0.09405487          151   0.12742616  111.4824 0.09405487
    ## 35-50K   0.14064324          169   0.14261603  166.7032 0.14064324
    ## 50-75K   0.18922885          242   0.20421941  224.2913 0.18922885
    ## 75-100K  0.15252025          180   0.15189873  180.7809 0.15252025
    ## 100-150K 0.16103245          183   0.15443038  190.8703 0.16103245
    ## 150K+    0.08898309           81   0.06835443  105.4709 0.08898309
    ## Total    1.00000000         1185   1.00000000 1185.2911 1.00000000
    ##            Change in % Resid. Disc.   Orig. Disc.
    ## 0-25K     0.0224824100 2.775558e-17  0.0224824100
    ## 25-35K   -0.0333712910 0.000000e+00 -0.0333712910
    ## 35-50K   -0.0019727958 0.000000e+00 -0.0019727958
    ## 50-75K   -0.0149905612 2.775558e-17 -0.0149905612
    ## 75-100K   0.0006215164 0.000000e+00  0.0006215164
    ## 100-150K  0.0066020655 2.775558e-17  0.0066020655
    ## 150K+     0.0206286561 1.387779e-17  0.0206286561
    ## Total     0.1006692961 9.714451e-17  0.1006692961
    ## 
    ## $race_weight
    ##                           Target Unweighted N Unweighted %     Wtd N
    ## White                 0.73559778          977   0.82447257  871.8975
    ## Hispanic              0.17719770          114   0.09620253  210.0309
    ## Not white or Hispanic 0.08720452           94   0.07932489  103.3627
    ## Total                 1.00000000         1185   1.00000000 1185.2911
    ##                            Wtd %  Change in % Resid. Disc.  Orig. Disc.
    ## White                 0.73559778 -0.088874794            0 -0.088874794
    ## Hispanic              0.17719770  0.080995172            0  0.080995172
    ## Not white or Hispanic 0.08720452  0.007879622            0  0.007879622
    ## Total                 1.00000000  0.177749588            0  0.177749588

``` r
svy$person <- left_join(svy$person, svy_wt, by = "Vrid")
```

    ## Warning: Column `Vrid` has different attributes on LHS and RHS of join

``` r
# check
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
    ## $ flag          <dbl> 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 1, 2, 1, 0, 0, 0, ...
    ## $ weight        <dbl> 0.9602946, 1.0924058, 1.0000000, 0.8796073, 0.96...

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
    ##  9 152   trail arkansas Unchecked          NA
    ## 10 157   trail arkansas Unchecked          NA
    ## # ... with 24,164 more rows
