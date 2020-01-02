Summarize CO Ipsos survey flagging of suspicious responses
================
January 02, 2020

``` r
library(tidyverse)
knitr::opts_chunk$set(comment = NA)
```

``` r
svy <- readRDS("../../data-work/1-svy/svy-reshape.rds")
flags <- readRDS("../../data-work/1-svy/svy-flag.rds")
```

Overview
--------

A set of tests were run to flag respondents for possible removal from survey analysis, based on suspicious responses. Each instance of a suspicious response is assigned a defined flag value, and flags sum (i.e., a respondent can accumulate multiple flags). We recommend removal of respondents as invalid if crossing a threshold of acceptable flags.

### Flags used

Only respondents with `Vrid == "Complete"` surveys are examined here, of which there are 1252 observations.

``` r
# drop incomplete responses
# - in case we want to look at other attributes
# svy <- lapply(svy, function(x) semi_join(x, flags$flag_values, by = "Vrid"))

# counts by flag
cnt <- flags$flag_values %>% count(flag_name)
left_join(flags$flag_details, cnt, by = "flag_name") %>%
    knitr::kable()
```

| group            | flag\_name          |  flag\_value| description                                                                                                                       |    n|
|:-----------------|:--------------------|------------:|:----------------------------------------------------------------------------------------------------------------------------------|----:|
| incomplete       | na\_days            |            3| Didn't answer question about total days                                                                                           |    4|
| incomplete       | na\_part\_water     |            3| Didn't answer the question about whether they participated along the water (i.e., missing values instead of Yes, No, or Not Sure) |   44|
| incomplete       | na\_days\_water     |            3| Didn't answer question about water days                                                                                           |    2|
| incomplete       | na\_basin           |            3| Didn't answer question about basins                                                                                               |   26|
| incomplete       | na\_basin\_days     |            3| Didn't answer question about basin-days                                                                                           |   73|
| core\_suspicious | multiple\_responses |            3| Person (identified by id) has more than one Vrid (record)                                                                         |   34|
| core\_suspicious | all\_activities     |            1| Indicated participating in every single activity                                                                                  |    5|
| core\_suspicious | all\_basins         |            1| Indicated participating in every single basin                                                                                     |    3|
| core\_suspicious | high\_days          |            1| More than 365 days identified for any activity                                                                                    |    4|
| core\_suspicious | high\_sum\_days     |            1| More than 1000 days when summed across all activities                                                                             |    4|
| suspicious       | high\_water\_days   |            1| More days along water than total days                                                                                             |   57|
| suspicious       | high\_basin\_days   |            1| Sum across basin days are &gt;5 and more than double activity total water days                                                    |   31|
| suspicious       | low\_basin\_days    |            1| Total water days are &gt;5 and sum across basin is 50% or lower than total water days                                             |  193|

### Core Flags

Core flags are those marked core\_suspicious in the first table.

``` r
flags$flag_values %>%
    filter(group == "core_suspicious") %>%
    group_by(Vrid) %>%
    summarise(flags = sum(value)) %>%
    count(flags) %>%
    mutate(cumulative_n = cumsum(n)) %>%
    knitr::kable()
```

|  flags|    n|  cumulative\_n|
|------:|----:|--------------:|
|      1|   10|             10|
|      2|    2|             12|
|      3|   35|             47|

### Missing Responses

``` r
flags$flag_values %>%
    filter(group == "incomplete") %>%
    group_by(Vrid) %>%
    summarise(flags = sum(value)) %>%
    count(flags) %>%
    mutate(cumulative_n = cumsum(n)) %>%
    knitr::kable()
```

|  flags|    n|  cumulative\_n|
|------:|----:|--------------:|
|      3|  143|            143|
|      6|    3|            146|

### Additional Suspicious Flags

``` r
flags$flag_values %>%
    filter(group == "suspicious") %>%
    group_by(Vrid) %>%
    summarise(flags = sum(value)) %>%
    count(flags) %>%
    mutate(cumulative_n = cumsum(n)) %>%
    knitr::kable()
```

|  flags|    n|  cumulative\_n|
|------:|----:|--------------:|
|      1|  151|            151|
|      2|   60|            211|
|      3|   23|            234|
|      4|   13|            247|
|      5|    2|            249|
|      6|    1|            250|

### All Flags

``` r
flags$flag_values %>%
    group_by(Vrid) %>%
    summarise(flags = sum(value)) %>%
    count(flags) %>%
    mutate(cumulative_n = cumsum(n)) %>%
    knitr::kable()
```

|  flags|    n|  cumulative\_n|
|------:|----:|--------------:|
|      1|  136|            136|
|      2|   53|            189|
|      3|  152|            341|
|      4|   24|            365|
|      5|    9|            374|
|      6|    9|            383|
|      7|    9|            392|
|      8|    1|            393|
|     10|    1|            394|
