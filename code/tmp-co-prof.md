Temporary CO profile testing
================
February 04, 2020

``` r
library(tidyverse)
svy <- readRDS("../data-work/1-svy/svy-final.rds")
```

## svyRate

These match with Eric’s numbers

``` r
vrid_wt <- select(svy$person, Vrid, weight)
act <- left_join(svy$act, vrid_wt) %>% filter(is_targeted)

group_by(act, act, part) %>%
    summarise(n = n(), wtn = sum(weight)) %>%
    mutate(pct = wtn / sum(wtn), n = sum(n)) %>%
    filter(part == "Checked") %>%
    knitr::kable()
```

| act      | part    |    n |      wtn |       pct |
| :------- | :------ | ---: | -------: | --------: |
| bike     | Checked | 1252 | 380.9056 | 0.3042377 |
| camp     | Checked | 1252 | 469.1150 | 0.3746925 |
| fish     | Checked | 1252 | 323.0581 | 0.2580336 |
| hunt     | Checked | 1252 | 173.1653 | 0.1383110 |
| picnic   | Checked | 1252 | 869.8705 | 0.6947848 |
| snow     | Checked | 1252 | 309.3007 | 0.2470453 |
| trail    | Checked | 1252 | 452.4672 | 0.3613955 |
| water    | Checked | 1252 | 377.2966 | 0.3013551 |
| wildlife | Checked | 1252 | 483.8532 | 0.3864642 |

## waterRate

These look similar to Eric’s, but a bit different, particularly for
fishing and watersports. A couple notes:

  - Water sports not being 100% might be expected for things like
    swimming: Some people might only do that in pools.

  - People who say “Not Sure” are treated as “No” for water-level
    participation.

<!-- end list -->

``` r
filter(act, part == "Checked", !is.na(part_water)) %>%
    group_by(act, part_water) %>%
    summarise(n = n(), wtn = sum(weight)) %>%
    mutate(pct = wtn / sum(wtn), n = sum(n)) %>%
    filter(part_water == "Yes") %>%
    knitr::kable()
```

| act      | part\_water |   n |       wtn |       pct |
| :------- | :---------- | --: | --------: | --------: |
| bike     | Yes         | 337 | 186.72549 | 0.5149804 |
| camp     | Yes         | 442 | 331.38768 | 0.7379542 |
| fish     | Yes         | 314 | 318.10165 | 0.9846577 |
| hunt     | Yes         | 147 |  65.68586 | 0.4112829 |
| picnic   | Yes         | 854 | 600.26192 | 0.7332387 |
| snow     | Yes         | 273 |  85.73437 | 0.2909739 |
| trail    | Yes         | 390 | 312.12420 | 0.7320933 |
| water    | Yes         | 366 | 334.34136 | 0.8861501 |
| wildlife | Yes         | 472 | 340.80883 | 0.7652043 |
