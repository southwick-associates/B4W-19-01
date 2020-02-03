# functions for results

# an xlsx save function (see NC code)

# Survey Representation --------------------------------------------------
# - see code/1-svy/weight-summary.Rmd

# get distributions for a demographic variable for survey vs. population
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
plot_demo <- function(
    df_demo, var, title, hide_legend = TRUE, angle_x_labs = NULL
) {
    # make plot
    var <- enquo(var)
    p <- df_demo %>%
        ggplot(aes(!! var, pct, fill = grp)) +
        geom_col(position = "dodge")
    
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
            legend.text.align = 0
        )
    if (hide_legend) {
        p <- p + theme(legend.position = "none")
    }
    if (!is.null(angle_x_labs)) {
        p <- p + theme(axis.text.x = element_text(angle = angle_x_labs, hjust = 1))
    }
    p + ggtitle(title)
}

# get a plot legend for use in package gridExtra
get_legend <- function(myggplot) {
    tmp <- ggplot_gtable(ggplot_build(myggplot))
    leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
    legend <- tmp$grobs[[leg]]
}
