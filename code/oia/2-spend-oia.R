# get OIA spending by item in CO

library(tidyverse)
library(readxl)

load("data/results.RDATA") # 3 lists: tot, stat, out

# TODO
# - restrict to just those act1 activities targeted for colorado (need relation table)
# - see github code for spending: https://github.com/southwick-associates/oia-2016-profile/blob/master/code/1-ngpc-profiles/1-spending.R
#   + review the AZ code as well

read_excel("data/oia-activities.xlsx")
svy_oia <- readRDS("data-work/oia/oia-co.rds")
