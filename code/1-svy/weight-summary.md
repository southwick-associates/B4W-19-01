Summarize CO survey weighting
================
January 31, 2020

``` r
library(tidyverse)
source("../../R/results.R")
```

## Overview

There was a small amount of skew between the CO survey (valid)
respondents and the target population defined using the OIA survey
dataset:

``` r
svy <- readRDS("../../data-work/1-svy/svy-weight.rds")
pop_data <- readRDS("../../data-work/oia/oia-co.rds") %>% filter(in_co_pop)
weight_variable_names <- c("sex", "age_weight", "income_weight", "race_weight")
```

### Weight Summary

``` r
summary(svy$person$weight)
```

``` 
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
 0.3568  0.7408  0.9245  1.0000  1.1662  2.6893     107 
```
