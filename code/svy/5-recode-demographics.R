# recode certain demographic variables for weighting
# b/c we need categories that match between CO and OIA surveys

library(tidyverse)
source("R/prep-svy.R")

outfile <- "data/interim/svy-demo.rds"
svy <- readRDS("data/interim/svy-clean.rds")

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
    newcat = c(1:5, 6, 6, 7),
    newlab = c("0-25K", "25-35K", "35-50K", "50-75K", "75-100K", "100-150K", "150K+")
)

# race_weight
# race & hispanic variables are combined into much broader categorization
race_labs <- c("White", "Hispanic", "Not white or Hispanic")
svy$person <- svy$person %>% 
    mutate(
        race_weight = case_when(
            is.na(race) | is.na(hispanic) ~ NA_character_, 
            hispanic == "Yes" ~ "Hispanic",
            race != "White" ~ "Not white or Hispanic", 
            TRUE ~ "White"
        ) %>%
            factor(levels = race_labs)
    ) 
count(svy$person, race_weight, race, hispanic)

# save
saveRDS(svy, outfile)
