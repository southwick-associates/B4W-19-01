# get population and CPI for adjusting spending to 2019

library(tidyverse)
library(readxl)

# Population --------------------------------------------------------------

# CO adult population in 2019 
pop19 <- read_excel(
    "data/census/SCPRC-EST2019-18+POP-RES.xlsx",  
    col_names = c("state", "total", "adult", "adult_pct"), skip = 9
) %>%
    filter(state == ".Colorado") %>%
    mutate(state = "Colorado", year = 2019) %>%
    select(state, year, pop_adult = adult)

# CO adult population 2010-2018
# - codebook: data/census/sc-est...pdf
pop10 <- read_csv("data/census/sc-est2018-agesex-civ.csv") %>%
    filter(AGE >= 18, NAME == "Colorado", SEX == 0, AGE != 999) %>%
    select(state = NAME, age = AGE, POPEST2010_CIV:POPEST2018_CIV) %>%
    gather(year, pop_adult, -state, -age) %>%
    mutate(year = str_remove(year, "POPEST") %>% str_remove("_CIV") %>% as.numeric()) %>%
    group_by(state, year) %>%
    summarise(pop_adult = sum(pop_adult))

# combine
pop <- bind_rows(pop10, pop19)

# CPI ---------------------------------------------------------------------


