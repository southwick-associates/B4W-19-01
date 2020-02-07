# 2019 CO spending along waterways

library(tidyverse)
library(readxl)

infile <- "out/profiles.xlsx"
outfile <- "data-work/misc/spend2019.rds"

multiply_vars <- function(df, dims = c("act", "type", "item")) {
    calc_vars <- df[setdiff(names(df), dims)]
    df$spend <- Reduce(`*`, calc_vars)
    df
}

spend <- read_excel(infile, "spend") %>%
    multiply_vars()

spend %>%
    group_by(act) %>%
    summarise(sum(spend)) %>%
    knitr::kable(format.args = list(big.mark = ","))

# TODO: hunt is hunting and shooting...hmmmm...
# what did we do for AZ, I'll take a look