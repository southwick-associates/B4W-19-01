1-implan-input.R
================
danka
2020-02-14

``` r
# create input file for implan import
# 1. categories: convert spending items ("food", etc.) to implan categories ("Food - Groceries", etc.)
# 2. sectors: apportion categories to implan sectors
# 3. input: format to Ind/Comm excel tabs for implan import

library(tidyverse)
```

    ## -- Attaching packages --------------------------------------- tidyverse 1.3.0 --

    ## √ ggplot2 3.2.1     √ purrr   0.3.3
    ## √ tibble  2.1.3     √ dplyr   0.8.4
    ## √ tidyr   1.0.2     √ stringr 1.4.0
    ## √ readr   1.3.1     √ forcats 0.4.0

    ## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(readxl)
library(openxlsx)
library(implan)

# need to manually save this ".xlsx" as ".xls" after running this script
outfile <- "data/processed/implan-import.xlsx"

# Load Data ---------------------------------------------------------------

spending <- readRDS("data/processed/spend2019.rds")

item_to_category <- read_excel("data/raw/implan/item_to_category.xlsx") %>%
    rename(type = spend_type)
check_share_sums(item_to_category, share, activity_group, type, item)
```

    ## [1] TRUE

``` r
category_to_sector <- sapply(unique(spending$activity_group), function(x) {
    read_excel("data/processed/category_to_sector546.xlsx", sheet = x) %>%
        mutate(activity_group = x)
    }, simplify = FALSE
) %>% 
    bind_rows()
check_share_sums(category_to_sector, share, activity_group, category)
```

    ## [1] TRUE

``` r
# Prepare Implan Input ------------------------------------------------------

# 1. Convert spending to Implan Categories
spend_category <- spending %>%
    left_join(item_to_category, by = c("activity_group", "type", "item")) %>%
    mutate(spend = share * spend) %>%
    select(-share) # no longer needed
check_spend_sums(spending, spend_category, spend, activity_group, type, item)
```

    ## [1] TRUE

``` r
# 2. Apportion Implan categories to sectors
spend_sector <- spend_category %>%
    left_join(category_to_sector, by = c("activity_group", "category")) %>%
    mutate(spend = spend * share) %>%
    select(-share)
check_spend_sums(spend_category, spend_sector, spend, activity_group, type, item)
```

    ## [1] TRUE

``` r
# 3. Build spreadsheets for implan import
acts <- sort(unique(spending$act))
for (i in acts) {
    x <- filter(spend_sector, act == i)
    input_prep_comm(x, paste0(i, "Comm")) %>% xlsx_write_implan(outfile)
    input_prep_ind(x, paste0(i, "Ind")) %>% xlsx_write_implan(outfile)
}
```