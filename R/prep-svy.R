# functions for preparing survey data

library(dplyr)

# Write a list of data frames to csv
# - ls list object
# - nm name of list element to write to csv (should be a data frame)
# - dir file path to directory where csv will be written 
write_list_csv <- function(ls, nm, dir) {
    dir.create(dir, showWarnings = FALSE, recursive = TRUE)
    write_csv(ls[[nm]], file.path(dir, paste0(nm, ".csv")), na = "")
}

# Recoding ----------------------------------------------------------------

# Recode a category variable (factor)
# - df survey data frame
# - oldvar name of input variable
# - newvar name of output variable (must be different than oldvar)
# - newcat output factor levels for each input factor level (ascending order)
# - newlab output factor labels
recode_cat <- function(df, oldvar, newvar, newcat, newlab) {
    df[[newvar]] <- plyr::mapvalues(
        df[[oldvar]], levels(df[[oldvar]]), newcat
    ) %>% 
        factor(labels = newlab)
    count_(df, c(newvar, oldvar)) %>% print() # summarize
    df[[oldvar]] <- NULL
    df
}

# Weighting ---------------------------------------------------------------

# Estimate rake weights for input survey data & population distributions
# 
# This is basically a wrapper for anesrake(). It prints a summary and
# returns the survey dataset with a rake_wt variable appended.
# 
# - svy  survey data frame
# - pop  population distribution list
# - print_name  header to print in summary (useful for log output)
# - idvar  name of varible that holds unique id
# - cap  cap argument of anesrake()
est_wts <- function(
    svy, pop, print_name = "", idvar = "sguid", cap = 20
) {
    # anesrake doesn't like tibbles (i.e., the tidyverse version of a data frame)
    svy <- data.frame(svy)
    
    # run weighting
    wts <- anesrake::anesrake(pop, svy, caseid = svy[[idvar]], force1 = TRUE, cap = cap)
    
    # print summary
    cat("\nWeight Summary for", print_name, "-----------------------------\n\n")
    print(summary(wts))
    
    # return output
    svy$rake_wt <- wts$weightvec
    svy
}

# Reshaping ---------------------------------------------------------------

# Get variable labels for a set of variables stored in df
# - df data frame with survey variables
# - func function to separate SPSS variable labels into component parts
# - dim_var name of variable that identifies the relevant label
get_varlabs <- function(
    df, func = function(x) separate(x, "lab", c("lab1", "lab2"), sep = ":"),
    dim_var = "lab1"
) {
    varlabs <- readr::read_csv("data/interim/svy-varlabs.csv")
    out <- filter(varlabs, var %in% names(df)) %>%
        func()
    out[[dim_var]] <- clean_labels(out[[dim_var]], dim_var)
    out
}

# Standardize labels for identifying dimensions
# - x vector that holds relevant labels
# - dim_var If "lab1" does preparation for activity label, otherwise preparation
#   for basin label
clean_labels <- function(x, dim_var = "lab1") {
    if (dim_var == "lab1") {
        # person-activity level
        x %>%
            stringr::str_remove('You participated in') %>%
            stringr::str_remove(" on paved/unpaved trail") %>%
            stringr::str_trim() %>%
            stringr::str_to_lower()
    } else {
        # person-activity-basin level
        x %>%
            stringr::str_to_lower() %>%
            stringr::str_extract("bicycling|camp|fish|hunt|picnic|snow|trail|water|wildlife") %>%
            stringr::str_trim()
    }
    
}

# Reshape a multi-response set into one variable & attach variable labels
# Also wraps get_varlabs()
# - vars unquoted set of variables to include (in addition to Vrid)
# - dim_file optional excel file for specifying more useful dimension labels
reshape_vars <- function(
    df, vars, func = function(x) separate(x, "lab", c("lab1", "lab2"), sep = ":"),
    dim_file = NULL, dim_var = "lab1"
) {
    
    vars <- enquos(vars)
    
    # reshape & attach SPSS variable labels
    x <- select(df, Vrid, !!! vars)
    varlabs <- get_varlabs(select(x, -Vrid), func, dim_var)
    out <- x %>%
        gather(var, val, -Vrid, na.rm = TRUE) %>%
        left_join(varlabs, by = "var")
    
    # convert SPSS variable labels to more useful labels based on reference file
    if (!is.null(dim_file)) {
        dims <- readxl::read_excel(dim_file) %>% 
            select(-var)
        dims[[dim_var]] <- clean_labels(dims[[dim_var]], dim_var)
        out <- left_join(out, dims, by = dim_var)
        cat("\n--- Labelling Summary ---\n\n")
        count(out, .data$act, .data[[dim_var]]) %>% print()
    }
    out
}

# Recode basin values into more useful dimension labels
recode_basin <- function(df, dim_var = "lab1") {
    basin_labs <- readxl::read_excel("data/raw/svy/basin_labs.xlsx")
    df$basin_long <- ifelse(
        stringr::str_detect(df[[dim_var]], "I did not"), "none", df[[dim_var]]
    )
    out <- df %>%
        left_join(basin_labs, by = "basin_long") %>%
        select(-basin_long)
    cat("\n--- Basin Summary ---\n\n")
    count(out, .data$basin, .data[[dim_var]]) %>% print()
    out 
}

# Plotting ----------------------------------------------------------------

# Plot choice variable summary
plot_choice <- function(df, var, ...) {
    var <- enquo(var)
    dims <- enquos(...)
    
    df %>%
        group_by(!!! dims, !! var) %>%
        summarise(n = n()) %>%
        mutate(pct = n / sum(n)) %>%
        ggplot(aes(!! var, pct)) +
        geom_col() +
        coord_flip()
}

# Plot multi-choice variable summary
# - var unquoted variable name that holds values
# - dim unquoted dimensional variable
# - ... unquoted optional extra dimensional variables
plot_choice_multi <- function(df, var, dim, ...) {
    var <- enquo(var)
    dim <- enquo(dim)
    extra_dims <- enquos(...)
    
    df %>%
        group_by(!!! extra_dims, !! dim, !! var) %>%
        summarise(n = n()) %>%
        mutate(pct = n / sum(n)) %>%
        ggplot(aes(!! dim, pct, fill = !! var)) +
        geom_col() +
        coord_flip()
}

# Plot a numeric variable
plot_num <- function(df, var, dim, ...) {
    var <- enquo(var)
    dim <- enquo(dim)
    extra_dims <- enquos(...)
    
    df %>%
        filter(!is.na(!! var)) %>%
        ggplot(aes(!! dim, !! var)) +
        geom_boxplot() +
        coord_flip() +
        scale_y_log10()
}

# Flagging ----------------------------------------------------------------

# Update a flag table with new flag values
# To be used for removing suspicious respondents
# - flag_tbl data frame with existing flag values
# - new_flags data frame with records to be flagged
# - flag_var quoted name of variable to be used for this flag
# - flag val numeric value to be assigned to new flags
# - count_once if TRUE, can't flag a Vrid multiple times for the same test
update_flags <- function(
    flag_tbl, new_flags, flag_var, flag_val = 1, count_once = FALSE
) {
    add_flags <- new_flags %>% 
        group_by(Vrid) %>%
        summarise(n = n())
    if (count_once) {
        add_flags <- mutate(add_flags, n = 1)
    }
    add_flags[[flag_var]] <- add_flags$n * flag_val
    x <- flag_tbl %>%
        left_join(add_flags, by = "Vrid")
    x[[flag_var]] <- ifelse(is.na(x[[flag_var]]), 0, x[[flag_var]])
    x$flag <- x$flag + x[[flag_var]]
    select(x, -n)
}
