4-spend.R
================
danka
2020-02-16

``` r
# 2019 CO spending along waterways

library(tidyverse)
library(readxl)

infile <- "out/profiles.xlsx"
outfile <- "data/processed/spend2019.rds"

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
    select(act:item, spend) %>%
    # for implan categories:
    mutate(activity_group = ifelse(act %in% c("fish", "hunt", "wildlife"), act, "oia"))

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
