# functions for results

# an xlsx save function (see NC code)

# Plotting Distributions --------------------------------------------------

# TODO: get a simpler distribution plotting function(s) for use in CO

# a plot function here for survey weighting
colors_for_fig <- c("#0082B5", "#33c5ff") # medium blue
drop_cnty <- function(x) as.character(x) %>% str_remove("County") %>% str_trim()

# function from AZ, overly complex I think
compare_pct <- function(var, title, wt = NULL, use_legend = FALSE, angle = 0, hjust = 0.5) {
    x <- data.frame(cat = names(demo[[var]]), population = demo[[var]], 
                    survey = weights::wpct(svy$person[[var]], wt)) %>%
        gather(grp, pct, population, survey)
    if (var == "race") x <- mutate(x, cat = fct_other(cat, keep = c("Hispanic", "White")))
    if (var == "avid") x <- mutate(x, cat = fct_recode(cat, `5-9` = "5-8"))
    if (var == "county") x <- mutate(x, cat = drop_cnty(cat))
    if (var == "income") x <- mutate(x, cat = fct_relevel(cat, c("0-50K", "50K-100K", "100K+")))
    
    plt <- ggplot(x, aes(cat, pct ,fill = grp)) +
        geom_col(position = "dodge") +
        ggtitle(title) +
        theme(axis.text.x = element_text(angle = angle, hjust = hjust),
              axis.title = element_blank(),
              legend.title = element_blank(),
              legend.position = "bottom", 
              plot.title = element_text(size = 10))  +
        scale_fill_manual(values = colors_for_fig) +
        scale_y_continuous(labels = scales::percent)
    if (!use_legend) plt <- plt + guides(fill = FALSE, color = FALSE)
    plt
}
