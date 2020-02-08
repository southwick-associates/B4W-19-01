# check first set of responses for survey
# dimensions:
# - person
# - activity
# - activity-basin

library(tidyverse)
library(skimr)

svy <- readRDS("data/interim/svy-test/svy-raw.rds")

# Check question piping ---------------------------------------------------

# the pipe_cnt & cnt should match, indicating that people who answered follow up questions
# answered appropriately to the reference question
check_piping <- function(
    x_var = "var94", ref_var = "var2O1", 
    ref_condition = function(svy) filter(svy, .data[[ref_var]] == "Checked")
) {
    ref <- ref_condition(svy)
    x <- filter(svy, !is.na(.data[[x_var]]))
    data.frame(pipe_cnt = nrow(semi_join(x, ref, by = "id")), cnt = nrow(x)) 
}

# checking piping for trail selections
check_piping("var94", "var2O1")
check_piping("var47", "var2O1")
check_piping("var57", "var94",
             function(svy) filter(svy, !is.na(var94), var94 != 0))
check_piping("var70O197", "var47",
             ref_condition = function(svy) filter(svy, var47 == "Yes"))
check_piping("var80O197", "var70O197")

# Skim Question Responses ------------------------------------------------

# person-level
person <- select(svy, id, Vstatus, var9:var13)
skim(person)

# activity-level
act <- svy %>% select(id, var2O1:var2O15)
skim(act)

act_water <- svy %>% select(id, var47:var55)
skim(act_water)

days <- svy %>% select(id, var94:var103)
skim(days)

days_water <- svy %>% select(id, var57:var66)
skim(days_water)

# activity-basin level
# - basins visited (along water) for each sport
basin <- svy %>% select(id, var70O197:var78O294)
skim(basin)

basin_days <- svy %>% select(id, var80O197:var88O293)
skim(basin_days)

# Exhaustive Question Responses -------------------------------------------

Hmisc::describe(person)
Hmisc::describe(act)
Hmisc::describe(act_water)
Hmisc::describe(days)
Hmisc::describe(days_water)
Hmisc::describe(basin)
Hmisc::describe(basin_days)
