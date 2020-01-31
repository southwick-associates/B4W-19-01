# identify days outliers using tukey's rule
# also filtering out respondents flagged for suspicion

library(tidyverse)
source("R/outliers.R")
source("R/prep-svy.R")
svy <- readRDS("data-work/1-svy/svy-weight.rds")

# exclude suspicious respondents
suspicious <- filter(svy$person, flag > 3)
svy <- lapply(svy, function(df) anti_join(df, suspicious, by = "Vrid"))

# Overall Days ------------------------------------------------------------

# identify outliers & set to NA
svy$act <- svy$act %>%
    group_by(act) %>%
    mutate(
        is_outlier = tukey_outlier(days, ignore_zero = TRUE, apply_log = TRUE),
        days_cleaned = ifelse(is_outlier, NA, days)
    ) %>%
    ungroup()

# summarize
x <- filter(svy$act, is_targeted, !is.na(days))
filter(x, days > 0) %>% outlier_plot() + ggtitle("Overall days outliers")
outlier_pct(x, act) %>% knitr::kable()
outlier_mean_compare(x, "days", "days_cleaned", act) %>% knitr::kable()

# clean-up
svy$act <- svy$act %>%
    select(-days) %>%
    rename(days = days_cleaned, is_overall_outlier = is_outlier)

# Water Days --------------------------------------------------------------

# run outlier test specific to water days
# also any records with corresponding overall outliers will have water days set to missing
svy$act <- svy$act %>%
    group_by(act) %>%
    mutate(
        is_outlier = tukey_outlier(days_water, ignore_zero = TRUE, apply_log = TRUE),
        days_cleaned = ifelse(is_outlier | is_overall_outlier, NA, days_water)
    ) %>%
    ungroup()

# summarize
x <- filter(svy$act, is_targeted, !is.na(days_water))
filter(x, days_water > 0) %>% outlier_plot("days_water") + ggtitle("Water days outliers")
outlier_pct(x, act) %>% knitr::kable()
outlier_mean_compare(x, "days_water", "days_cleaned", act) %>% knitr::kable()

# clean-up
svy$act <- svy$act %>%
    select(Vrid:part, days, part_water, days_water = days_cleaned)

# Basin Water Days --------------------------------------------------------

# outliers are identified specific to act-basin
# use top-coding for these to avoid losing information about the share of 
#  days allocated to each basin
svy$basin <- svy$basin %>%
    group_by(act, basin) %>%
    mutate(
        is_outlier = tukey_outlier(days_water, ignore_zero = TRUE, apply_log = TRUE),
        topcode_value = tukey_top(days_water, ignore_zero = TRUE, apply_log = TRUE),
        days_cleaned = ifelse(is_outlier, topcode_value, days_water)
    ) %>%
    ungroup()

# summarize
x <- filter(svy$basin, !is.na(days_water))
filter(x, days_water > 0) %>% outlier_plot("days_water", c("act", "basin")) + 
    facet_wrap(~ basin)
outlier_pct(x, act, basin) %>% ungroup() %>% select(-n, -is_outlier) %>% 
    spread(basin, pct_outliers, fill = 0) %>% knitr::kable()
outlier_mean_compare(x, "days_water", "days_cleaned", act, basin) %>%
    knitr::kable()

# clean-up
svy$basin <- svy$basin %>%
    select(Vrid:part_water, days_water = days_cleaned)

# Save --------------------------------------------------------------------

saveRDS(svy, "data-work/1-svy/svy-final.rds")

# save as csvs (for Eric)
outdir <- "data-work/1-svy/svy-final-csv"
sapply(names(svy), function(nm) {
    write_list_csv(svy, nm, outdir)
})
