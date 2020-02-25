# create input file for implan import
# 1. categories: convert spending items ("food", etc.) to implan categories ("Food - Groceries", etc.)
# 2. sectors: apportion categories to implan sectors
# 3. input: format to Ind/Comm excel tabs for implan import

library(tidyverse)
library(readxl)
library(implan)

# need to manually save this ".xlsx" as ".xls" after running this script
outfile <- "data/interim/implan-import.xlsx"

# Load Data ---------------------------------------------------------------

spending <- readRDS("data/processed/spend2019.rds")

item_to_category <- "data/raw/implan/item_to_category.xlsx" %>%
    read_excel() %>%
    rename(type = spend_type)
check_share_sums(item_to_category, share, activity_group, type, item)

category_to_sector <- "data/raw/implan/master546-2020-02-19.xlsx" %>%
    read_excel(sheet = "category_to_sector546")
check_share_sums(category_to_sector, share, category)

# Prepare Implan Input ------------------------------------------------------

# 1. Convert spending to Implan Categories
spend_category <- spending %>%
    left_join(item_to_category, by = c("activity_group", "type", "item")) %>%
    mutate(spend = share * spend) %>%
    select(-share) # no longer needed
check_spend_sums(spending, spend_category, spend, activity_group, type, item)

# 2. Apportion Implan categories to sectors
spend_sector <- spend_category %>%
    left_join(category_to_sector, by = "category") %>%
    mutate(spend = spend * share) %>%
    select(-share)
check_spend_sums(spend_category, spend_sector, spend, activity_group, type, item)

# 3. Build spreadsheets for implan import
# TODO: check this
input(spend_sector, outfile, 2019, act)
