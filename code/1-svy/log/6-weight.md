6-weight.R
================
danka
Wed Jan 29 15:48:43 2020

``` r
# weight survey using OIA

library(tidyverse)
source("R/prep-svy.R")

svy <- readRDS("data-work/1-svy/svy-demo.rds")
flags <- readRDS("data-work/1-svy/svy-flag.rds")

# Add Flags ---------------------------------------------------------------

svy$person <- svy$person %>%
    left_join(flags$flag_totals, by = "Vrid") %>%
    mutate(flag = ifelse(is.na(flag), 0, flag))

# Weight ------------------------------------------------------------------

# temporarily store weight as 1 for non-excluded respondents
svy$person <- svy$person %>%
    mutate(weight = ifelse(flag >= 4, NA, 1))

# Save --------------------------------------------------------------------

# save as RDS
saveRDS(svy, "data-work/1-svy/svy-weight.rds")

# save as csvs (for Eric)
# - created zip file by hand
outdir <- "data-work/1-svy/svy-weight-csv"
sapply(names(svy), function(nm) {
    write_list_csv(svy, nm, outdir)
})
```

    ## $person
    ## # A tibble: 1,359 x 12
    ##    Vrid  id    Vstatus sex   race  race_other hispanic age_weight
    ##    <chr> <chr> <chr>   <fct> <fct> <chr>      <fct>    <fct>     
    ##  1 98    C205~ Comple~ Fema~ White ""         No       35-54     
    ##  2 99    C205~ Comple~ Fema~ Other unecessar~ No       35-54     
    ##  3 100   C205~ Partial <NA>  <NA>  ""         <NA>     <NA>      
    ##  4 101   C205~ Comple~ Male  White ""         No       35-54     
    ##  5 102   C205~ Comple~ Fema~ Blac~ ""         No       35-54     
    ##  6 103   C205~ Comple~ Male  White ""         No       18-34     
    ##  7 104   C205~ Comple~ Fema~ White ""         No       55+       
    ##  8 105   C205~ Comple~ Male  White ""         No       18-34     
    ##  9 106   C205~ Comple~ Fema~ Blac~ ""         No       35-54     
    ## 10 107   C205~ Comple~ Male  White ""         Yes      35-54     
    ## # ... with 1,349 more rows, and 4 more variables: income_weight <fct>,
    ## #   race_weight <fct>, flag <dbl>, weight <dbl>
    ## 
    ## $act
    ## # A tibble: 19,026 x 7
    ##    Vrid  act   is_targeted part       days part_water days_water
    ##    <chr> <chr> <lgl>       <chr>     <dbl> <chr>           <dbl>
    ##  1 98    trail TRUE        Unchecked    NA <NA>               NA
    ##  2 99    trail TRUE        Unchecked    NA <NA>               NA
    ##  3 100   trail TRUE        Unchecked    NA <NA>               NA
    ##  4 101   trail TRUE        Unchecked    NA <NA>               NA
    ##  5 102   trail TRUE        Unchecked    NA <NA>               NA
    ##  6 103   trail TRUE        Unchecked    NA <NA>               NA
    ##  7 104   trail TRUE        Unchecked    NA <NA>               NA
    ##  8 105   trail TRUE        Unchecked    NA <NA>               NA
    ##  9 106   trail TRUE        Unchecked    NA <NA>               NA
    ## 10 107   trail TRUE        Checked      15 Yes                10
    ## # ... with 19,016 more rows
    ## 
    ## $basin
    ## # A tibble: 24,174 x 5
    ##    Vrid  act   basin    part_water days_water
    ##    <chr> <chr> <chr>    <chr>           <dbl>
    ##  1 107   trail arkansas Checked             5
    ##  2 108   trail arkansas Unchecked          NA
    ##  3 110   trail arkansas Unchecked          NA
    ##  4 113   trail arkansas Checked             8
    ##  5 119   trail arkansas Unchecked          NA
    ##  6 129   trail arkansas Checked             1
    ##  7 131   trail arkansas Unchecked          NA
    ##  8 140   trail arkansas Checked            12
    ##  9 152   trail arkansas Unchecked          NA
    ## 10 157   trail arkansas Unchecked          NA
    ## # ... with 24,164 more rows

``` r
# not working, need to set command line stuff in Windows, bla
# files_to_zip <- dir(outdir, full.names = TRUE)
# zip(zipfile = "testZip", files = files_to_zip, flags = " a -tzip",
#     zip = "C:\\Program Files\\7-Zip\7z.exe")
```
