3-profile-oia.R
================
danka
Tue Feb 04 17:00:05 2020

``` r
# get OIA-based profiles

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
# tgtRate -----------------------------------------------------------------
# percent of whole CO resident population in the CO svy target audience

svy_oia <- readRDS("data-work/oia/oia-co.rds")
count(svy_oia, in_co_pop)
```

    ## # A tibble: 2 x 2
    ##   in_co_pop     n
    ##   <lgl>     <int>
    ## 1 FALSE       280
    ## 2 TRUE        877

``` r
svy_oia %>%
    group_by(in_co_pop) %>%
    summarise(n = n(), wtn = sum(stwt)) %>%
    mutate(pct = wtn / sum(wtn)) %>%
    knitr::kable()
```

| in\_co\_pop |   n |      wtn |       pct |
| :---------- | --: | -------: | --------: |
| FALSE       | 280 | 264.8946 | 0.2289495 |
| TRUE        | 877 | 892.1054 | 0.7710505 |
