2-contributions.R
================
danka
2020-02-14

``` r
# Get contributions from Implan

library(tidyverse)
```

    ## -- Attaching packages --------------------------------------- tidyverse 1.3.0 --

    ## √ ggplot2 3.2.1     √ purrr   0.3.3
    ## √ tibble  2.1.3     √ dplyr   0.8.4
    ## √ tidyr   1.0.2     √ stringr 1.4.0
    ## √ readr   1.3.1     √ forcats 0.4.0

    ## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(implan)

indir <- "data/raw/implan_out"
outfile <- "data/processed/contributions.xlsx"

# load data
acts <- list.files(indir)
econ <- acts %>%
    sapply(function(x) {
        output_read_csv(file.path(indir, x)) %>% output_combine() %>%
            mutate(act = x)
    }, simplify = FALSE) %>%
    bind_rows()

# save
xlsx_initialize_workbook(outfile)
xlsx_write_table(econ, "econ", outfile)

# summarize
plot_metric <- function(df, metric) {
    df %>%
        filter(ImpactType %in% c("Direct Effect", "Total Effect")) %>%
        ggplot(aes_string("act", metric)) +
        geom_col() +
        facet_wrap(~ ImpactType) +
        ggtitle(metric) +
        scale_y_continuous(labels = scales::comma)
}
plot_metric(econ, "Employment")
```

![](2-contributions_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

``` r
plot_metric(econ, "LaborIncome")
```

![](2-contributions_files/figure-gfm/unnamed-chunk-1-2.png)<!-- -->

``` r
plot_metric(econ, "TotalValueAdded")
```

![](2-contributions_files/figure-gfm/unnamed-chunk-1-3.png)<!-- -->

``` r
plot_metric(econ, "Output")
```

![](2-contributions_files/figure-gfm/unnamed-chunk-1-4.png)<!-- -->

``` r
plot_metric(econ, "FedTax")
```

![](2-contributions_files/figure-gfm/unnamed-chunk-1-5.png)<!-- -->

``` r
plot_metric(econ, "LocalTax")
```

![](2-contributions_files/figure-gfm/unnamed-chunk-1-6.png)<!-- -->
