# compare total basin days vs total water days

library(tidyverse)
svy <- readRDS("data-work/1-svy/svy-final.rds")

# sum days_water.basin 
x <- svy$basin %>%
    group_by(act) %>%
    summarise(days_water.basin = sum(days_water, na.rm = TRUE))

# sum days_water.all (just those who answerd days_water.basin)
did_answer <- filter(svy$basin, !is.na(days_water)) %>% 
    distinct(Vrid, act)
y <- svy$act %>%
    filter(days_water != 0) %>%
    semi_join(did_answer) %>%
    group_by(act) %>%
    summarise(days_water.act = sum(days_water))

left_join(x, y) %>%
    mutate(
        diff = days_water.basin - days_water.act,
        pct_diff = round(diff / days_water.act * 100, 2)
    ) %>%
    write_csv("tmp-days-compare.csv")

