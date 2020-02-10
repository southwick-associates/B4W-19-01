Summarize CO survey flagging of suspicious responses
================
February 10, 2020

``` r
library(tidyverse)

svy_all <- readRDS("../../data/interim/svy-reshape.rds")
svy <- readRDS("../../data/interim/svy-clean.rds")
flags <- readRDS("../../data/interim/svy-flag.rds")

# a few "none" activity people are dropped from the flag table
# (they were filtered out in the 4-clean step since they shouldn't have gotten the survey)
flags$flag_values <- flags$flag_values %>%
    semi_join(svy$person, by = "Vrid")
```

## Overview

A set of tests were run to flag respondents for possible removal from
survey analysis, based on suspicious responses. Each instance of a
suspicious response is assigned a defined flag value, and flags sum
(i.e., a respondent can accumulate multiple flags).

### Flags used

``` r
# counts by flag
cnt <- flags$flag_values %>% count(flag_name)
left_join(flags$flag_details, cnt, by = "flag_name") %>%
    knitr::kable()
```

| group            | flag\_name          | flag\_value | description                                                                                                                       |   n |
| :--------------- | :------------------ | ----------: | :-------------------------------------------------------------------------------------------------------------------------------- | --: |
| incomplete       | na\_days            |           3 | Didn’t answer question about total days                                                                                           |  32 |
| incomplete       | na\_part\_water     |           3 | Didn’t answer the question about whether they participated along the water (i.e., missing values instead of Yes, No, or Not Sure) |  50 |
| incomplete       | na\_days\_water     |           3 | Didn’t answer question about water days                                                                                           |   7 |
| incomplete       | na\_basin           |           3 | Didn’t answer question about basins                                                                                               |  48 |
| incomplete       | na\_basin\_days     |           3 | Didn’t answer question about basin-days                                                                                           |  83 |
| core\_suspicious | multiple\_responses |           4 | Person (identified by id) has more than one Vrid (record)                                                                         |  54 |
| core\_suspicious | all\_activities     |           1 | Indicated participating in every single activity                                                                                  |   6 |
| core\_suspicious | all\_basins         |           1 | Indicated participating in every single basin                                                                                     |   3 |
| core\_suspicious | high\_days          |           1 | More than 365 days identified for any activity                                                                                    |   5 |
| core\_suspicious | high\_sum\_days     |           1 | More than 1000 days when summed across all activities                                                                             |   5 |
| suspicious       | high\_water\_days   |           1 | More days along water than total days                                                                                             |  60 |
| suspicious       | high\_basin\_days   |           1 | Sum across basin days are \>5 and more than double activity total water days                                                      |  31 |
| suspicious       | low\_basin\_days    |           1 | Total water days are \>5 and sum across basin is 50% or lower than total water days                                               | 191 |

### Core Flags

Core flags are those marked core\_suspicious in the first table.

``` r
flags$flag_values %>%
    filter(group == "core_suspicious") %>%
    group_by(Vrid) %>%
    summarise(flags = sum(value)) %>%
    count(flags) %>%
    arrange(desc(flags)) %>%
    mutate(cumulative_n = cumsum(n)) %>%
    knitr::kable()
```

| flags |  n | cumulative\_n |
| ----: | -: | ------------: |
|     4 | 54 |            54 |
|     3 |  1 |            55 |
|     2 |  3 |            58 |
|     1 | 11 |            69 |

### Missing Responses

``` r
flags$flag_values %>%
    filter(group == "incomplete") %>%
    group_by(Vrid) %>%
    summarise(flags = sum(value)) %>%
    count(flags) %>%
    arrange(desc(flags)) %>%
    mutate(cumulative_n = cumsum(n)) %>%
    knitr::kable()
```

| flags |   n | cumulative\_n |
| ----: | --: | ------------: |
|     9 |   1 |             1 |
|     6 |   7 |             8 |
|     3 | 203 |           211 |

### Additional Suspicious Flags

``` r
flags$flag_values %>%
    filter(group == "suspicious") %>%
    group_by(Vrid) %>%
    summarise(flags = sum(value)) %>%
    count(flags) %>%
    arrange(desc(flags)) %>%
    mutate(cumulative_n = cumsum(n)) %>%
    knitr::kable()
```

| flags |   n | cumulative\_n |
| ----: | --: | ------------: |
|     8 |   1 |             1 |
|     6 |   1 |             2 |
|     5 |   2 |             4 |
|     4 |  10 |            14 |
|     3 |  21 |            35 |
|     2 |  60 |            95 |
|     1 | 156 |           251 |

### All Flags

Respondents with 4 or more flags are intended to be excluded.

``` r
flags$flag_values %>%
    group_by(Vrid) %>%
    summarise(flags = sum(value)) %>%
    count(flags) %>%
    arrange(desc(flags)) %>%
    mutate(cumulative_n = cumsum(n)) %>%
    knitr::kable()
```

| flags |   n | cumulative\_n |
| ----: | --: | ------------: |
|    13 |   1 |             1 |
|    11 |   1 |             2 |
|     9 |   1 |             3 |
|     8 |   1 |             4 |
|     7 |  21 |            25 |
|     6 |   9 |            34 |
|     5 |  10 |            44 |
|     4 |  63 |           107 |
|     3 | 170 |           277 |
|     2 |  54 |           331 |
|     1 | 137 |           468 |

## Exclusion Summary

Respondents are flagged as invalid and exluded if crossing a threshold
of acceptable flags:

``` r
# all unique respondents to the survey
svy_all$person %>%
    distinct(id) %>% 
    nrow()
```

    [1] 1341

``` r
# valid respondents used for analysis
valid <- svy$person %>%
    left_join(flags$flag_totals, by = "Vrid") %>%
    filter(flag < 4 | is.na(flag)) 
valid %>%
    distinct(id) %>%
    nrow()
```

    [1] 1252

``` r
# note that not all of the valid respondents are marked as complete
count(valid, Vstatus)
```

    # A tibble: 3 x 2
      Vstatus          n
      <chr>        <int>
    1 Complete      1169
    2 Disqualified    12
    3 Partial         71
