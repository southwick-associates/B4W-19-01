# recoding demographic variables for weighting
# we need categories that match between CO and OIA surveys

library(tidyverse)
source("R/prep-svy.R")
svy <- readRDS("data-work/1-svy/svy-clean.rds")

# age_weight
svy$person <- svy$person %>% recode_cat(
    oldvar = "age", 
    newvar = "age_weight",
    newcat = c(rep(1, 2), rep(2, 2), rep(3, 3)), 
    newlab = c("18-34", "35-54", "55+")
)

# income_weight
svy$person <- svy$person %>% recode_cat(
    oldvar = "income", 
    newvar = "income_weight",
    newcat = c(1, 2, 3, 4, 5, rep(6, 2), 7),
    newlab = c("0-25K", "25-35K", "35-50K", "50-75K", "75-100K", "100-150K", "150K+")
)

# race_weight
### TODO

# save
saveRDS(svy, "data-work/1-svy/svy-demo.rds")
