# functions for results

# Profiling ---------------------------------------------------------------

# get adjustment factor based on an annual change (e.g., cpi)
get_year_adjust <- function(df, year_reference, year_target) {
    varname <- deparse(substitute(df)) # i.e., variable has same name as df
    df <- filter(df, year %in% c(year_reference, year_target))
    df$adjust <- df[[varname]] / lag(df[[varname]])
    df$adjust[2]
}

# Survey Representation --------------------------------------------------
# - see code/1-svy/weight-summary.Rmd

# compare distributions for a demographic variable (survey vs. population)
compare_demo <- function(var, svy_data, pop_data) {
    var <- enquo(var)
    svy_pct <- svy_data %>%
        count(!! var) %>% 
        filter(!is.na(!! var)) %>% 
        mutate(pct = n / sum(n), grp = "Survey")
    pop_pct <- pop_data %>%
        group_by(!! var) %>% 
        summarise(n = sum(stwt)) %>% # OIA needs to be weighted
        filter(!is.na(!! var)) %>%
        mutate(pct = n / sum(n), grp = "Population")
    bind_rows(svy_pct, pop_pct)
}

# compare demographic distributions in a report-ready plot
# - uses output of compare_demo()
plot_demo <- function(
    df_demo, var, title, hide_legend = TRUE, angle_x_labs = NULL
) {
    # make plot
    var <- enquo(var)
    p <- df_demo %>%
        ggplot(aes(!! var, pct, fill = grp)) +
        geom_col(position = "dodge", width = 0.7)
    
    # customize appearance for report
    p <- p +
        scale_fill_manual(values = c("#0082B5", "#33c5ff")) +
        scale_y_continuous(labels = scales::percent) +
        theme_minimal() +
        theme(
            plot.title = element_text(size = 10, hjust = 0.5),
            axis.title = element_blank(),
            panel.grid.major.x  = element_blank(),
            panel.grid.minor.y = element_blank(),
            legend.title = element_blank(),
            legend.position = "top",
            plot.margin = margin(0.6, 0.6, 0.6, 0.6, "cm")
        )
    if (hide_legend) {
        p <- p + theme(legend.position = "none")
    }
    if (!is.null(angle_x_labs)) {
        p <- p + theme(axis.text.x = element_text(angle = angle_x_labs, hjust = 1))
    }
    p + ggtitle(title)
}

# get a legend for use in multi-plot figures
# - uses output of plot_demo()
get_legend <- function(myggplot) {
    tmp <- ggplot_gtable(ggplot_build(myggplot))
    leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
    tmp$grobs[[leg]]
}
