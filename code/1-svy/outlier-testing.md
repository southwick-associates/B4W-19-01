Test outlier identification with Tukey’s Rule
================
January 31, 2020

``` r
library(tidyverse)
source("../../R/outliers.R")
svy <- readRDS("../../data-work/1-svy/svy-weight.rds")
```

## Tukey’s Test

We can apply [Tukey’s
test](https://en.wikipedia.org/wiki/Outlier#Tukey%27s_fences) to
identify outliers for overall days by activity. We end up with a rule
that is very aggressive in identifying outliers.

``` r
# only looking at days greater than zero
days <- svy$act %>% 
    filter(is_targeted, !is.na(days), days > 0)

# identify outliers
x <- days %>%
    group_by(act) %>%
    mutate(is_outlier = tukey_outlier(days)) %>%
    ungroup()

# plot
ggplot(x, aes(act, days)) +
    geom_boxplot(outlier.size = -1) +
    geom_point(data = count(x, act, days, is_outlier), aes(size = n, color = is_outlier)) +
    scale_color_manual(values = c("gray", "red")) +
    ggtitle("Tukey's test")
```

![](outlier-testing_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

A very large percentage are flagged for removal in every activity

``` r
group_by(x, act, is_outlier) %>%
    summarise(n = n()) %>%
    mutate(pct_outliers = n / sum(n) * 100) %>%
    filter(is_outlier) %>%
    knitr::kable()
```

| act      | is\_outlier |  n | pct\_outliers |
| :------- | :---------- | -: | ------------: |
| bike     | TRUE        | 46 |     11.979167 |
| camp     | TRUE        | 55 |     11.482255 |
| fish     | TRUE        | 33 |      9.850746 |
| hunt     | TRUE        | 17 |     10.493827 |
| picnic   | TRUE        | 88 |      9.638554 |
| snow     | TRUE        | 27 |      8.681672 |
| trail    | TRUE        | 50 |     11.682243 |
| water    | TRUE        | 30 |      7.792208 |
| wildlife | TRUE        | 63 |     12.022901 |

## Log-transfrom with Tukey’s Test

This is a much less aggressive rule.

``` r
# identify outliers
x <- days %>%
    group_by(act) %>%
    mutate(is_outlier = tukey_outlier(days, apply_log = TRUE)) %>%
    ungroup()

# plot
ggplot(x, aes(act, days)) +
    geom_boxplot(outlier.size = -1) +
    geom_point(data = count(x, act, days, is_outlier), aes(size = n, color = is_outlier)) +
    scale_color_manual(values = c("gray", "red")) +
    scale_y_log10() +
    ggtitle("Tukey's test based on log-transformed values")
```

![](outlier-testing_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
group_by(x, act, is_outlier) %>%
    summarise(n = n()) %>%
    mutate(pct_outliers = n / sum(n) * 100) %>%
    filter(is_outlier) %>%
    knitr::kable()
```

| act      | is\_outlier |  n | pct\_outliers |
| :------- | :---------- | -: | ------------: |
| camp     | TRUE        |  8 |     1.6701461 |
| fish     | TRUE        |  3 |     0.8955224 |
| hunt     | TRUE        |  4 |     2.4691358 |
| picnic   | TRUE        | 16 |     1.7524644 |
| snow     | TRUE        |  2 |     0.6430868 |
| water    | TRUE        |  2 |     0.5194805 |
| wildlife | TRUE        | 14 |     2.6717557 |
