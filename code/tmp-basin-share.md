Getting basin share of days
================
February 07, 2020

``` r
library(tidyverse)
svy <- readRDS("../data-work/1-svy/svy-final.rds")
svy$basin <- svy$basin %>%
    left_join(select(svy$person, Vrid, weight))
```

## Calculate Share

``` r
# basinRate(AB): basin rate for activity participants
rate <- svy$basin %>%
    group_by(act, basin, part_water) %>%
    summarise(wtn = sum(weight)) %>%
    mutate(part_rate = wtn / sum(wtn)) %>%
    filter(part_water == "Checked")

# avgDays(AB): average basin days (for those who visit the basin)
avgDays <- svy$basin %>%
    filter(!is.na(days_water), part_water == "Checked") %>%
    group_by(act, basin) %>%
    summarise(avgDays = weighted.mean(days_water, weight), n = n())

# daysShare(AB): share of activity days for each basin
# - so spend(AB) = spend(A) * daysShare(AB)
share <- avgDays %>%
    left_join(select(rate, act, basin, part_rate)) %>%
    mutate(
        days_per_participant = avgDays * part_rate,
        share = days_per_participant / sum(days_per_participant)
    )
```

    Joining, by = c("act", "basin")

## Plot

``` r
share %>%
    ggplot(aes(basin, share)) +
    geom_col() +
    coord_flip() +
    facet_wrap(~ act)
```

![](tmp-basin-share_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

## Profile Table

``` r
select(share, act, basin, share) %>%
    spread(act, share, fill = 0) %>%
    knitr::kable()
```

| basin     |      bike |      camp |      fish |      hunt |    picnic |      snow |     trail |     water |  wildlife |
| :-------- | --------: | --------: | --------: | --------: | --------: | --------: | --------: | --------: | --------: |
| arkansas  | 0.1287521 | 0.1657905 | 0.2157281 | 0.1545586 | 0.1192956 | 0.1349700 | 0.1353536 | 0.1030372 | 0.1069636 |
| colorado  | 0.2284849 | 0.2302293 | 0.2527684 | 0.4007525 | 0.1844713 | 0.4689294 | 0.1750225 | 0.2756582 | 0.1861341 |
| gunnison  | 0.0000000 | 0.1276350 | 0.0881599 | 0.0757516 | 0.0255149 | 0.1993321 | 0.0472408 | 0.0275496 | 0.0426007 |
| metro     | 0.2630196 | 0.0423172 | 0.0985797 | 0.0000000 | 0.3907454 | 0.0201286 | 0.3206465 | 0.2439325 | 0.3176100 |
| n platte  | 0.0243366 | 0.0919978 | 0.0398977 | 0.0187821 | 0.0447332 | 0.0681726 | 0.0672418 | 0.0532517 | 0.0583175 |
| rio       | 0.0071504 | 0.0668055 | 0.0000000 | 0.0908728 | 0.0214129 | 0.0133043 | 0.0229406 | 0.0376615 | 0.0242727 |
| s platte  | 0.2982713 | 0.1736100 | 0.2145330 | 0.1231031 | 0.1709940 | 0.0000000 | 0.1934240 | 0.1503859 | 0.2202409 |
| southwest | 0.0341483 | 0.0508077 | 0.0389720 | 0.0101591 | 0.0303788 | 0.0390964 | 0.0321325 | 0.0805357 | 0.0311355 |
| yampa     | 0.0158368 | 0.0508070 | 0.0513611 | 0.1260202 | 0.0124538 | 0.0560665 | 0.0059977 | 0.0279877 | 0.0127250 |

## Check

``` r
summarise(share, sum(share)) %>%
    knitr::kable(caption = "Check sums")
```

| act      | sum(share) |
| :------- | ---------: |
| bike     |          1 |
| camp     |          1 |
| fish     |          1 |
| hunt     |          1 |
| picnic   |          1 |
| snow     |          1 |
| trail    |          1 |
| water    |          1 |
| wildlife |          1 |

Check sums

``` r
share %>%
    select(act, basin, n) %>%
    spread(act, n, fill = 0) %>%
    knitr::kable(caption = "Sample sizes")
```

| basin     | bike | camp | fish | hunt | picnic | snow | trail | water | wildlife |
| :-------- | ---: | ---: | ---: | ---: | -----: | ---: | ----: | ----: | -------: |
| arkansas  |   14 |   64 |   61 |    6 |    110 |    6 |    55 |    44 |       64 |
| colorado  |   42 |   98 |   67 |   16 |    136 |   24 |    95 |    83 |       85 |
| gunnison  |    0 |   49 |   37 |    4 |     47 |    8 |    30 |    16 |       43 |
| metro     |   52 |   24 |   31 |    0 |    117 |    2 |    76 |    54 |       77 |
| n platte  |   12 |   29 |   28 |    3 |     49 |    4 |    32 |    24 |       33 |
| rio       |    2 |   26 |    0 |    4 |     26 |    2 |    19 |    18 |       20 |
| s platte  |   48 |   72 |   65 |    9 |    167 |    0 |    86 |    48 |      109 |
| southwest |    5 |   17 |   12 |    3 |     29 |    5 |    21 |    15 |       20 |
| yampa     |    3 |   22 |   17 |    4 |     27 |    1 |    10 |    16 |       20 |

Sample sizes
