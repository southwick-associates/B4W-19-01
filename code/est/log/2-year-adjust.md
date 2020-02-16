2-year-adjust.R
================
danka
2020-02-16

``` r
# get population and CPI for adjusting spending to 2019

library(tidyverse)
```

    ## -- Attaching packages --------------------------------------- tidyverse 1.3.0 --

    ## √ ggplot2 3.2.1     √ purrr   0.3.3
    ## √ tibble  2.1.3     √ dplyr   0.8.4
    ## √ tidyr   1.0.2     √ stringr 1.4.0
    ## √ readr   1.3.1     √ forcats 0.4.0

    ## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(readxl)
library(implan) # xlsx_write_table()

source("R/results.R")
outfile <- "out/profiles.xlsx"

# Population --------------------------------------------------------------

# CO adult population in 2019 
pop19 <- read_excel(
    "data/external/SCPRC-EST2019-18+POP-RES.xlsx",  
    col_names = c("state", "total", "adult", "adult_pct"), skip = 9
) %>%
    filter(state == ".Colorado") %>%
    mutate(year = 2019) %>%
    select(year, pop = adult)

# CO adult population 2010-2018
# - codebook: data/external/sc-est...pdf
pop10 <- read_csv("data/external/sc-est2018-agesex-civ.csv") %>%
    filter(AGE >= 18, NAME == "Colorado", SEX == 0, AGE != 999) %>%
    select(AGE, POPEST2010_CIV:POPEST2018_CIV) %>%
    gather(year, pop, -AGE) %>%
    mutate(year = str_remove(year, "POPEST") %>% str_remove("_CIV") %>% as.numeric()) %>%
    group_by(year) %>%
    summarise(pop = sum(pop))
```

    ## Parsed with column specification:
    ## cols(
    ##   SUMLEV = col_character(),
    ##   REGION = col_double(),
    ##   DIVISION = col_double(),
    ##   STATE = col_double(),
    ##   NAME = col_character(),
    ##   SEX = col_double(),
    ##   AGE = col_double(),
    ##   ESTBASE2010_CIV = col_double(),
    ##   POPEST2010_CIV = col_double(),
    ##   POPEST2011_CIV = col_double(),
    ##   POPEST2012_CIV = col_double(),
    ##   POPEST2013_CIV = col_double(),
    ##   POPEST2014_CIV = col_double(),
    ##   POPEST2015_CIV = col_double(),
    ##   POPEST2016_CIV = col_double(),
    ##   POPEST2017_CIV = col_double(),
    ##   POPEST2018_CIV = col_double()
    ## )

``` r
# combine
pop <- bind_rows(pop10, pop19)
ggplot(pop, aes(year, pop)) + geom_col() + ggtitle("CO Adult Population")
```

![](2-year-adjust_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

``` r
# CPI ---------------------------------------------------------------------
# https://www.minneapolisfed.org/about-us/monetary-policy/inflation-calculator/consumer-price-index-1913-

cpi <- tibble::tribble(
    ~year, ~cpi,
    2016, 240.0,
    2017, 245.1,
    2018, 251.1,
    2019, 255.7
)
ggplot(cpi, aes(year, cpi)) + geom_col() + ggtitle("US CPI in recent years")
```

![](2-year-adjust_files/figure-gfm/unnamed-chunk-1-2.png)<!-- -->

``` r
# Save --------------------------------------------------------------------

xlsx_write_table(pop, outfile)
xlsx_write_table(cpi, outfile)
```
