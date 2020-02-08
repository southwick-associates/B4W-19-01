4-spend.R
================
danka
Fri Feb 07 16:23:15 2020

``` r
# 2019 CO spending along waterways

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
library(readxl)

infile <- "out/profiles.xlsx"
outfile <- "data-work/misc/spend2019.rds"

# Calculate ---------------------------------------------------------------

multiply_vars <- function(df, dims = c("act", "type", "item")) {
    calc_vars <- df[setdiff(names(df), dims)]
    df$spend <- Reduce(`*`, calc_vars)
    df
}

spend <- bind_rows(
    read_excel(infile, "avgSpendPicnic") %>% multiply_vars(), # picnic
    read_excel(infile, "spend") %>% multiply_vars() # others
) %>%
    select(act:item, spend)

# Save & Summarize --------------------------------------------------------

saveRDS(spend, outfile)

spend %>%
    group_by(act) %>%
    summarise(sum(spend)) %>%
    knitr::kable(format.args = list(big.mark = ","))
```

| act      |    sum(spend) |
| :------- | ------------: |
| bike     |   382,369,695 |
| camp     | 2,402,885,783 |
| fish     |   734,394,986 |
| hunt     |   160,010,641 |
| picnic   |   728,380,815 |
| snow     | 1,254,386,115 |
| trail    | 2,584,908,383 |
| water    | 2,138,911,164 |
| wildlife |   426,223,782 |
