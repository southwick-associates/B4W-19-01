# functions for results

# an xlsx save function (see NC code)


# Outliers ----------------------------------------------------------------

# TODO:
# - test the functions below for CO
# - if it works well, just provide some better documentation

### Copied from AZ
# - relevant AZ application is in code/1-svy/5-outliers.Rmd
# - it looks like I log transformed and either set to missing or top coded
#   depending on the quantity being estimated

# identify outliers based on tukey's rule ( > 1.5 * iqr)
tukey_outlier <- function(x, k = 1.5, ignore_lwr = FALSE, apply_log = TRUE) {
    # most of these distributions have a longnormal appearance
    if (apply_log) x <- log(x)
    
    quar <- quantile(x, probs = c(0.25, 0.75))
    iqr <- diff(quar)
    bottom <- quar[1] - k * iqr
    top <- quar[2] + k * iqr
    
    # might want to manually ignore low values
    if (ignore_lwr) {
        ifelse(x > top, 1, 0)
    } else {
        ifelse(x > top | x < bottom, 1, 0)
    }
}

# get the top (non-outlier) value for top-coding
tukey_top <- function(x, k = 1.5, apply_log = TRUE) {
    if (apply_log) x <- log(x)
    
    quar <- quantile(x, probs = c(0.25, 0.75))
    iqr <- diff(quar)
    exp(quar[2] + k * iqr)
}



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
