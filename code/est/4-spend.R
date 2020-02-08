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
    select(act:item, spend)

# Save & Summarize --------------------------------------------------------

saveRDS(spend, outfile)

spend %>%
    group_by(act) %>%
    summarise(sum(spend)) %>%
    knitr::kable(format.args = list(big.mark = ","))
