# prepare implan 546 sectoring data by updating 536 data

library(tidyverse)
library(readxl)
source("R/results.R")

# 536 ---------------------------------------------------------------------
# some initial work to attach sector descriptions

infile <- "data/raw/implan/implan-sectors536-tmp.xlsx"
outfile <- "data/raw/implan/implan-sectors536.xlsx"

# existing sector relation table
acts <- c("oia", "hunt", "fish", "wildlife")
implan_sectors <- sapply(acts, function(x) {
    read_excel(infile, sheet = x) %>% mutate(activity_group = x)
}, simplify = FALSE) %>% 
    bind_rows()

# sector descriptions
f <- "data/raw/implan/Implan536_Industries_and_Commodities.xlsx"
x <- read_excel(f, sheet = "Industry") %>% 
    select(sector = Implan536Index, description = ImplanDescription) %>%
    mutate(group = "Ind")
y <- read_excel(f, sheet = "Commodity") %>% 
    select(sector = Implan536CommodityIndex, description = ImplanDescription) %>%
    mutate(group = "Comm")
sectors <- bind_rows(x, y)

# join
implan_sectors <- implan_sectors %>%
    left_join(sectors, by = c("group", "sector")) %>%
    select(group:sector, description, portion:activity_group)

for (i in acts) {
    x <- filter(implan_sectors, activity_group == i) %>% select(-activity_group)
    write_table(x, i, outfile)
}

# 546 ---------------------------------------------------------------------
# producing the 546 sectors

# 536 to 546 relation
# the esri crosswalk table needs a bit of preparation
# might put into a function for the package (or not)
# - using CewAvgRatio column for apportioning between new & old sectors
prep_crosswalk <- function() { 
    
}
relation_ind <- read_excel("data/raw/implan/Bridge_Implan536ToImplan546.xlsx") %>%
    select(sector546 = Implan546Index, sector536 = Implan536Index, crosswalk_ratio = CewAvgRatio)
crosswalk <- bind_rows(
    mutate(relation_ind, group = "Ind"),
    mutate(relation_ind, group = "Comm") %>%
        mutate_at(vars(sector546, sector536), function(x) x + 3000)
)

# 546 sector descriptions
f <- "data/raw/implan/Implan546 Industries & Commodities.xlsx"
x <- read_excel(f, sheet = "Industries") %>% 
    rename(sector = Implan546Index, description = Implan546Description) %>%
    mutate(group = "Ind")
y <- read_excel(f, sheet = "Commodities") %>% 
    rename(sector = Implan546CommodityIndex, description = ImplanDescription ) %>%
    mutate(group = "Comm")
description_new <- bind_rows(x, y)

# update sectoring scheme with crosswalk table
# - sectors_old data frame that holds spending by old sector
# - crosswalk data frame for converting between new and old sectors
# - description_new data frame that contains descriptions for new sectors
# - id_old variable that holds the old sector id
# - id_new variable that holds the new sector id
sector_update <- function(
    sectors_old, crosswalk, description_new, 
    id_old = "sector536", id_new = "sector546"
) {
    new <- sectors_old %>%
        select(-description) %>%
        left_join(crosswalk, by = c("group", id_old)) %>%
        mutate(share = share * crosswalk_ratio)
    new$sector <- new[[id_new]]
    new[[id_old]] <- NULL
    new[[id_new]] <- NULL
    new$crosswalk_ratio <- NULL
    left_join(new, description_new, by = c("group", "sector"))
}
sectors_new <- implan_sectors %>%
    rename(sector536 = sector) %>%
    sector_update(crosswalk, description_new)
# check
# - "share" should sum to 1 across allocation dimension
check_share_sums <- function(df, var, ...) {
    var <- enquo(var) # share variable
    dims <- enquos(...) # allocation dimension
    x <- group_by(df, !!! dims) %>% summarise(share = sum( !! var))
    all.equal(x$share, rep(1, nrow(x)))
}
sectors_new %>% check_share_sums(share, activity_group, category)

# write to excel
outfile <- "data/raw/implan/implan-sectors546.xlsx"
for (i in acts) {
    x <- filter(sectors_new, activity_group == i) %>%
        select(group, category, sector, description, share, retail)
    write_table(x, i, outfile)
}
