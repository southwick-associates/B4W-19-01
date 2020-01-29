explore-act-rates.R
================
danka
Wed Jan 29 14:49:24 2020

``` r
# some initial work in activity rates (screener)

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
source("R/prep-svy.R") # functions
svy <- readRDS("data-work/1-svy/svy-reshape.rds")

# How many passed screener?
acts_of_interest <- unique(svy$basin$act)
filter(svy$act, part == "Checked", act %in% acts_of_interest) %>%
    distinct(Vrid) %>%
    nrow()
```

    ## [1] 1347

``` r
# - exclude picnicking
acts_of_interest <- setdiff(acts_of_interest, "picnic")
outdoors <- filter(svy$act, part == "Checked", act %in% acts_of_interest) %>%
    distinct(Vrid) %>%
    mutate(outdoor = "Yes")
nrow(outdoors)
```

    ## [1] 1201

``` r
# - also exclude wildlife
acts_of_interest <- setdiff(acts_of_interest, "wildlife")
outdoors <- filter(svy$act, part == "Checked", act %in% acts_of_interest) %>%
    distinct(Vrid) %>%
    mutate(outdoor = "Yes")
nrow(outdoors)
```

    ## [1] 1080

``` r
# - check by demographics
svy$person <- left_join(svy$person, outdoors, by = "Vrid") %>%
    mutate(outdoor = ifelse(is.na(outdoor), "No", outdoor))

plot_choice(svy$person, outdoor, sex) + facet_wrap(~ sex)
```

![](D:/SA/Project/B4W-19-01-CO-H2O/Analysis/code/1-svy/log/explore-act-rates_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

``` r
plot_choice(svy$person, outdoor, race) + facet_wrap(~ race)
```

![](D:/SA/Project/B4W-19-01-CO-H2O/Analysis/code/1-svy/log/explore-act-rates_files/figure-gfm/unnamed-chunk-1-2.png)<!-- -->

``` r
plot_choice(svy$person, outdoor, income) + facet_wrap(~ income)
```

![](D:/SA/Project/B4W-19-01-CO-H2O/Analysis/code/1-svy/log/explore-act-rates_files/figure-gfm/unnamed-chunk-1-3.png)<!-- -->

``` r
plot_choice(svy$person, outdoor, age) + facet_wrap(~ age)
```

![](D:/SA/Project/B4W-19-01-CO-H2O/Analysis/code/1-svy/log/explore-act-rates_files/figure-gfm/unnamed-chunk-1-4.png)<!-- -->

``` r
# checked all
# - fewer than 10 respondents did this
filter(svy$act, act != "none", part == "Checked") %>%
    count(Vrid) %>%
    count(n) %>%
    rename(activities_checked = n) %>%
    ggplot(aes(activities_checked, nn)) +
    geom_col()
```

![](D:/SA/Project/B4W-19-01-CO-H2O/Analysis/code/1-svy/log/explore-act-rates_files/figure-gfm/unnamed-chunk-1-5.png)<!-- -->
