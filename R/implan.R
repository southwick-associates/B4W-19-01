# functions for implan work

source("R/results.R") # initialize_workbook()

# Writing to Excel --------------------------------------------------------
# see "code/implan/1-implan-input.R"

# prepare spending data for "Ind" sheet in Excel implan import
# returning a list of 2 data frames: (1) sheet header, (2) sector spending
# - dat data frame that holds spending data in a specific format
# - event_year Activity year for implan
implan_prepare_ind <- function(dat, event_year = 2019) {
    header <- tibble::tribble(
        ~`Activity Type`, ~`Activity Name`, ~`Activity Level`, ~"", ~`Activity Year`,
        "Industry Change", "Industry", 1, "", event_year
    )
    dat <- dat %>%  
        filter(group == "Ind") %>% 
        arrange(sector) %>%
        mutate(emp = 0, comp = 0, inc = 0, yr = event_year, loc = 1) %>%
        select(Sector = sector, `Event Value` = spend, Employment = emp, 
               `Employee Compensation` = comp, `Proprietor Income` = inc, 
               EventYear = yr, Retail = retail, `Local Direct Purchase` = loc)
    list(header, dat)
}

# prepare spending data for "Comm" sheet
implan_prepare_comm <- function(dat, event_year = 2019) {
    header <- tibble::tribble(
        ~`Activity Type`, ~`Activity Name`, ~`Activity Level`, ~`Activity Year`,
        "Commodity Change", "Commodity", 1, event_year
    )
    dat <- dat %>%  
        filter(group == "Comm") %>% 
        arrange(sector) %>%
        mutate(yr = event_year, loc = 1) %>%
        select(Sector = sector, `Event Value` = spend, EventYear = yr, 
               Retail = retail, `Local Direct Purchase` = loc)
    list(header, dat)
}

# write data to a sheet for Excel implan import
# - ls list returned from implan_prepare_ind() or implan_prepare_comm()
# - xls_out file path for output excel file
# - tabname name of sheet to be written to xls_out
implan_write <- function(ls, xls_out, tabname) {
    initialize_workbook(xls_out, add_readme = FALSE)
    wb <- openxlsx::loadWorkbook(xls_out)
    if (tabname %in% openxlsx::getSheetNames(xls_out)) {
        openxlsx::removeWorksheet(wb, tabname)
    }
    openxlsx::addWorksheet(wb, tabname)
    openxlsx::writeData(wb, sheet = tabname, ls[[1]]) # header
    openxlsx::writeData(wb, sheet = tabname, ls[[2]], startRow = 4) # data
    openxlsx::saveWorkbook(wb, xls_out, overwrite = TRUE)
}
