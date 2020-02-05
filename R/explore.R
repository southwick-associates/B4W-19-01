# functions for data exploration

# plotting total expenditures by activity
plot_spend <- function(df) {
    ggplot(df, aes(item, spend, fill = type)) +
        geom_col() +
        facet_wrap(~ act) +
        coord_flip() +
        scale_y_continuous(labels = scales::comma) +
        ggtitle("Spending in CO in 2016")
}
