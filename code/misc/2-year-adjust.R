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

# combine


# CPI ---------------------------------------------------------------------


