# functions for implan work

source("R/results.R") # initialize_workbook()

# Writing to Excel --------------------------------------------------------
# see "code/implan/1-implan-input.R"

# get a header table which implan import uses
# convenience function called from implan_prepare_ind() or implan_prepare_comm()
# - activity_name Acitivity name used for implan
# - event_year Activity year for implan
# - activity_type Either "Commodity Change" or "Industry Change"
implan_header <- function(activity_type, activity_name, event_year) {
    tibble::tribble(
        ~`Activity Type`, ~`Activity Name`, ~`Activity Level`, ~`Activity Year`,
        activity_type, activity_name, 1, event_year
    )
}

# prepare spending data for "Ind" sheet in Excel implan import
# returning a list of 2 data frames: (1) sheet header, (2) sector spending
# - dat data frame that holds spending data in a specific format
implan_prepare_ind <- function(dat, activity_name, event_year = 2019) {
    header <- implan_header("Industry Change", activity_name, event_year)
    dat <- dat %>%  
        filter(group == "Ind") %>% 
        arrange(sector) %>%
        mutate(emp = 0, comp = 0, inc = 0, yr = event_year, loc = 1) %>%
        select(Sector = sector, `Event Value` = spend, Employment = emp, 
               `Employee Compensation` = comp, `Proprietor Income` = inc, 
               EventYear = yr, Retail = retail, `Local Direct Purchase` = loc)
    list("header" = header, "dat" = dat)
}

# prepare spending data for "Comm" sheet
implan_prepare_comm <- function(dat, activity_name, event_year = 2019) {
    header <- implan_header("Commodity Change", activity_name, event_year)
    dat <- dat %>%  
        filter(group == "Comm") %>% 
        arrange(sector) %>%
        mutate(yr = event_year, loc = 1) %>%
        select(Sector = sector, `Event Value` = spend, EventYear = yr, 
               Retail = retail, `Local Direct Purchase` = loc)
    list("header" = header, "dat" = dat)
}

# write data to a sheet for Excel implan import
# - ls list returned from implan_prepare_ind() or implan_prepare_comm()
# - xls_out file path for output excel file
# - tabname name of sheet to be written to xls_out
implan_write <- function(ls, xls_out, tabname) {
    tabname <- ls$header$`Activity Name` # worksheet name matches activity name
    initialize_workbook(xls_out)
    wb <- openxlsx::loadWorkbook(xls_out)
    if (tabname %in% openxlsx::getSheetNames(xls_out)) {
        openxlsx::removeWorksheet(wb, tabname)
    }
    openxlsx::addWorksheet(wb, tabname)
    openxlsx::writeData(wb, sheet = tabname, ls$header)
    openxlsx::writeData(wb, sheet = tabname, ls$dat, startRow = 4)
    openxlsx::saveWorkbook(wb, xls_out, overwrite = TRUE)
}
