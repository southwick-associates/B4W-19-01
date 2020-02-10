1-load-raw.R
================
danka
2020-02-10

``` r
# test soft-launch data in early Dec.

library(tidyverse)
library(haven)
outfile <- "data/interim/svy-test/svy-raw.rds"

# Load Raw ----------------------------------------------------------------

f <- "data/raw/svy/2019-12-06/spss.sav"
svy_in <- read_sav(f)
svy <- svy_in
dim(svy_in)
```

    ## [1] 137 234

``` r
# drop unneeded variables
svy <- select(svy_in, Vrid:Vstatus, id = var105, var2O1:var13)
dim(svy)
```

    ## [1] 137 219

``` r
# SPSS Labels -------------------------------------------------------------

# variable labs
# - save these in a table for later reference
varlabs <- list()
for (i in names(svy)) {
    varlabs[[i]] <- data.frame(
        var = i,
        lab = attributes(svy[[i]])$label,
        stringsAsFactors = FALSE
    )
}
varlabs <- bind_rows(varlabs)
head(varlabs, 4)
```

    ##        var            lab
    ## 1     Vrid    Response ID
    ## 2 Vdatesub Date Submitted
    ## 3  Vstatus         Status
    ## 4       id             id

``` r
# value labels
# - convert labelled values to R factors
svy <- haven::as_factor(svy)

# - check some value labels
svy_in[, c("var2O1", "var2O2")]
```

    ## # A tibble: 137 x 2
    ##           var2O1        var2O2
    ##        <dbl+lbl>     <dbl+lbl>
    ##  1 0 [Unchecked] 1 [Checked]  
    ##  2 0 [Unchecked] 0 [Unchecked]
    ##  3 0 [Unchecked] 0 [Unchecked]
    ##  4 0 [Unchecked] 0 [Unchecked]
    ##  5 0 [Unchecked] 0 [Unchecked]
    ##  6 0 [Unchecked] 0 [Unchecked]
    ##  7 0 [Unchecked] 0 [Unchecked]
    ##  8 0 [Unchecked] 0 [Unchecked]
    ##  9 0 [Unchecked] 0 [Unchecked]
    ## 10 1 [Checked]   0 [Unchecked]
    ## # ... with 127 more rows

``` r
svy[, c("var2O1", "var2O2")]
```

    ## # A tibble: 137 x 2
    ##    var2O1    var2O2   
    ##    <fct>     <fct>    
    ##  1 Unchecked Checked  
    ##  2 Unchecked Unchecked
    ##  3 Unchecked Unchecked
    ##  4 Unchecked Unchecked
    ##  5 Unchecked Unchecked
    ##  6 Unchecked Unchecked
    ##  7 Unchecked Unchecked
    ##  8 Unchecked Unchecked
    ##  9 Unchecked Unchecked
    ## 10 Checked   Unchecked
    ## # ... with 127 more rows

``` r
# - list labelled variables
list_factor_vars <- function(df) {
    factors <- sapply(names(df), function(nm) is.factor(df[[nm]]))
    names(df)[factors]
}
list_factor_vars(svy)
```

    ##   [1] "var2O1"     "var2O2"     "var2O3"     "var2O4"     "var2O5"     "var2O6"    
    ##   [7] "var2O7"     "var2O8"     "var2O9"     "var2O10"    "var2O11"    "var2O12"   
    ##  [13] "var2O13"    "var2O14"    "var2O15"    "var47"      "var48"      "var49"     
    ##  [19] "var50"      "var52"      "var53"      "var55"      "var108O319" "var108O320"
    ##  [25] "var108O321" "var108O322" "var70O197"  "var70O198"  "var70O207"  "var70O208" 
    ##  [31] "var70O209"  "var70O210"  "var70O211"  "var70O212"  "var70O213"  "var70O214" 
    ##  [37] "var71O215"  "var71O216"  "var71O217"  "var71O218"  "var71O219"  "var71O220" 
    ##  [43] "var71O221"  "var71O222"  "var71O223"  "var71O224"  "var72O225"  "var72O226" 
    ##  [49] "var72O227"  "var72O228"  "var72O229"  "var72O230"  "var72O231"  "var72O232" 
    ##  [55] "var72O233"  "var72O234"  "var73O235"  "var73O236"  "var73O237"  "var73O238" 
    ##  [61] "var73O239"  "var73O240"  "var73O241"  "var73O242"  "var73O243"  "var73O244" 
    ##  [67] "var74O245"  "var74O246"  "var74O247"  "var74O248"  "var74O249"  "var74O250" 
    ##  [73] "var74O251"  "var74O252"  "var74O253"  "var74O254"  "var75O255"  "var75O256" 
    ##  [79] "var75O257"  "var75O258"  "var75O259"  "var75O260"  "var75O261"  "var75O262" 
    ##  [85] "var75O263"  "var75O264"  "var76O265"  "var76O266"  "var76O267"  "var76O268" 
    ##  [91] "var76O269"  "var76O270"  "var76O271"  "var76O272"  "var76O273"  "var76O274" 
    ##  [97] "var77O275"  "var77O276"  "var77O277"  "var77O278"  "var77O279"  "var77O280" 
    ## [103] "var77O281"  "var77O282"  "var77O283"  "var77O284"  "var78O285"  "var78O286" 
    ## [109] "var78O287"  "var78O288"  "var78O289"  "var78O290"  "var78O291"  "var78O292" 
    ## [115] "var78O293"  "var78O294"  "var9"       "var10"      "var11"      "var12"     
    ## [121] "var13"

``` r
list_factor_vars(svy_in)
```

    ## character(0)

``` r
# Drop Variables ----------------------------------------------------------

# not sure if there are variable in here to exclude (e.g., map-based selections)
# will need to walk through the dataset to categorize

# there shouldn't be any deprecated variables (since that was unchecked in svy export)


# Save --------------------------------------------------------------------

# variables labels
write_csv(varlabs, "data/interim/svy-varlabs.csv")

# svy data
dir.create("data/interim/svy-test", showWarnings = FALSE)
saveRDS(svy, outfile)
```
