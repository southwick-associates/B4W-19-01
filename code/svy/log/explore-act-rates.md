explore-act-rates.R
================
danka
2020-02-13

``` r
# some initial work in activity rates (screener)

library(tidyverse)
source("R/prep-svy.R") # functions
svy <- readRDS("data/interim/svy-reshape.rds")

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

    ## Warning: Factor `sex` contains implicit NA, consider using
    ## `forcats::fct_explicit_na`
    
    ## Warning: Factor `sex` contains implicit NA, consider using
    ## `forcats::fct_explicit_na`

![](explore-act-rates_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

``` r
plot_choice(svy$person, outdoor, race) + facet_wrap(~ race)
```

    ## Warning: Factor `race` contains implicit NA, consider using
    ## `forcats::fct_explicit_na`

    ## Warning: Factor `race` contains implicit NA, consider using
    ## `forcats::fct_explicit_na`

![](explore-act-rates_files/figure-gfm/unnamed-chunk-1-2.png)<!-- -->

``` r
plot_choice(svy$person, outdoor, income) + facet_wrap(~ income)
```

    ## Warning: Factor `income` contains implicit NA, consider using
    ## `forcats::fct_explicit_na`

    ## Warning: Factor `income` contains implicit NA, consider using
    ## `forcats::fct_explicit_na`

![](explore-act-rates_files/figure-gfm/unnamed-chunk-1-3.png)<!-- -->

``` r
plot_choice(svy$person, outdoor, age) + facet_wrap(~ age)
```

    ## Warning: Factor `age` contains implicit NA, consider using
    ## `forcats::fct_explicit_na`

    ## Warning: Factor `age` contains implicit NA, consider using
    ## `forcats::fct_explicit_na`

![](explore-act-rates_files/figure-gfm/unnamed-chunk-1-4.png)<!-- -->

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

![](explore-act-rates_files/figure-gfm/unnamed-chunk-1-5.png)<!-- -->
