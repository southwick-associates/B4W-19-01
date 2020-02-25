# Get contributions from Implan

library(tidyverse)
library(implan)
library(workflow) # xlsx_write_table()

indir <- "data/raw/implan_out"
outfile <- "out/contributions.xlsx"

# load data
econ <- output(indir) %>% rename(act = dimension)

# get total (all activities)
econ_total <- econ %>%
    select(-act) %>%
    group_by(ImpactType) %>%
    summarise_all("sum")

# save
# TODO: check for exact match
xlsx_write_table(econ, outfile)
xlsx_write_table(econ_total, outfile)

# summarize
plot_impact <- function(econ, impact_type) {
    df <- econ %>%
        gather(metric, value, Employment:LocalTax) %>%
        mutate(value_millions = value / 10^6) %>%
        filter(ImpactType == impact_type)
    ggplot(df, aes(act, value_millions)) +
        geom_col() +
        facet_wrap(~ metric, scales = "free_x") +
        ggtitle(paste(impact_type, "(Millions)")) +
        scale_y_continuous(labels = scales::comma) +
        coord_flip()
}
plot_impact(econ, "Direct Effect")
plot_impact(econ, "Total Effect")
