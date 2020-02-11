# create input file for implan import
# 1. convert: spending to implan categories
# 2. stage: apportion to implan sectors
# 3. input: format to Ind/Comm excel for implan import

library(tidyverse)
library(readxl)
library(openxlsx)
source("R/implan.R")

xls_template_file <- "data/raw/implan/implan_import_template.xls"
xls_out_file <- "data/processed/implan-import.xlsx"
# need to manually save as "implan-import.xls" at the end

# Load Data ---------------------------------------------------------------

spend <- readRDS("data/processed/spend2019.rds")

# manually-built implan relation tables
implan_convert <- read_excel("data/raw/implan/implan-convert.xlsx") %>%
    rename(type = spend_type)

implan_stage <- sapply(unique(spend$activity_group), function(x) {
    read_excel("data/raw/implan/implan-stage.xlsx", sheet = x) %>%
        mutate(activity_group = x)
    }, simplify = FALSE
) %>% bind_rows()

# 1. Convert: spending to Implan Categories -----------------------------------

spend_convert <- spend %>%
    left_join(implan_convert, by = c("activity_group", "type", "item")) %>%
    mutate(spend = share * spend)

# checks - should show TRUE
# - spending sums shoudn't change with new datasets
check_spend_sums <- function(df_in, df_out) {
    x <- group_by(df_in, act, type, item) %>% summarise(spend = sum(spend))
    y <- group_by(df_out, act, type, item) %>% summarise(spend = sum(spend))
    all.equal(x$spend, y$spend)
}
check_spend_sums(spend, spend_convert)

# - "share" should sum to 1 across allocation dimension
check_share_sums <- function(df, var, ...) {
    var <- enquo(var) # share variable
    dims <- enquos(...) # allocation dimension
    x <- group_by(df, !!! dims) %>% summarise(share = sum( !! var))
    all.equal(x$share, rep(1, nrow(x)))
}
check_share_sums(df = spend_convert, var = share, act, type, item)

# 2. Stage: Apportion Implan categories to sectors ----------------------------

spend_stage <- spend_convert %>%
    left_join(implan_stage, by = c("activity_group", "category")) %>%
    mutate(spend = spend * portion)

# check - should show TRUE
check_spend_sums(spend, spend_stage)
check_share_sums(df = spend_stage, var = portion, act, type, item, category)

# 3. Input: Build spreadsheets for imlan import---------------------------------

# collapse to implan input dimension
# - 18 worksheets: act (n=9), group (n=2)
# - one row per sector-retail category
spend_input <- spend_stage %>%
    group_by(act, group, sector, retail) %>%
    summarise(spend = sum(spend)) %>%
    ungroup()

# write to excel
for (i in sort(unique(spend$act))) {
    x <- filter(spend_input, act == i)
    implan_prepare_comm(x) %>% implan_write(xls_out_file, paste0(i, "Comm"))
    implan_prepare_ind(x) %>% implan_write(xls_out_file, paste0(i, "Ind"))
}
