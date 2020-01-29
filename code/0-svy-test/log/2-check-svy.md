2-check-svy.R
================
danka
Wed Jan 29 15:47:07 2020

``` r
# check first set of responses for survey
# dimensions:
# - person
# - activity
# - activity-basin

library(tidyverse)
library(skimr)

svy <- readRDS("data-work/0-svy-test/svy-raw.rds")

# Check question piping ---------------------------------------------------

# the pipe_cnt & cnt should match, indicating that people who answered follow up questions
# answered appropriately to the reference question
check_piping <- function(
    x_var = "var94", ref_var = "var2O1", 
    ref_condition = function(svy) filter(svy, .data[[ref_var]] == "Checked")
) {
    ref <- ref_condition(svy)
    x <- filter(svy, !is.na(.data[[x_var]]))
    data.frame(pipe_cnt = nrow(semi_join(x, ref, by = "id")), cnt = nrow(x)) 
}

# checking piping for trail selections
check_piping("var94", "var2O1")
```

    ##   pipe_cnt cnt
    ## 1       40  40

``` r
check_piping("var47", "var2O1")
```

    ##   pipe_cnt cnt
    ## 1       37  37

``` r
check_piping("var57", "var94",
             function(svy) filter(svy, !is.na(var94), var94 != 0))
```

    ##   pipe_cnt cnt
    ## 1       28  28

``` r
check_piping("var70O197", "var47",
             ref_condition = function(svy) filter(svy, var47 == "Yes"))
```

    ##   pipe_cnt cnt
    ## 1       26  26

``` r
check_piping("var80O197", "var70O197")
```

    ##   pipe_cnt cnt
    ## 1        7   7

``` r
# Skim Question Responses ------------------------------------------------

# person-level
person <- select(svy, id, Vstatus, var9:var13)
skim(person)
```

    ## Skim summary statistics
    ##  n obs: 137 
    ##  n variables: 8 
    ## 
    ## -- Variable type:character -----------------------------------------------------
    ##      variable missing complete   n min max empty n_unique
    ##            id       0      137 137  11  11     0      137
    ##  var12O59Othr       0      137 137   0  19   130        8
    ##       Vstatus       0      137 137   7   8     0        2
    ## 
    ## -- Variable type:factor --------------------------------------------------------
    ##  variable missing complete   n n_unique                         top_counts
    ##     var10      11      126 137        2           Fem: 85, Mal: 41, NA: 11
    ##     var11      11      126 137        8 $50: 24, $25: 23, Les: 20, $35: 17
    ##     var12      11      126 137        5   Whi: 103, NA: 11, Bla: 8, Oth: 7
    ##     var13      11      126 137        2           No: 111, Yes: 15, NA: 11
    ##      var9      11      126 137        7 25 : 30, 45 : 26, 35 : 23, 18 : 16
    ##  ordered
    ##    FALSE
    ##    FALSE
    ##    FALSE
    ##    FALSE
    ##    FALSE

``` r
# activity-level
act <- svy %>% select(id, var2O1:var2O15)
skim(act)
```

    ## Skim summary statistics
    ##  n obs: 137 
    ##  n variables: 16 
    ## 
    ## -- Variable type:character -----------------------------------------------------
    ##  variable missing complete   n min max empty n_unique
    ##        id       0      137 137  11  11     0      137
    ## 
    ## -- Variable type:factor --------------------------------------------------------
    ##  variable missing complete   n n_unique               top_counts ordered
    ##    var2O1       0      137 137        2  Unc: 95, Che: 42, NA: 0   FALSE
    ##   var2O10       0      137 137        2 Unc: 125, Che: 12, NA: 0   FALSE
    ##   var2O11       0      137 137        2 Unc: 114, Che: 23, NA: 0   FALSE
    ##   var2O12       0      137 137        2 Unc: 115, Che: 22, NA: 0   FALSE
    ##   var2O13       0      137 137        2 Unc: 124, Che: 13, NA: 0   FALSE
    ##   var2O14       0      137 137        2  Unc: 97, Che: 40, NA: 0   FALSE
    ##   var2O15       0      137 137        1  Unc: 137, Che: 0, NA: 0   FALSE
    ##    var2O2       0      137 137        2  Unc: 95, Che: 42, NA: 0   FALSE
    ##    var2O3       0      137 137        2  Unc: 81, Che: 56, NA: 0   FALSE
    ##    var2O4       0      137 137        2 Che: 103, Unc: 34, NA: 0   FALSE
    ##    var2O5       0      137 137        2  Unc: 86, Che: 51, NA: 0   FALSE
    ##    var2O6       0      137 137        2  Unc: 98, Che: 39, NA: 0   FALSE
    ##    var2O7       0      137 137        2 Unc: 117, Che: 20, NA: 0   FALSE
    ##    var2O8       0      137 137        2 Unc: 103, Che: 34, NA: 0   FALSE
    ##    var2O9       0      137 137        2  Unc: 74, Che: 63, NA: 0   FALSE

``` r
act_water <- svy %>% select(id, var47:var55)
skim(act_water)
```

    ## Skim summary statistics
    ##  n obs: 137 
    ##  n variables: 8 
    ## 
    ## -- Variable type:character -----------------------------------------------------
    ##  variable missing complete   n min max empty n_unique
    ##        id       0      137 137  11  11     0      137
    ## 
    ## -- Variable type:factor --------------------------------------------------------
    ##  variable missing complete   n n_unique                       top_counts
    ##     var47     100       37 137        2  NA: 100, Yes: 28, No: 9, Not: 0
    ##     var48      97       40 137        2  NA: 97, Yes: 21, No: 19, Not: 0
    ##     var49      87       50 137        3  NA: 87, Yes: 39, No: 10, Not: 1
    ##     var50      42       95 137        3  Yes: 70, NA: 42, No: 24, Not: 1
    ##     var52     101       36 137        3 NA: 101, No: 20, Yes: 14, Not: 2
    ##     var53     120       17 137        2  NA: 120, Yes: 12, No: 5, Not: 0
    ##     var55      82       55 137        3  NA: 82, Yes: 40, No: 13, Not: 2
    ##  ordered
    ##    FALSE
    ##    FALSE
    ##    FALSE
    ##    FALSE
    ##    FALSE
    ##    FALSE
    ##    FALSE

``` r
days <- svy %>% select(id, var94:var103)
skim(days)
```

    ## Skim summary statistics
    ##  n obs: 137 
    ##  n variables: 10 
    ## 
    ## -- Variable type:character -----------------------------------------------------
    ##  variable missing complete   n min max empty n_unique
    ##        id       0      137 137  11  11     0      137
    ## 
    ## -- Variable type:numeric -------------------------------------------------------
    ##  variable missing complete   n  mean    sd p0 p25  p50  p75 p100     hist
    ##    var100      99       38 137 10.95 15.24  0   3  5.5 10     80 <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##    var101     119       18 137  9.72 14.99  0   2  3.5 10.5   60 <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##    var102     105       32 137 10.03 17.45  0   3  5   10.5  100 <U+2587><U+2582><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##    var103      76       61 137 27    65.77  0   3 10   20    365 <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##     var94      97       40 137 33.1  60.87  0   5 10   25    300 <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##     var96      95       42 137 18.5  33.87  0   2  6.5 20    200 <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##     var97      84       53 137 20.51 63.17  0   3  6   10    364 <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##     var98      36      101 137 21.42 56.13  0   2  5   15    364 <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##     var99      88       49 137  9.94 15.04  0   3  5   10     95 <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>

``` r
days_water <- svy %>% select(id, var57:var66)
skim(days_water)
```

    ## Skim summary statistics
    ##  n obs: 137 
    ##  n variables: 8 
    ## 
    ## -- Variable type:character -----------------------------------------------------
    ##  variable missing complete   n min max empty n_unique
    ##        id       0      137 137  11  11     0      137
    ## 
    ## -- Variable type:numeric -------------------------------------------------------
    ##  variable missing complete   n  mean    sd p0  p25 p50   p75 p100     hist
    ##     var57     109       28 137 12.54 24.09  1 2.75 5   10     100 <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##     var59     116       21 137 12.33 22.09  0 1    4   10      95 <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##     var60      98       39 137 13.85 57.67  0 2    3    6     364 <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##     var61      67       70 137 19.09 58.99  0 2    5    7.75  364 <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##     var63     123       14 137  4.36  6.96  0 1    1.5  4      25 <U+2587><U+2582><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##     var64     125       12 137  5.33  6.98  0 1    3.5  6.25   25 <U+2587><U+2583><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##     var66      97       40 137 10.9  20.64  1 2    5    8.5   100 <U+2587><U+2582><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>

``` r
# activity-basin level
# - basins visited (along water) for each sport
basin <- svy %>% select(id, var70O197:var78O294)
skim(basin)
```

    ## Skim summary statistics
    ##  n obs: 137 
    ##  n variables: 91 
    ## 
    ## -- Variable type:character -----------------------------------------------------
    ##  variable missing complete   n min max empty n_unique
    ##        id       0      137 137  11  11     0      137
    ## 
    ## -- Variable type:factor --------------------------------------------------------
    ##   variable missing complete   n n_unique                top_counts ordered
    ##  var70O197     111       26 137        2  NA: 111, Unc: 19, Che: 7   FALSE
    ##  var70O198     111       26 137        2 NA: 111, Unc: 16, Che: 10   FALSE
    ##  var70O207     111       26 137        2  NA: 111, Unc: 22, Che: 4   FALSE
    ##  var70O208     111       26 137        2 NA: 111, Unc: 16, Che: 10   FALSE
    ##  var70O209     111       26 137        2  NA: 111, Unc: 22, Che: 4   FALSE
    ##  var70O210     111       26 137        2  NA: 111, Unc: 24, Che: 2   FALSE
    ##  var70O211     111       26 137        2  NA: 111, Unc: 20, Che: 6   FALSE
    ##  var70O212     111       26 137        2  NA: 111, Unc: 24, Che: 2   FALSE
    ##  var70O213     111       26 137        2  NA: 111, Unc: 24, Che: 2   FALSE
    ##  var70O214     111       26 137        2  NA: 111, Unc: 25, Che: 1   FALSE
    ##  var71O215     119       18 137        2  NA: 119, Unc: 15, Che: 3   FALSE
    ##  var71O216     119       18 137        2  NA: 119, Unc: 12, Che: 6   FALSE
    ##  var71O217     119       18 137        1  NA: 119, Unc: 18, Che: 0   FALSE
    ##  var71O218     119       18 137        2  NA: 119, Unc: 15, Che: 3   FALSE
    ##  var71O219     119       18 137        2  NA: 119, Unc: 17, Che: 1   FALSE
    ##  var71O220     119       18 137        1  NA: 119, Unc: 18, Che: 0   FALSE
    ##  var71O221     119       18 137        2  NA: 119, Unc: 12, Che: 6   FALSE
    ##  var71O222     119       18 137        2  NA: 119, Unc: 17, Che: 1   FALSE
    ##  var71O223     119       18 137        2  NA: 119, Unc: 17, Che: 1   FALSE
    ##  var71O224     119       18 137        2  NA: 119, Unc: 17, Che: 1   FALSE
    ##  var72O225     100       37 137        2  NA: 100, Unc: 30, Che: 7   FALSE
    ##  var72O226     100       37 137        2 NA: 100, Unc: 24, Che: 13   FALSE
    ##  var72O227     100       37 137        2  NA: 100, Unc: 33, Che: 4   FALSE
    ##  var72O228     100       37 137        2  NA: 100, Unc: 33, Che: 4   FALSE
    ##  var72O229     100       37 137        2  NA: 100, Unc: 32, Che: 5   FALSE
    ##  var72O230     100       37 137        2  NA: 100, Unc: 34, Che: 3   FALSE
    ##  var72O231     100       37 137        2  NA: 100, Unc: 32, Che: 5   FALSE
    ##  var72O232     100       37 137        2  NA: 100, Unc: 34, Che: 3   FALSE
    ##  var72O233     100       37 137        2  NA: 100, Unc: 32, Che: 5   FALSE
    ##  var72O234     100       37 137        1  NA: 100, Unc: 37, Che: 0   FALSE
    ##  var73O235      72       65 137        2  NA: 72, Unc: 55, Che: 10   FALSE
    ##  var73O236      72       65 137        2  NA: 72, Unc: 47, Che: 18   FALSE
    ##  var73O237      72       65 137        2   NA: 72, Unc: 61, Che: 4   FALSE
    ##  var73O238      72       65 137        2  NA: 72, Unc: 42, Che: 23   FALSE
    ##  var73O239      72       65 137        2   NA: 72, Unc: 62, Che: 3   FALSE
    ##  var73O240      72       65 137        2   NA: 72, Unc: 64, Che: 1   FALSE
    ##  var73O241      72       65 137        2  NA: 72, Unc: 47, Che: 18   FALSE
    ##  var73O242      72       65 137        2   NA: 72, Unc: 64, Che: 1   FALSE
    ##  var73O243      72       65 137        2   NA: 72, Unc: 62, Che: 3   FALSE
    ##  var73O244      72       65 137        1   NA: 72, Unc: 65, Che: 0   FALSE
    ##  var74O245      93       44 137        2   NA: 93, Unc: 41, Che: 3   FALSE
    ##  var74O246      93       44 137        2  NA: 93, Unc: 31, Che: 13   FALSE
    ##  var74O247      93       44 137        2   NA: 93, Unc: 41, Che: 3   FALSE
    ##  var74O248      93       44 137        2  NA: 93, Unc: 34, Che: 10   FALSE
    ##  var74O249      93       44 137        2   NA: 93, Unc: 39, Che: 5   FALSE
    ##  var74O250      93       44 137        2   NA: 93, Unc: 39, Che: 5   FALSE
    ##  var74O251      93       44 137        2   NA: 93, Unc: 41, Che: 3   FALSE
    ##  var74O252      93       44 137        2   NA: 93, Unc: 40, Che: 4   FALSE
    ##  var74O253      93       44 137        2   NA: 93, Unc: 38, Che: 6   FALSE
    ##  var74O254      93       44 137        2   NA: 93, Unc: 40, Che: 4   FALSE
    ##  var75O255     126       11 137        2  NA: 126, Unc: 10, Che: 1   FALSE
    ##  var75O256     126       11 137        2   NA: 126, Che: 6, Unc: 5   FALSE
    ##  var75O257     126       11 137        2   NA: 126, Unc: 8, Che: 3   FALSE
    ##  var75O258     126       11 137        1  NA: 126, Unc: 11, Che: 0   FALSE
    ##  var75O259     126       11 137        2  NA: 126, Unc: 10, Che: 1   FALSE
    ##  var75O260     126       11 137        2  NA: 126, Unc: 10, Che: 1   FALSE
    ##  var75O261     126       11 137        1  NA: 126, Unc: 11, Che: 0   FALSE
    ##  var75O262     126       11 137        2  NA: 126, Unc: 10, Che: 1   FALSE
    ##  var75O263     126       11 137        2  NA: 126, Unc: 10, Che: 1   FALSE
    ##  var75O264     126       11 137        1  NA: 126, Unc: 11, Che: 0   FALSE
    ##  var76O265     128        9 137        1   NA: 128, Unc: 9, Che: 0   FALSE
    ##  var76O266     128        9 137        2   NA: 128, Unc: 7, Che: 2   FALSE
    ##  var76O267     128        9 137        2   NA: 128, Unc: 8, Che: 1   FALSE
    ##  var76O268     128        9 137        1   NA: 128, Unc: 9, Che: 0   FALSE
    ##  var76O269     128        9 137        2   NA: 128, Unc: 6, Che: 3   FALSE
    ##  var76O270     128        9 137        1   NA: 128, Unc: 9, Che: 0   FALSE
    ##  var76O271     128        9 137        2   NA: 128, Unc: 7, Che: 2   FALSE
    ##  var76O272     128        9 137        1   NA: 128, Unc: 9, Che: 0   FALSE
    ##  var76O273     128        9 137        2   NA: 128, Unc: 6, Che: 3   FALSE
    ##  var76O274     128        9 137        1   NA: 128, Unc: 9, Che: 0   FALSE
    ##  var77O275     112       25 137        2  NA: 112, Unc: 17, Che: 8   FALSE
    ##  var77O276     112       25 137        2  NA: 112, Unc: 17, Che: 8   FALSE
    ##  var77O277     112       25 137        2  NA: 112, Unc: 20, Che: 5   FALSE
    ##  var77O278     112       25 137        2  NA: 112, Unc: 20, Che: 5   FALSE
    ##  var77O279     112       25 137        2  NA: 112, Unc: 22, Che: 3   FALSE
    ##  var77O280     112       25 137        1  NA: 112, Unc: 25, Che: 0   FALSE
    ##  var77O281     112       25 137        2  NA: 112, Unc: 19, Che: 6   FALSE
    ##  var77O282     112       25 137        2  NA: 112, Unc: 24, Che: 1   FALSE
    ##  var77O283     112       25 137        2  NA: 112, Unc: 22, Che: 3   FALSE
    ##  var77O284     112       25 137        1  NA: 112, Unc: 25, Che: 0   FALSE
    ##  var78O285     100       37 137        2  NA: 100, Unc: 31, Che: 6   FALSE
    ##  var78O286     100       37 137        2 NA: 100, Unc: 26, Che: 11   FALSE
    ##  var78O287     100       37 137        2  NA: 100, Unc: 35, Che: 2   FALSE
    ##  var78O288     100       37 137        2  NA: 100, Unc: 31, Che: 6   FALSE
    ##  var78O289     100       37 137        2  NA: 100, Unc: 33, Che: 4   FALSE
    ##  var78O290     100       37 137        2  NA: 100, Unc: 36, Che: 1   FALSE
    ##  var78O291     100       37 137        2 NA: 100, Unc: 25, Che: 12   FALSE
    ##  var78O292     100       37 137        1  NA: 100, Unc: 37, Che: 0   FALSE
    ##  var78O293     100       37 137        2  NA: 100, Unc: 34, Che: 3   FALSE
    ##  var78O294     100       37 137        1  NA: 100, Unc: 37, Che: 0   FALSE

``` r
basin_days <- svy %>% select(id, var80O197:var88O293)
skim(basin_days)
```

    ## Skim summary statistics
    ##  n obs: 137 
    ##  n variables: 78 
    ## 
    ## -- Variable type:character -----------------------------------------------------
    ##  variable missing complete   n min max empty n_unique
    ##        id       0      137 137  11  11     0      137
    ## 
    ## -- Variable type:numeric -------------------------------------------------------
    ##   variable missing complete   n   mean     sd p0   p25  p50   p75 p100
    ##  var80O197     130        7 137   5      3.92  1  2     5    6.5    12
    ##  var80O198     127       10 137   9.4   12.72  1  1.25  2   10      35
    ##  var80O207     133        4 137   5.25   6.5   2  2     2    5.25   15
    ##  var80O208     127       10 137   9.3   19.69  0  2     2.5  4.75   65
    ##  var80O209     133        4 137   8.75  14.17  1  1.75  2    9      30
    ##  var80O210     135        2 137   1.5    0.71  1  1.25  1.5  1.75    2
    ##  var80O211     131        6 137   8.17  11.67  1  1.5   3    8.25   31
    ##  var80O212     135        2 137   1.5    0.71  1  1.25  1.5  1.75    2
    ##  var80O213     135        2 137   1      0     1  1     1    1       1
    ##  var81O215     134        3 137  16.67  11.55 10 10    10   20      30
    ##  var81O216     131        6 137   4.5    4.28  1  2     2    8      10
    ##  var81O218     134        3 137   8.33   6.51  2  5     8   11.5    15
    ##  var81O219     136        1 137   1     NA     1  1     1    1       1
    ##  var81O220     137        0 137 NaN     NA    NA NA    NA   NA      NA
    ##  var81O221     131        6 137  12.83  17.5   1  1     2.5 23.5    40
    ##  var81O222     136        1 137   3     NA     3  3     3    3       3
    ##  var81O223     136        1 137   1     NA     1  1     1    1       1
    ##  var82O225     130        7 137   2.86   2.34  1  1     2    4       7
    ##  var82O226     124       13 137   2.85   2.54  0  1     2    3      10
    ##  var82O227     133        4 137   6.5    6.19  1  2.5   5    9      15
    ##  var82O228     133        4 137   1.75   1.5   0  0.75  2    3       3
    ##  var82O229     132        5 137  78.6  159.65  0  4    10   15     364
    ##  var82O230     134        3 137   1.33   0.58  1  1     1    1.5     2
    ##  var82O231     132        5 137   3.4    2.07  1  2     3    5       6
    ##  var82O232     134        3 137   2.33   1.53  1  1.5   2    3       4
    ##  var82O233     132        5 137   2      1.22  1  1     2    2       4
    ##  var83O235     127       10 137  12.8   25.9   1  3     3    9      86
    ##  var83O236     119       18 137  13.11  42.18  1  2     3    5     182
    ##  var83O237     133        4 137   2.25   1.71  0  1.5   2.5  3.25    4
    ##  var83O238     114       23 137  20.09  64.01  0  1.5   2    5     300
    ##  var83O239     134        3 137  63.67 102.48  4  4.5   5   93.5   182
    ##  var83O240     136        1 137   2     NA     2  2     2    2       2
    ##  var83O241     119       18 137  13.22  34.89  0  1     3    5.75  150
    ##  var83O242     136        1 137   5     NA     5  5     5    5       5
    ##  var83O243     134        3 137   2      1.73  1  1     1    2.5     4
    ##  var84O245     134        3 137   3.33   3.21  1  1.5   2    4.5     7
    ##  var84O246     124       13 137   4.08   3.04  0  3     4    5      10
    ##  var84O247     134        3 137   4.67   0.58  4  4.5   5    5       5
    ##  var84O248     127       10 137   5.3   10.67  0  0     2    4.5    35
    ##  var84O249     132        5 137   3      0.71  2  3     3    3       4
    ##  var84O250     132        5 137   4.4    5.98  1  1     2    3      15
    ##  var84O251     134        3 137  36.67  33.29 15 17.5  20   47.5    75
    ##  var84O252     133        4 137   1.5    1.73  0  0.75  1    1.75    4
    ##  var84O253     131        6 137   3      3.74  0  0.5   2    3.5    10
    ##  var85O255     136        1 137   1     NA     1  1     1    1       1
    ##  var85O256     131        6 137   3.17   3.49  1  1     2    3      10
    ##  var85O257     134        3 137   3.67   2.31  1  3     5    5       5
    ##  var85O258     137        0 137 NaN     NA    NA NA    NA   NA      NA
    ##  var85O259     136        1 137   4     NA     4  4     4    4       4
    ##  var85O260     136        1 137   1     NA     1  1     1    1       1
    ##  var85O262     136        1 137   4     NA     4  4     4    4       4
    ##  var85O263     136        1 137   5     NA     5  5     5    5       5
    ##  var86O265     137        0 137 NaN     NA    NA NA    NA   NA      NA
    ##  var86O266     135        2 137   1      0     1  1     1    1       1
    ##  var86O267     136        1 137   7     NA     7  7     7    7       7
    ##  var86O269     134        3 137   1.67   1.53  0  1     2    2.5     3
    ##  var86O270     137        0 137 NaN     NA    NA NA    NA   NA      NA
    ##  var86O271     135        2 137   2      1.41  1  1.5   2    2.5     3
    ##  var86O272     137        0 137 NaN     NA    NA NA    NA   NA      NA
    ##  var86O273     134        3 137  10     13.08  1  2.5   4   14.5    25
    ##  var87O275     129        8 137   5.75   5.9   2  2.75  4.5  5      20
    ##  var87O276     129        8 137   3.12   2.3   1  1     2.5  5       7
    ##  var87O277     132        5 137   4.6    3.78  1  2     3    7      10
    ##  var87O278     132        5 137   3.6    3.91  0  1     3    4      10
    ##  var87O279     134        3 137   5      4.58  1  2.5   4    7      10
    ##  var87O281     131        6 137  19.33  39.54  2  2.25  3.5  4.75  100
    ##  var87O282     136        1 137   1     NA     1  1     1    1       1
    ##  var87O283     134        3 137   7      7     2  3     4    9.5    15
    ##  var88O285     131        6 137   8      7.69  1  2.75  5   12.5    20
    ##  var88O286     126       11 137   2.64   2.69  1  1     2    2      10
    ##  var88O287     135        2 137   4.5    0.71  4  4.25  4.5  4.75    5
    ##  var88O288     131        6 137  20.67  36.72  2  3.25  4.5 12.5    95
    ##  var88O289     133        4 137   4.5    3.79  2  2     3    5.5    10
    ##  var88O290     136        1 137   5     NA     5  5     5    5       5
    ##  var88O291     126       11 137  12.27  26.06  1  2.5   4    5      90
    ##  var88O292     137        0 137 NaN     NA    NA NA    NA   NA      NA
    ##  var88O293     134        3 137   3      2.65  0  2     4    4.5     5
    ##      hist
    ##  <U+2587><U+2581><U+2585><U+2581><U+2581><U+2582><U+2581><U+2582>
    ##  <U+2587><U+2581><U+2582><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2582>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2582>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2587>
    ##  <U+2587><U+2581><U+2582><U+2581><U+2581><U+2581><U+2581><U+2582>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2587>
    ##  <U+2581><U+2581><U+2581><U+2587><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2583>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2583>
    ##  <U+2587><U+2581><U+2581><U+2587><U+2581><U+2581><U+2581><U+2587>
    ##  <U+2581><U+2581><U+2581><U+2587><U+2581><U+2581><U+2581><U+2581>
    ##          
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2582><U+2581><U+2582>
    ##  <U+2581><U+2581><U+2581><U+2587><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2581><U+2581><U+2581><U+2587><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2587><U+2582><U+2582><U+2581><U+2581><U+2582><U+2581><U+2582>
    ##  <U+2587><U+2586><U+2586><U+2583><U+2581><U+2581><U+2581><U+2582>
    ##  <U+2587><U+2587><U+2581><U+2587><U+2581><U+2581><U+2581><U+2587>
    ##  <U+2583><U+2581><U+2583><U+2581><U+2581><U+2581><U+2581><U+2587>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2582>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2583>
    ##  <U+2587><U+2587><U+2581><U+2587><U+2581><U+2581><U+2587><U+2587>
    ##  <U+2587><U+2581><U+2587><U+2581><U+2581><U+2581><U+2581><U+2587>
    ##  <U+2587><U+2581><U+2587><U+2581><U+2581><U+2581><U+2581><U+2583>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2587><U+2581><U+2581><U+2587><U+2581><U+2587><U+2581><U+2587>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2583>
    ##  <U+2581><U+2581><U+2581><U+2587><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2581><U+2581><U+2581><U+2587><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2583>
    ##  <U+2587><U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2587>
    ##  <U+2585><U+2581><U+2585><U+2587><U+2581><U+2581><U+2581><U+2583>
    ##  <U+2583><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2587>
    ##  <U+2587><U+2582><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2582><U+2581><U+2581><U+2587><U+2581><U+2581><U+2581><U+2582>
    ##  <U+2587><U+2582><U+2581><U+2581><U+2581><U+2581><U+2581><U+2582>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2583>
    ##  <U+2583><U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2583>
    ##  <U+2587><U+2587><U+2581><U+2583><U+2581><U+2581><U+2581><U+2583>
    ##  <U+2581><U+2581><U+2581><U+2587><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2587><U+2585><U+2581><U+2581><U+2581><U+2581><U+2581><U+2582>
    ##  <U+2583><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2587>
    ##          
    ##  <U+2581><U+2581><U+2581><U+2587><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2581><U+2581><U+2581><U+2587><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2581><U+2581><U+2581><U+2587><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2581><U+2581><U+2581><U+2587><U+2581><U+2581><U+2581><U+2581>
    ##          
    ##  <U+2581><U+2581><U+2581><U+2587><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2581><U+2581><U+2581><U+2587><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2587><U+2581><U+2587>
    ##          
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2587>
    ##          
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2583>
    ##  <U+2587><U+2586><U+2581><U+2581><U+2581><U+2581><U+2581><U+2582>
    ##  <U+2587><U+2582><U+2582><U+2581><U+2581><U+2585><U+2581><U+2582>
    ##  <U+2587><U+2583><U+2581><U+2581><U+2581><U+2583><U+2581><U+2583>
    ##  <U+2587><U+2581><U+2583><U+2583><U+2581><U+2581><U+2581><U+2583>
    ##  <U+2587><U+2581><U+2587><U+2581><U+2581><U+2581><U+2581><U+2587>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2582>
    ##  <U+2581><U+2581><U+2581><U+2587><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2587><U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2587>
    ##  <U+2587><U+2587><U+2581><U+2581><U+2581><U+2583><U+2581><U+2583>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2587>
    ##  <U+2587><U+2582><U+2581><U+2581><U+2581><U+2581><U+2581><U+2582>
    ##  <U+2587><U+2583><U+2581><U+2581><U+2581><U+2581><U+2581><U+2583>
    ##  <U+2581><U+2581><U+2581><U+2587><U+2581><U+2581><U+2581><U+2581>
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581><U+2581>
    ##          
    ##  <U+2587><U+2581><U+2581><U+2581><U+2581><U+2581><U+2587><U+2587>

``` r
# Exhaustive Question Responses -------------------------------------------

Hmisc::describe(person)
```

    ## person 
    ## 
    ##  8  Variables      137  Observations
    ## ---------------------------------------------------------------------------
    ## id  Format:A100 
    ##        n  missing distinct 
    ##      137        0      137 
    ## 
    ## lowest : C2058317730 C2058321874 C2058323362 C2058324714 C2058327255
    ## highest: C2058812154 C2058834635 C2058837196 C2058873223 C2058884744
    ## ---------------------------------------------------------------------------
    ## Vstatus : Status  Format:A100 
    ##        n  missing distinct 
    ##      137        0        2 
    ##                             
    ## Value      Complete  Partial
    ## Frequency       126       11
    ## Proportion     0.92     0.08
    ## ---------------------------------------------------------------------------
    ## var9 : What is your age? 
    ##        n  missing distinct 
    ##      126       11        7 
    ##                                                                       
    ## Value         18 to 24    25 to 34    35 to 44    45 to 54    55 to 64
    ## Frequency           16          30          23          26          11
    ## Proportion       0.127       0.238       0.183       0.206       0.087
    ##                                   
    ## Value         65 to 74 75 or older
    ## Frequency           12           8
    ## Proportion       0.095       0.063
    ## ---------------------------------------------------------------------------
    ## var10 : What is your gender? 
    ##        n  missing distinct 
    ##      126       11        2 
    ##                         
    ## Value        Male Female
    ## Frequency      41     85
    ## Proportion  0.325  0.675
    ## ---------------------------------------------------------------------------
    ## var11 : What is your household income? 
    ##        n  missing distinct 
    ##      126       11        8 
    ## 
    ## Less than $25,000 (20, 0.159), $25,000 to $34,999 (23, 0.183), $35,000 to
    ## $49,999 (17, 0.135), $50,000 to $74,999 (24, 0.190), $75,000 to $99,999
    ## (10, 0.079), $100,000 to $124,999 (11, 0.087), $125,000 to $149,999 (14,
    ## 0.111), $150,000 or more (7, 0.056)
    ## ---------------------------------------------------------------------------
    ## var12 : Please select the choice that best describes your race? 
    ##        n  missing distinct 
    ##      126       11        5 
    ## 
    ## Asian (6, 0.048), Black/African-American (8, 0.063), White (103, 0.817),
    ## American Indian/Alaska Native (2, 0.016), Other (7, 0.056)
    ## ---------------------------------------------------------------------------
    ## var12O59Othr : Other:Please select the choice that best describes your race?  Format:A255 
    ##        n  missing distinct 
    ##        7      130        7 
    ## 
    ## american (1, 0.143), Dominican (1, 0.143), Hispanic (1, 0.143),
    ## Hispanic/Latino (1, 0.143), MEXICAN (1, 0.143), Mexican American (1,
    ## 0.143), unecessary question (1, 0.143)
    ## ---------------------------------------------------------------------------
    ## var13 : Are you of Hispanic, Latino, or Spanish origin? 
    ##        n  missing distinct 
    ##      126       11        2 
    ##                       
    ## Value        Yes    No
    ## Frequency     15   111
    ## Proportion 0.119 0.881
    ## ---------------------------------------------------------------------------

``` r
Hmisc::describe(act)
```

    ## act 
    ## 
    ##  16  Variables      137  Observations
    ## ---------------------------------------------------------------------------
    ## id  Format:A100 
    ##        n  missing distinct 
    ##      137        0      137 
    ## 
    ## lowest : C2058317730 C2058321874 C2058323362 C2058324714 C2058327255
    ## highest: C2058812154 C2058834635 C2058837196 C2058873223 C2058884744
    ## ---------------------------------------------------------------------------
    ## var2O1 : Trail Sports (running 3+ miles on paved/unpaved trail, day-hiking, backpacking, climbing ice or rock, mountaineering, horseback riding):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Chec 
    ##        n  missing distinct 
    ##      137        0        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         95        42
    ## Proportion     0.693     0.307
    ## ---------------------------------------------------------------------------
    ## var2O2 : Bicycling or skateboarding (on paved road or off-road):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply: 
    ##        n  missing distinct 
    ##      137        0        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         95        42
    ## Proportion     0.693     0.307
    ## ---------------------------------------------------------------------------
    ## var2O3 : Camping (RV at campsite, tent campsite, or at a rustic lodge):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply: 
    ##        n  missing distinct 
    ##      137        0        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         81        56
    ## Proportion     0.591     0.409
    ## ---------------------------------------------------------------------------
    ## var2O4 : Picnicking or relaxing:Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply: 
    ##        n  missing distinct 
    ##      137        0        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         34       103
    ## Proportion     0.248     0.752
    ## ---------------------------------------------------------------------------
    ## var2O5 : Water sports (swimming, canoeing, kayaking, rafting, paddle-boarding, sailing, recreating with motorized boat):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply: 
    ##        n  missing distinct 
    ##      137        0        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         86        51
    ## Proportion     0.628     0.372
    ## ---------------------------------------------------------------------------
    ## var2O6 : Snow sports (skiing cross-country/downhill/telemark, snowboarding, snowshoeing):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply: 
    ##        n  missing distinct 
    ##      137        0        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         98        39
    ## Proportion     0.715     0.285
    ## ---------------------------------------------------------------------------
    ## var2O7 : Hunting & shooting (shotgun, rifle, or bow):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply: 
    ##        n  missing distinct 
    ##      137        0        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency        117        20
    ## Proportion     0.854     0.146
    ## ---------------------------------------------------------------------------
    ## var2O8 : Fishing (recreational fly and non-fly):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply: 
    ##        n  missing distinct 
    ##      137        0        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency        103        34
    ## Proportion     0.752     0.248
    ## ---------------------------------------------------------------------------
    ## var2O9 : Wildlife-watching (viewing, feeding, or photographing animals, bird watching):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply: 
    ##        n  missing distinct 
    ##      137        0        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         74        63
    ## Proportion      0.54      0.46
    ## ---------------------------------------------------------------------------
    ## var2O10 : Team competitive sports (softball/baseball, volleyball, soccer, ultimate frisbee):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply: 
    ##        n  missing distinct 
    ##      137        0        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency        125        12
    ## Proportion     0.912     0.088
    ## ---------------------------------------------------------------------------
    ## var2O11 : Off-roading with ATVs, 4x4 trucks:Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply: 
    ##        n  missing distinct 
    ##      137        0        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency        114        23
    ## Proportion     0.832     0.168
    ## ---------------------------------------------------------------------------
    ## var2O12 : Individual competitive sports (golf, tennis):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply: 
    ##        n  missing distinct 
    ##      137        0        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency        115        22
    ## Proportion     0.839     0.161
    ## ---------------------------------------------------------------------------
    ## var2O13 : Motorcycling (on-road, off-road):Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply: 
    ##        n  missing distinct 
    ##      137        0        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency        124        13
    ## Proportion     0.905     0.095
    ## ---------------------------------------------------------------------------
    ## var2O14 : Playground activities:Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply: 
    ##        n  missing distinct 
    ##      137        0        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         97        40
    ## Proportion     0.708     0.292
    ## ---------------------------------------------------------------------------
    ## var2O15 : I didn't participate in any of these activities:Did you participate in any of the following activities in Colorado between December 1, 2018 and November 30, 2019? Check all that apply: 
    ##         n   missing  distinct     value 
    ##       137         0         1 Unchecked 
    ##                     
    ## Value      Unchecked
    ## Frequency        137
    ## Proportion         1
    ## ---------------------------------------------------------------------------

``` r
Hmisc::describe(act_water)
```

    ## act_water 
    ## 
    ##  8  Variables      137  Observations
    ## ---------------------------------------------------------------------------
    ## id  Format:A100 
    ##        n  missing distinct 
    ##      137        0      137 
    ## 
    ## lowest : C2058317730 C2058321874 C2058323362 C2058324714 C2058327255
    ## highest: C2058812154 C2058834635 C2058837196 C2058873223 C2058884744
    ## ---------------------------------------------------------------------------
    ## var47 : Trail Sports (running 3+ miles on paved/unpaved trail, day-hiking, backpacking, climbing ice or rock, mountaineering, horseback riding):Did you participate in any of these activities on or along a body of water (e g  river, lake, reservoir, or stream) in 
    ##        n  missing distinct 
    ##       37      100        2 
    ##                       
    ## Value        Yes    No
    ## Frequency     28     9
    ## Proportion 0.757 0.243
    ## ---------------------------------------------------------------------------
    ## var48 : Bicycling or skateboarding (on paved road or off-road):Did you participate in any of these activities on or along a body of water (e g  river, lake, reservoir, or stream) in Colorado over the twelve months from December 1, 2018 and November 30, 2019? Ple 
    ##        n  missing distinct 
    ##       40       97        2 
    ##                       
    ## Value        Yes    No
    ## Frequency     21    19
    ## Proportion 0.525 0.475
    ## ---------------------------------------------------------------------------
    ## var49 : Camping (RV at campsite, tent campsite, or at a rustic lodge):Did you participate in any of these activities on or along a body of water (e g  river, lake, reservoir, or stream) in Colorado over the twelve months from December 1, 2018 and November 30, 201 
    ##        n  missing distinct 
    ##       50       87        3 
    ##                                      
    ## Value           Yes       No Not Sure
    ## Frequency        39       10        1
    ## Proportion     0.78     0.20     0.02
    ## ---------------------------------------------------------------------------
    ## var50 : Picnicking or relaxing:Did you participate in any of these activities on or along a body of water (e g  river, lake, reservoir, or stream) in Colorado over the twelve months from December 1, 2018 and November 30, 2019? Please only count those days where 
    ##        n  missing distinct 
    ##       95       42        3 
    ##                                      
    ## Value           Yes       No Not Sure
    ## Frequency        70       24        1
    ## Proportion    0.737    0.253    0.011
    ## ---------------------------------------------------------------------------
    ## var52 : Snow sports (skiing cross-country/downhill/telemark, snowboarding, snowshoeing):Did you participate in any of these activities on or along a body of water (e g  river, lake, reservoir, or stream) in Colorado over the twelve months from December 1, 2018 an 
    ##        n  missing distinct 
    ##       36      101        3 
    ##                                      
    ## Value           Yes       No Not Sure
    ## Frequency        14       20        2
    ## Proportion    0.389    0.556    0.056
    ## ---------------------------------------------------------------------------
    ## var53 : Hunting & shooting (shotgun, rifle, or bow):Did you participate in any of these activities on or along a body of water (e g  river, lake, reservoir, or stream) in Colorado over the twelve months from December 1, 2018 and November 30, 2019? Please only co 
    ##        n  missing distinct 
    ##       17      120        2 
    ##                       
    ## Value        Yes    No
    ## Frequency     12     5
    ## Proportion 0.706 0.294
    ## ---------------------------------------------------------------------------
    ## var55 : Wildlife-watching (viewing, feeding, or photographing animals, bird watching):Did you participate in any of these activities on or along a body of water (e g  river, lake, reservoir, or stream) in Colorado over the twelve months from December 1, 2018 and 
    ##        n  missing distinct 
    ##       55       82        3 
    ##                                      
    ## Value           Yes       No Not Sure
    ## Frequency        40       13        2
    ## Proportion    0.727    0.236    0.036
    ## ---------------------------------------------------------------------------

``` r
Hmisc::describe(days)
```

    ## days 
    ## 
    ##  10  Variables      137  Observations
    ## ---------------------------------------------------------------------------
    ## id  Format:A100 
    ##        n  missing distinct 
    ##      137        0      137 
    ## 
    ## lowest : C2058317730 C2058321874 C2058323362 C2058324714 C2058327255
    ## highest: C2058812154 C2058834635 C2058837196 C2058873223 C2058884744
    ## ---------------------------------------------------------------------------
    ## var94 : Trail Sports (running 3+ miles on paved/unpaved trail, day-hiking, backpacking, climbing ice or rock, mountaineering, horseback riding)  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd      .05      .10 
    ##       40       97       20    0.986     33.1     47.5      1.9      2.0 
    ##      .25      .50      .75      .90      .95 
    ##      5.0     10.0     25.0    102.0    161.1 
    ##                                                                       
    ## Value          0     2     3     4     5     7     8    10    14    15
    ## Frequency      2     4     2     1     4     1     1     9     1     2
    ## Proportion 0.050 0.100 0.050 0.025 0.100 0.025 0.025 0.225 0.025 0.050
    ##                                                                       
    ## Value         20    24    25    30    90   100   120   160   183   300
    ## Frequency      1     1     2     3     1     1     1     1     1     1
    ## Proportion 0.025 0.025 0.050 0.075 0.025 0.025 0.025 0.025 0.025 0.025
    ## ---------------------------------------------------------------------------
    ## var96 : Bicycling or skateboarding (on paved road or off-road)  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd      .05      .10 
    ##       42       95       21    0.993     18.5    25.08      1.0      1.0 
    ##      .25      .50      .75      .90      .95 
    ##      2.0      6.5     20.0     43.5     53.8 
    ## 
    ## lowest :   0   1   2   3   4, highest:  45  50  54  90 200
    ## ---------------------------------------------------------------------------
    ## var97 : Camping (RV at campsite, tent campsite, or at a rustic lodge)  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd      .05      .10 
    ##       53       84       20    0.992    20.51    31.67      1.6      2.0 
    ##      .25      .50      .75      .90      .95 
    ##      3.0      6.0     10.0     29.0     35.4 
    ##                                                                       
    ## Value          0     1     2     3     4     5     6     7     8    10
    ## Frequency      2     1     7     6     4     6     5     5     1     5
    ## Proportion 0.038 0.019 0.132 0.113 0.075 0.113 0.094 0.094 0.019 0.094
    ##                                                                       
    ## Value         12    15    18    20    25    30    35    36   300   364
    ## Frequency      1     1     1     1     1     2     1     1     1     1
    ## Proportion 0.019 0.019 0.019 0.019 0.019 0.038 0.019 0.019 0.019 0.019
    ## ---------------------------------------------------------------------------
    ## var98 : Picnicking or relaxing  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd      .05      .10 
    ##      101       36       24     0.99    21.42    32.02        1        2 
    ##      .25      .50      .75      .90      .95 
    ##        2        5       15       30       86 
    ## 
    ## lowest :   0   1   2   3   4, highest:  72  86 100 300 364
    ## ---------------------------------------------------------------------------
    ## var99 : Water sports (swimming, canoeing, kayaking, rafting, paddle-boarding, sailing, recreating with motorized boat)  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd      .05      .10 
    ##       49       88       16    0.984    9.939    11.49        1        2 
    ##      .25      .50      .75      .90      .95 
    ##        3        5       10       22       30 
    ##                                                                       
    ## Value          0     1     2     3     4     5     6     7     9    10
    ## Frequency      2     2     5     6     4    11     3     1     1     3
    ## Proportion 0.041 0.041 0.102 0.122 0.082 0.224 0.061 0.020 0.020 0.061
    ##                                               
    ## Value         12    15    20    30    35    95
    ## Frequency      1     2     3     3     1     1
    ## Proportion 0.020 0.041 0.061 0.061 0.020 0.020
    ## ---------------------------------------------------------------------------
    ## var100 : Snow sports (skiing cross-country/downhill/telemark, snowboarding, snowshoeing)  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd      .05      .10 
    ##       38       99       18    0.989    10.95    13.09      1.0      1.0 
    ##      .25      .50      .75      .90      .95 
    ##      3.0      5.5     10.0     25.9     36.5 
    ##                                                                       
    ## Value          0     1     2     3     4     5     6     7     8    10
    ## Frequency      1     4     3     7     1     3     2     1     2     5
    ## Proportion 0.026 0.105 0.079 0.184 0.026 0.079 0.053 0.026 0.053 0.132
    ##                                                           
    ## Value         15    18    20    25    28    35    45    80
    ## Frequency      2     1     1     1     1     1     1     1
    ## Proportion 0.053 0.026 0.026 0.026 0.026 0.026 0.026 0.026
    ## ---------------------------------------------------------------------------
    ## var101 : Hunting & shooting (shotgun, rifle, or bow)  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd      .05      .10 
    ##       18      119       11     0.96    9.722    13.14     0.85     1.70 
    ##      .25      .50      .75      .90      .95 
    ##     2.00     3.50    10.50    23.00    34.50 
    ##                                                                       
    ## Value          0     1     2     3     4     6    12    19    20    30
    ## Frequency      1     1     6     1     3     1     1     1     1     1
    ## Proportion 0.056 0.056 0.333 0.056 0.167 0.056 0.056 0.056 0.056 0.056
    ##                 
    ## Value         60
    ## Frequency      1
    ## Proportion 0.056
    ## ---------------------------------------------------------------------------
    ## var102 : Fishing (recreational fly and non-fly)  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd      .05      .10 
    ##       32      105       14    0.985    10.03    11.99     0.55     2.00 
    ##      .25      .50      .75      .90      .95 
    ##     3.00     5.00    10.50    19.50    20.00 
    ##                                                                       
    ## Value          0     1     2     3     4     5     6     9    10    12
    ## Frequency      2     1     3     7     2     3     1     1     4     1
    ## Proportion 0.062 0.031 0.094 0.219 0.062 0.094 0.031 0.031 0.125 0.031
    ##                                   
    ## Value         13    15    20   100
    ## Frequency      1     2     3     1
    ## Proportion 0.031 0.062 0.094 0.031
    ## ---------------------------------------------------------------------------
    ## var103 : Wildlife-watching (viewing, feeding, or photographing animals, bird watching)  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd      .05      .10 
    ##       61       76       23    0.993       27    40.75        1        1 
    ##      .25      .50      .75      .90      .95 
    ##        3       10       20       40      100 
    ## 
    ## lowest :   0   1   2   3   4, highest:  48 100 120 350 365
    ## ---------------------------------------------------------------------------

``` r
Hmisc::describe(days_water)
```

    ## days_water 
    ## 
    ##  8  Variables      137  Observations
    ## ---------------------------------------------------------------------------
    ## id  Format:A100 
    ##        n  missing distinct 
    ##      137        0      137 
    ## 
    ## lowest : C2058317730 C2058321874 C2058323362 C2058324714 C2058327255
    ## highest: C2058812154 C2058834635 C2058837196 C2058873223 C2058884744
    ## ---------------------------------------------------------------------------
    ## var57 : You participated in trail sports (running 3+ miles, day-hiking, backpacking, climbing ice or rock, mountaineering, horseback riding) [question('value'), id='94'] days  How many were on or along the water?  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd      .05      .10 
    ##       28      109       12     0.97    12.54    17.08     1.00     1.00 
    ##      .25      .50      .75      .90      .95 
    ##     2.75     5.00    10.00    21.50    67.90 
    ##                                                                       
    ## Value          1     2     3     4     5     7     8    10    20    25
    ## Frequency      4     3     2     1     8     1     1     4     1     1
    ## Proportion 0.143 0.107 0.071 0.036 0.286 0.036 0.036 0.143 0.036 0.036
    ##                       
    ## Value         91   100
    ## Frequency      1     1
    ## Proportion 0.036 0.036
    ## ---------------------------------------------------------------------------
    ## var59 : You participated in bicycling or skateboarding (on paved road or off-road) [question('value'), id='96'] days  How many were on or along the water?  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd      .05      .10 
    ##       21      116       10    0.982    12.33     17.9        0        1 
    ##      .25      .50      .75      .90      .95 
    ##        1        4       10       40       40 
    ##                                                                       
    ## Value          0     1     2     3     4     6    10    15    40    95
    ## Frequency      2     4     1     3     2     1     4     1     2     1
    ## Proportion 0.095 0.190 0.048 0.143 0.095 0.048 0.190 0.048 0.095 0.048
    ## ---------------------------------------------------------------------------
    ## var60 : You participated in camping (RV at campsite, tent campsite, or at a rustic lodge) [question('value'), id='97'] days  How many were on or along the water?  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd      .05      .10 
    ##       39       98       13    0.972    13.85    21.95      1.0      2.0 
    ##      .25      .50      .75      .90      .95 
    ##      2.0      3.0      6.0      8.4     15.5 
    ##                                                                       
    ## Value          0     1     2     3     4     5     6     7     8    10
    ## Frequency      1     2     9     9     1     4     5     2     2     1
    ## Proportion 0.026 0.051 0.231 0.231 0.026 0.103 0.128 0.051 0.051 0.026
    ##                             
    ## Value         15    20   364
    ## Frequency      1     1     1
    ## Proportion 0.026 0.026 0.026
    ## ---------------------------------------------------------------------------
    ## var61 : You participated in picnicking or relaxing [question('value'), id='98'] days  How many were on or along the water?  Format:F5.0 
    ##        n  missing distinct     Info     Mean      Gmd      .05      .10 
    ##       70       67       19    0.977    19.09    30.76     1.00     1.00 
    ##      .25      .50      .75      .90      .95 
    ##     2.00     5.00     7.75    15.00    93.70 
    ##                                                                       
    ## Value          0     1     2     3     4     5     6     7     8     9
    ## Frequency      2    10     9     6     3    18     3     1     2     1
    ## Proportion 0.029 0.143 0.129 0.086 0.043 0.257 0.043 0.014 0.029 0.014
    ##                                                                 
    ## Value         10    13    15    30    86   100   150   300   364
    ## Frequency      5     1     3     1     1     1     1     1     1
    ## Proportion 0.071 0.014 0.043 0.014 0.014 0.014 0.014 0.014 0.014
    ## ---------------------------------------------------------------------------
    ## var63 : You participated in snow sports (skiing cross-country/downhill/telemark, snowboarding, snowshoeing) [question('value'), id='100'] days  How many were on or along the water?  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##       14      123        8    0.967    4.357    6.231 
    ##                                                           
    ## Value          0     1     2     3     4     5    14    25
    ## Frequency      3     4     1     1     2     1     1     1
    ## Proportion 0.214 0.286 0.071 0.071 0.143 0.071 0.071 0.071
    ## ---------------------------------------------------------------------------
    ## var64 : You participated in hunting & shooting (shotgun, rifle, or bow) [question('value'), id='101'] days  How many were on or along the water?  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##       12      125        8    0.979    5.333    6.818 
    ##                                                           
    ## Value          0     1     2     5     6     7    10    25
    ## Frequency      2     3     1     1     2     1     1     1
    ## Proportion 0.167 0.250 0.083 0.083 0.167 0.083 0.083 0.083
    ## ---------------------------------------------------------------------------
    ## var66 : You participated in wildlife-watching (viewing, feeding, or photographing animals, bird watching) [question('value'), id='103'] days  How many were on or along the water?  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd      .05      .10 
    ##       40       97       14    0.979     10.9    14.55     1.00     1.00 
    ##      .25      .50      .75      .90      .95 
    ##     2.00     5.00     8.50    20.50    28.25 
    ##                                                                       
    ## Value          1     2     3     4     5     7     8    10    15    18
    ## Frequency      7     5     2     5     9     1     1     2     1     1
    ## Proportion 0.175 0.125 0.050 0.125 0.225 0.025 0.025 0.050 0.025 0.025
    ##                                   
    ## Value         20    25    90   100
    ## Frequency      2     2     1     1
    ## Proportion 0.050 0.050 0.025 0.025
    ## ---------------------------------------------------------------------------

``` r
Hmisc::describe(basin)
```

    ## basin 
    ## 
    ##  91  Variables      137  Observations
    ## ---------------------------------------------------------------------------
    ## id  Format:A100 
    ##        n  missing distinct 
    ##      137        0      137 
    ## 
    ## lowest : C2058317730 C2058321874 C2058323362 C2058324714 C2058327255
    ## highest: C2058812154 C2058834635 C2058837196 C2058873223 C2058884744
    ## ---------------------------------------------------------------------------
    ## var70O197 : Arkansas River Basin:TRAIL SPORTS 
    ##        n  missing distinct 
    ##       26      111        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         19         7
    ## Proportion     0.731     0.269
    ## ---------------------------------------------------------------------------
    ## var70O198 : Colorado River Basin:TRAIL SPORTS 
    ##        n  missing distinct 
    ##       26      111        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         16        10
    ## Proportion     0.615     0.385
    ## ---------------------------------------------------------------------------
    ## var70O207 : Gunnison River Basin:TRAIL SPORTS 
    ##        n  missing distinct 
    ##       26      111        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         22         4
    ## Proportion     0.846     0.154
    ## ---------------------------------------------------------------------------
    ## var70O208 : Metro Area:TRAIL SPORTS 
    ##        n  missing distinct 
    ##       26      111        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         16        10
    ## Proportion     0.615     0.385
    ## ---------------------------------------------------------------------------
    ## var70O209 : North Platte River Basin:TRAIL SPORTS 
    ##        n  missing distinct 
    ##       26      111        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         22         4
    ## Proportion     0.846     0.154
    ## ---------------------------------------------------------------------------
    ## var70O210 : Rio Grande River Basin:TRAIL SPORTS 
    ##        n  missing distinct 
    ##       26      111        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         24         2
    ## Proportion     0.923     0.077
    ## ---------------------------------------------------------------------------
    ## var70O211 : South Platte River Basin (excluding Metro Area):TRAIL SPORTS 
    ##        n  missing distinct 
    ##       26      111        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         20         6
    ## Proportion     0.769     0.231
    ## ---------------------------------------------------------------------------
    ## var70O212 : Southwest River Basin:TRAIL SPORTS 
    ##        n  missing distinct 
    ##       26      111        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         24         2
    ## Proportion     0.923     0.077
    ## ---------------------------------------------------------------------------
    ## var70O213 : Yampa-White River Basin:TRAIL SPORTS 
    ##        n  missing distinct 
    ##       26      111        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         24         2
    ## Proportion     0.923     0.077
    ## ---------------------------------------------------------------------------
    ## var70O214 : I did not engage in trail sports on or along the water during this time period:TRAIL SPORTS 
    ##        n  missing distinct 
    ##       26      111        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         25         1
    ## Proportion     0.962     0.038
    ## ---------------------------------------------------------------------------
    ## var71O215 : Arkansas River Basin:BICYCLING OR SKATEBOARDING 
    ##        n  missing distinct 
    ##       18      119        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         15         3
    ## Proportion     0.833     0.167
    ## ---------------------------------------------------------------------------
    ## var71O216 : Colorado River Basin:BICYCLING OR SKATEBOARDING 
    ##        n  missing distinct 
    ##       18      119        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         12         6
    ## Proportion     0.667     0.333
    ## ---------------------------------------------------------------------------
    ## var71O217 : Gunnison River Basin:BICYCLING OR SKATEBOARDING 
    ##         n   missing  distinct     value 
    ##        18       119         1 Unchecked 
    ##                     
    ## Value      Unchecked
    ## Frequency         18
    ## Proportion         1
    ## ---------------------------------------------------------------------------
    ## var71O218 : Metro Area:BICYCLING OR SKATEBOARDING 
    ##        n  missing distinct 
    ##       18      119        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         15         3
    ## Proportion     0.833     0.167
    ## ---------------------------------------------------------------------------
    ## var71O219 : North Platte River Basin:BICYCLING OR SKATEBOARDING 
    ##        n  missing distinct 
    ##       18      119        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         17         1
    ## Proportion     0.944     0.056
    ## ---------------------------------------------------------------------------
    ## var71O220 : Rio Grande River Basin:BICYCLING OR SKATEBOARDING 
    ##         n   missing  distinct     value 
    ##        18       119         1 Unchecked 
    ##                     
    ## Value      Unchecked
    ## Frequency         18
    ## Proportion         1
    ## ---------------------------------------------------------------------------
    ## var71O221 : South Platte River Basin (excluding Metro Area):BICYCLING OR SKATEBOARDING 
    ##        n  missing distinct 
    ##       18      119        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         12         6
    ## Proportion     0.667     0.333
    ## ---------------------------------------------------------------------------
    ## var71O222 : Southwest River Basin:BICYCLING OR SKATEBOARDING 
    ##        n  missing distinct 
    ##       18      119        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         17         1
    ## Proportion     0.944     0.056
    ## ---------------------------------------------------------------------------
    ## var71O223 : Yampa-White River Basin:BICYCLING OR SKATEBOARDING 
    ##        n  missing distinct 
    ##       18      119        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         17         1
    ## Proportion     0.944     0.056
    ## ---------------------------------------------------------------------------
    ## var71O224 : I did not engage in bicycling or skateboarding on or along the water during this time period:BICYCLING OR SKATEBOARDING 
    ##        n  missing distinct 
    ##       18      119        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         17         1
    ## Proportion     0.944     0.056
    ## ---------------------------------------------------------------------------
    ## var72O225 : Arkansas River Basin:CAMPING 
    ##        n  missing distinct 
    ##       37      100        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         30         7
    ## Proportion     0.811     0.189
    ## ---------------------------------------------------------------------------
    ## var72O226 : Colorado River Basin:CAMPING 
    ##        n  missing distinct 
    ##       37      100        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         24        13
    ## Proportion     0.649     0.351
    ## ---------------------------------------------------------------------------
    ## var72O227 : Gunnison River Basin:CAMPING 
    ##        n  missing distinct 
    ##       37      100        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         33         4
    ## Proportion     0.892     0.108
    ## ---------------------------------------------------------------------------
    ## var72O228 : Metro Area:CAMPING 
    ##        n  missing distinct 
    ##       37      100        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         33         4
    ## Proportion     0.892     0.108
    ## ---------------------------------------------------------------------------
    ## var72O229 : North Platte River Basin:CAMPING 
    ##        n  missing distinct 
    ##       37      100        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         32         5
    ## Proportion     0.865     0.135
    ## ---------------------------------------------------------------------------
    ## var72O230 : Rio Grande River Basin:CAMPING 
    ##        n  missing distinct 
    ##       37      100        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         34         3
    ## Proportion     0.919     0.081
    ## ---------------------------------------------------------------------------
    ## var72O231 : South Platte River Basin (excluding Metro Area):CAMPING 
    ##        n  missing distinct 
    ##       37      100        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         32         5
    ## Proportion     0.865     0.135
    ## ---------------------------------------------------------------------------
    ## var72O232 : Southwest River Basin:CAMPING 
    ##        n  missing distinct 
    ##       37      100        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         34         3
    ## Proportion     0.919     0.081
    ## ---------------------------------------------------------------------------
    ## var72O233 : Yampa-White River Basin:CAMPING 
    ##        n  missing distinct 
    ##       37      100        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         32         5
    ## Proportion     0.865     0.135
    ## ---------------------------------------------------------------------------
    ## var72O234 : I did not engage in camping on or along the water during this time period:CAMPING 
    ##         n   missing  distinct     value 
    ##        37       100         1 Unchecked 
    ##                     
    ## Value      Unchecked
    ## Frequency         37
    ## Proportion         1
    ## ---------------------------------------------------------------------------
    ## var73O235 : Arkansas River Basin:PICNICKING OR RELAXING 
    ##        n  missing distinct 
    ##       65       72        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         55        10
    ## Proportion     0.846     0.154
    ## ---------------------------------------------------------------------------
    ## var73O236 : Colorado River Basin:PICNICKING OR RELAXING 
    ##        n  missing distinct 
    ##       65       72        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         47        18
    ## Proportion     0.723     0.277
    ## ---------------------------------------------------------------------------
    ## var73O237 : Gunnison River Basin:PICNICKING OR RELAXING 
    ##        n  missing distinct 
    ##       65       72        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         61         4
    ## Proportion     0.938     0.062
    ## ---------------------------------------------------------------------------
    ## var73O238 : Metro Area:PICNICKING OR RELAXING 
    ##        n  missing distinct 
    ##       65       72        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         42        23
    ## Proportion     0.646     0.354
    ## ---------------------------------------------------------------------------
    ## var73O239 : North Platte River Basin:PICNICKING OR RELAXING 
    ##        n  missing distinct 
    ##       65       72        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         62         3
    ## Proportion     0.954     0.046
    ## ---------------------------------------------------------------------------
    ## var73O240 : Rio Grande River Basin:PICNICKING OR RELAXING 
    ##        n  missing distinct 
    ##       65       72        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         64         1
    ## Proportion     0.985     0.015
    ## ---------------------------------------------------------------------------
    ## var73O241 : South Platte River Basin (excluding Metro Area):PICNICKING OR RELAXING 
    ##        n  missing distinct 
    ##       65       72        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         47        18
    ## Proportion     0.723     0.277
    ## ---------------------------------------------------------------------------
    ## var73O242 : Southwest River Basin:PICNICKING OR RELAXING 
    ##        n  missing distinct 
    ##       65       72        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         64         1
    ## Proportion     0.985     0.015
    ## ---------------------------------------------------------------------------
    ## var73O243 : Yampa-White River Basin:PICNICKING OR RELAXING 
    ##        n  missing distinct 
    ##       65       72        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         62         3
    ## Proportion     0.954     0.046
    ## ---------------------------------------------------------------------------
    ## var73O244 : I did not engage in picnicking or relaxing on or along the water during this time period:PICNICKING OR RELAXING 
    ##         n   missing  distinct     value 
    ##        65        72         1 Unchecked 
    ##                     
    ## Value      Unchecked
    ## Frequency         65
    ## Proportion         1
    ## ---------------------------------------------------------------------------
    ## var74O245 : Arkansas River Basin:WATER SPORTS 
    ##        n  missing distinct 
    ##       44       93        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         41         3
    ## Proportion     0.932     0.068
    ## ---------------------------------------------------------------------------
    ## var74O246 : Colorado River Basin:WATER SPORTS 
    ##        n  missing distinct 
    ##       44       93        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         31        13
    ## Proportion     0.705     0.295
    ## ---------------------------------------------------------------------------
    ## var74O247 : Gunnison River Basin:WATER SPORTS 
    ##        n  missing distinct 
    ##       44       93        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         41         3
    ## Proportion     0.932     0.068
    ## ---------------------------------------------------------------------------
    ## var74O248 : Metro Area:WATER SPORTS 
    ##        n  missing distinct 
    ##       44       93        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         34        10
    ## Proportion     0.773     0.227
    ## ---------------------------------------------------------------------------
    ## var74O249 : North Platte River Basin:WATER SPORTS 
    ##        n  missing distinct 
    ##       44       93        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         39         5
    ## Proportion     0.886     0.114
    ## ---------------------------------------------------------------------------
    ## var74O250 : Rio Grande River Basin:WATER SPORTS 
    ##        n  missing distinct 
    ##       44       93        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         39         5
    ## Proportion     0.886     0.114
    ## ---------------------------------------------------------------------------
    ## var74O251 : South Platte River Basin (excluding Metro Area):WATER SPORTS 
    ##        n  missing distinct 
    ##       44       93        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         41         3
    ## Proportion     0.932     0.068
    ## ---------------------------------------------------------------------------
    ## var74O252 : Southwest River Basin:WATER SPORTS 
    ##        n  missing distinct 
    ##       44       93        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         40         4
    ## Proportion     0.909     0.091
    ## ---------------------------------------------------------------------------
    ## var74O253 : Yampa-White River Basin:WATER SPORTS 
    ##        n  missing distinct 
    ##       44       93        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         38         6
    ## Proportion     0.864     0.136
    ## ---------------------------------------------------------------------------
    ## var74O254 : I did not engage in water sports on or along the water during this time period:WATER SPORTS 
    ##        n  missing distinct 
    ##       44       93        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         40         4
    ## Proportion     0.909     0.091
    ## ---------------------------------------------------------------------------
    ## var75O255 : Arkansas River Basin:SNOW SPORTS 
    ##        n  missing distinct 
    ##       11      126        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         10         1
    ## Proportion     0.909     0.091
    ## ---------------------------------------------------------------------------
    ## var75O256 : Colorado River Basin:SNOW SPORTS 
    ##        n  missing distinct 
    ##       11      126        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency          5         6
    ## Proportion     0.455     0.545
    ## ---------------------------------------------------------------------------
    ## var75O257 : Gunnison River Basin:SNOW SPORTS 
    ##        n  missing distinct 
    ##       11      126        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency          8         3
    ## Proportion     0.727     0.273
    ## ---------------------------------------------------------------------------
    ## var75O258 : Metro Area:SNOW SPORTS 
    ##         n   missing  distinct     value 
    ##        11       126         1 Unchecked 
    ##                     
    ## Value      Unchecked
    ## Frequency         11
    ## Proportion         1
    ## ---------------------------------------------------------------------------
    ## var75O259 : North Platte River Basin:SNOW SPORTS 
    ##        n  missing distinct 
    ##       11      126        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         10         1
    ## Proportion     0.909     0.091
    ## ---------------------------------------------------------------------------
    ## var75O260 : Rio Grande River Basin:SNOW SPORTS 
    ##        n  missing distinct 
    ##       11      126        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         10         1
    ## Proportion     0.909     0.091
    ## ---------------------------------------------------------------------------
    ## var75O261 : South Platte River Basin (excluding Metro Area):SNOW SPORTS 
    ##         n   missing  distinct     value 
    ##        11       126         1 Unchecked 
    ##                     
    ## Value      Unchecked
    ## Frequency         11
    ## Proportion         1
    ## ---------------------------------------------------------------------------
    ## var75O262 : Southwest River Basin:SNOW SPORTS 
    ##        n  missing distinct 
    ##       11      126        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         10         1
    ## Proportion     0.909     0.091
    ## ---------------------------------------------------------------------------
    ## var75O263 : Yampa-White River Basin:SNOW SPORTS 
    ##        n  missing distinct 
    ##       11      126        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         10         1
    ## Proportion     0.909     0.091
    ## ---------------------------------------------------------------------------
    ## var75O264 : I did not engage in snow sports on or along the water during this time period:SNOW SPORTS 
    ##         n   missing  distinct     value 
    ##        11       126         1 Unchecked 
    ##                     
    ## Value      Unchecked
    ## Frequency         11
    ## Proportion         1
    ## ---------------------------------------------------------------------------
    ## var76O265 : Arkansas River Basin:HUNTING AND SHOOTING 
    ##         n   missing  distinct     value 
    ##         9       128         1 Unchecked 
    ##                     
    ## Value      Unchecked
    ## Frequency          9
    ## Proportion         1
    ## ---------------------------------------------------------------------------
    ## var76O266 : Colorado River Basin:HUNTING AND SHOOTING 
    ##        n  missing distinct 
    ##        9      128        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency          7         2
    ## Proportion     0.778     0.222
    ## ---------------------------------------------------------------------------
    ## var76O267 : Gunnison River Basin:HUNTING AND SHOOTING 
    ##        n  missing distinct 
    ##        9      128        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency          8         1
    ## Proportion     0.889     0.111
    ## ---------------------------------------------------------------------------
    ## var76O268 : Metro Area:HUNTING AND SHOOTING 
    ##         n   missing  distinct     value 
    ##         9       128         1 Unchecked 
    ##                     
    ## Value      Unchecked
    ## Frequency          9
    ## Proportion         1
    ## ---------------------------------------------------------------------------
    ## var76O269 : North Platte River Basin:HUNTING AND SHOOTING 
    ##        n  missing distinct 
    ##        9      128        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency          6         3
    ## Proportion     0.667     0.333
    ## ---------------------------------------------------------------------------
    ## var76O270 : Rio Grande River Basin:HUNTING AND SHOOTING 
    ##         n   missing  distinct     value 
    ##         9       128         1 Unchecked 
    ##                     
    ## Value      Unchecked
    ## Frequency          9
    ## Proportion         1
    ## ---------------------------------------------------------------------------
    ## var76O271 : South Platte River Basin (excluding Metro Area):HUNTING AND SHOOTING 
    ##        n  missing distinct 
    ##        9      128        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency          7         2
    ## Proportion     0.778     0.222
    ## ---------------------------------------------------------------------------
    ## var76O272 : Southwest River Basin:HUNTING AND SHOOTING 
    ##         n   missing  distinct     value 
    ##         9       128         1 Unchecked 
    ##                     
    ## Value      Unchecked
    ## Frequency          9
    ## Proportion         1
    ## ---------------------------------------------------------------------------
    ## var76O273 : Yampa-White River Basin:HUNTING AND SHOOTING 
    ##        n  missing distinct 
    ##        9      128        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency          6         3
    ## Proportion     0.667     0.333
    ## ---------------------------------------------------------------------------
    ## var76O274 : I did not engage in hunting and shooting on or along the water during this time period:HUNTING AND SHOOTING 
    ##         n   missing  distinct     value 
    ##         9       128         1 Unchecked 
    ##                     
    ## Value      Unchecked
    ## Frequency          9
    ## Proportion         1
    ## ---------------------------------------------------------------------------
    ## var77O275 : Arkansas River Basin:FISHING 
    ##        n  missing distinct 
    ##       25      112        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         17         8
    ## Proportion      0.68      0.32
    ## ---------------------------------------------------------------------------
    ## var77O276 : Colorado River Basin:FISHING 
    ##        n  missing distinct 
    ##       25      112        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         17         8
    ## Proportion      0.68      0.32
    ## ---------------------------------------------------------------------------
    ## var77O277 : Gunnison River Basin:FISHING 
    ##        n  missing distinct 
    ##       25      112        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         20         5
    ## Proportion       0.8       0.2
    ## ---------------------------------------------------------------------------
    ## var77O278 : Metro Area:FISHING 
    ##        n  missing distinct 
    ##       25      112        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         20         5
    ## Proportion       0.8       0.2
    ## ---------------------------------------------------------------------------
    ## var77O279 : North Platte River Basin:FISHING 
    ##        n  missing distinct 
    ##       25      112        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         22         3
    ## Proportion      0.88      0.12
    ## ---------------------------------------------------------------------------
    ## var77O280 : Rio Grande River Basin:FISHING 
    ##         n   missing  distinct     value 
    ##        25       112         1 Unchecked 
    ##                     
    ## Value      Unchecked
    ## Frequency         25
    ## Proportion         1
    ## ---------------------------------------------------------------------------
    ## var77O281 : South Platte River Basin (excluding Metro Area):FISHING 
    ##        n  missing distinct 
    ##       25      112        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         19         6
    ## Proportion      0.76      0.24
    ## ---------------------------------------------------------------------------
    ## var77O282 : Southwest River Basin:FISHING 
    ##        n  missing distinct 
    ##       25      112        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         24         1
    ## Proportion      0.96      0.04
    ## ---------------------------------------------------------------------------
    ## var77O283 : Yampa-White River Basin:FISHING 
    ##        n  missing distinct 
    ##       25      112        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         22         3
    ## Proportion      0.88      0.12
    ## ---------------------------------------------------------------------------
    ## var77O284 : I did not engage in fishing on or along the water during this time period:FISHING 
    ##         n   missing  distinct     value 
    ##        25       112         1 Unchecked 
    ##                     
    ## Value      Unchecked
    ## Frequency         25
    ## Proportion         1
    ## ---------------------------------------------------------------------------
    ## var78O285 : Arkansas River Basin:WILDLIFE-WATCHING 
    ##        n  missing distinct 
    ##       37      100        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         31         6
    ## Proportion     0.838     0.162
    ## ---------------------------------------------------------------------------
    ## var78O286 : Colorado River Basin:WILDLIFE-WATCHING 
    ##        n  missing distinct 
    ##       37      100        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         26        11
    ## Proportion     0.703     0.297
    ## ---------------------------------------------------------------------------
    ## var78O287 : Gunnison River Basin:WILDLIFE-WATCHING 
    ##        n  missing distinct 
    ##       37      100        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         35         2
    ## Proportion     0.946     0.054
    ## ---------------------------------------------------------------------------
    ## var78O288 : Metro Area:WILDLIFE-WATCHING 
    ##        n  missing distinct 
    ##       37      100        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         31         6
    ## Proportion     0.838     0.162
    ## ---------------------------------------------------------------------------
    ## var78O289 : North Platte River Basin:WILDLIFE-WATCHING 
    ##        n  missing distinct 
    ##       37      100        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         33         4
    ## Proportion     0.892     0.108
    ## ---------------------------------------------------------------------------
    ## var78O290 : Rio Grande River Basin:WILDLIFE-WATCHING 
    ##        n  missing distinct 
    ##       37      100        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         36         1
    ## Proportion     0.973     0.027
    ## ---------------------------------------------------------------------------
    ## var78O291 : South Platte River Basin (excluding Metro Area):WILDLIFE-WATCHING 
    ##        n  missing distinct 
    ##       37      100        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         25        12
    ## Proportion     0.676     0.324
    ## ---------------------------------------------------------------------------
    ## var78O292 : Southwest River Basin:WILDLIFE-WATCHING 
    ##         n   missing  distinct     value 
    ##        37       100         1 Unchecked 
    ##                     
    ## Value      Unchecked
    ## Frequency         37
    ## Proportion         1
    ## ---------------------------------------------------------------------------
    ## var78O293 : Yampa-White River Basin:WILDLIFE-WATCHING 
    ##        n  missing distinct 
    ##       37      100        2 
    ##                               
    ## Value      Unchecked   Checked
    ## Frequency         34         3
    ## Proportion     0.919     0.081
    ## ---------------------------------------------------------------------------
    ## var78O294 : I did not engage in wildlife-watching on or along the water during this time period:WILDLIFE-WATCHING 
    ##         n   missing  distinct     value 
    ##        37       100         1 Unchecked 
    ##                     
    ## Value      Unchecked
    ## Frequency         37
    ## Proportion         1
    ## ---------------------------------------------------------------------------

``` r
Hmisc::describe(basin_days)
```

    ## basin_days 
    ## 
    ##  78  Variables      137  Observations
    ## ---------------------------------------------------------------------------
    ## id  Format:A100 
    ##        n  missing distinct 
    ##      137        0      137 
    ## 
    ## lowest : C2058317730 C2058321874 C2058323362 C2058324714 C2058327255
    ## highest: C2058812154 C2058834635 C2058837196 C2058873223 C2058884744
    ## ---------------------------------------------------------------------------
    ## var80O197 : Arkansas River Basin:Of the [question('value'), id='57'] days you participated in TRAIL SPORTS activities on or along the water, how many were spent in each basin? Please count only those days when TRAIL SPORTS were the primary reason of your outing <c2>  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        7      130        5    0.964        5    4.571 
    ##                                         
    ## Value          1     2     5     8    12
    ## Frequency      1     2     2     1     1
    ## Proportion 0.143 0.286 0.286 0.143 0.143
    ## ---------------------------------------------------------------------------
    ## var80O198 : Colorado River Basin:Of the [question('value'), id='57'] days you participated in TRAIL SPORTS activities on or along the water, how many were spent in each basin? Please count only those days when TRAIL SPORTS were the primary reason of your outing <c2>  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##       10      127        5    0.945      9.4    12.84 
    ##                               
    ## Value        1   2  10  30  35
    ## Frequency    3   3   2   1   1
    ## Proportion 0.3 0.3 0.2 0.1 0.1
    ## ---------------------------------------------------------------------------
    ## var80O207 : Gunnison River Basin:Of the [question('value'), id='57'] days you participated in TRAIL SPORTS activities on or along the water, how many were spent in each basin? Please count only those days when TRAIL SPORTS were the primary reason of your outing <c2>  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        4      133        2      0.6     5.25      6.5 
    ##                     
    ## Value         2   15
    ## Frequency     3    1
    ## Proportion 0.75 0.25
    ## ---------------------------------------------------------------------------
    ## var80O208 : Metro Area:Of the [question('value'), id='57'] days you participated in TRAIL SPORTS activities on or along the water, how many were spent in each basin? Please count only those days when TRAIL SPORTS were the primary reason of your outing  If none  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##       10      127        7    0.939      9.3    14.42 
    ##                                       
    ## Value        0   2   3   4   5   8  65
    ## Frequency    1   4   1   1   1   1   1
    ## Proportion 0.1 0.4 0.1 0.1 0.1 0.1 0.1
    ## ---------------------------------------------------------------------------
    ## var80O209 : North Platte River Basin:Of the [question('value'), id='57'] days you participated in TRAIL SPORTS activities on or along the water, how many were spent in each basin? Please count only those days when TRAIL SPORTS were the primary reason of your outi  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        4      133        3      0.9     8.75     14.5 
    ##                          
    ## Value         1    2   30
    ## Frequency     1    2    1
    ## Proportion 0.25 0.50 0.25
    ## ---------------------------------------------------------------------------
    ## var80O210 : Rio Grande River Basin:Of the [question('value'), id='57'] days you participated in TRAIL SPORTS activities on or along the water, how many were spent in each basin? Please count only those days when TRAIL SPORTS were the primary reason of your outing  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        2      135        2        1      1.5        1 
    ##                   
    ## Value        1   2
    ## Frequency    1   1
    ## Proportion 0.5 0.5
    ## ---------------------------------------------------------------------------
    ## var80O211 : South Platte River Basin (excluding Metro Area):Of the [question('value'), id='57'] days you participated in TRAIL SPORTS activities on or along the water, how many were spent in each basin? Please count only those days when TRAIL SPORTS were the prima  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        6      131        4    0.943    8.167     11.8 
    ##                                   
    ## Value          1     3    10    31
    ## Frequency      2     2     1     1
    ## Proportion 0.333 0.333 0.167 0.167
    ## ---------------------------------------------------------------------------
    ## var80O212 : Southwest River Basin:Of the [question('value'), id='57'] days you participated in TRAIL SPORTS activities on or along the water, how many were spent in each basin? Please count only those days when TRAIL SPORTS were the primary reason of your outing  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        2      135        2        1      1.5        1 
    ##                   
    ## Value        1   2
    ## Frequency    1   1
    ## Proportion 0.5 0.5
    ## ---------------------------------------------------------------------------
    ## var80O213 : Yampa-White River Basin:Of the [question('value'), id='57'] days you participated in TRAIL SPORTS activities on or along the water, how many were spent in each basin? Please count only those days when TRAIL SPORTS were the primary reason of your outin  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        2      135        1        0        1        0 
    ##             
    ## Value      1
    ## Frequency  2
    ## Proportion 1
    ## ---------------------------------------------------------------------------
    ## var81O215 : Arkansas River Basin:Of the [question('value'), id='59'] days you participated in BICYCLING OR SKATEBOARDING activities on or along the water, how many were spent in each basin? Please count only those days when BICYCLING OR SKATEBOARDING was the prima  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        3      134        2     0.75    16.67    13.33 
    ##                       
    ## Value         10    30
    ## Frequency      2     1
    ## Proportion 0.667 0.333
    ## ---------------------------------------------------------------------------
    ## var81O216 : Colorado River Basin:Of the [question('value'), id='59'] days you participated in BICYCLING OR SKATEBOARDING activities on or along the water, how many were spent in each basin? Please count only those days when BICYCLING OR SKATEBOARDING was the prima  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        6      131        3    0.857      4.5      4.6 
    ##                             
    ## Value          1     2    10
    ## Frequency      1     3     2
    ## Proportion 0.167 0.500 0.333
    ## ---------------------------------------------------------------------------
    ## var81O218 : Metro Area:Of the [question('value'), id='59'] days you participated in BICYCLING OR SKATEBOARDING activities on or along the water, how many were spent in each basin? Please count only those days when BICYCLING OR SKATEBOARDING was the primary reason<c2>  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        3      134        3        1    8.333    8.667 
    ##                             
    ## Value          2     8    15
    ## Frequency      1     1     1
    ## Proportion 0.333 0.333 0.333
    ## ---------------------------------------------------------------------------
    ## var81O219 : North Platte River Basin:Of the [question('value'), id='59'] days you participated in BICYCLING OR SKATEBOARDING activities on or along the water, how many were spent in each basin? Please count only those days when BICYCLING OR SKATEBOARDING was the p  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        1      136        1        0        1       NA 
    ##             
    ## Value      1
    ## Frequency  1
    ## Proportion 1
    ## ---------------------------------------------------------------------------
    ## var81O221 : South Platte River Basin (excluding Metro Area):Of the [question('value'), id='59'] days you participated in BICYCLING OR SKATEBOARDING activities on or along the water, how many were spent in each basin? Please count only those days when BICYCLING OR S  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        6      131        4    0.886    12.83       19 
    ##                                   
    ## Value          1     4    30    40
    ## Frequency      3     1     1     1
    ## Proportion 0.500 0.167 0.167 0.167
    ## ---------------------------------------------------------------------------
    ## var81O222 : Southwest River Basin:Of the [question('value'), id='59'] days you participated in BICYCLING OR SKATEBOARDING activities on or along the water, how many were spent in each basin? Please count only those days when BICYCLING OR SKATEBOARDING was the prim  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        1      136        1        0        3       NA 
    ##             
    ## Value      3
    ## Frequency  1
    ## Proportion 1
    ## ---------------------------------------------------------------------------
    ## var81O223 : Yampa-White River Basin:Of the [question('value'), id='59'] days you participated in BICYCLING OR SKATEBOARDING activities on or along the water, how many were spent in each basin? Please count only those days when BICYCLING OR SKATEBOARDING was the pr  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        1      136        1        0        1       NA 
    ##             
    ## Value      1
    ## Frequency  1
    ## Proportion 1
    ## ---------------------------------------------------------------------------
    ## var82O225 : Arkansas River Basin:Of the [question('value'), id='60'] days you participated in CAMPING activities on or along the water, how many were spent in each basin? Please count only those days when CAMPING was the primary reason of your outing  If none o  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        7      130        5    0.929    2.857    2.667 
    ##                                         
    ## Value          1     2     3     5     7
    ## Frequency      3     1     1     1     1
    ## Proportion 0.429 0.143 0.143 0.143 0.143
    ## ---------------------------------------------------------------------------
    ## var82O226 : Colorado River Basin:Of the [question('value'), id='60'] days you participated in CAMPING activities on or along the water, how many were spent in each basin? Please count only those days when CAMPING was the primary reason of your outing  If none o  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##       13      124        7    0.967    2.846     2.59 
    ##                                                     
    ## Value          0     1     2     3     4     5    10
    ## Frequency      1     3     3     3     1     1     1
    ## Proportion 0.077 0.231 0.231 0.231 0.077 0.077 0.077
    ## ---------------------------------------------------------------------------
    ## var82O227 : Gunnison River Basin:Of the [question('value'), id='60'] days you participated in CAMPING activities on or along the water, how many were spent in each basin? Please count only those days when CAMPING was the primary reason of your outing  If none o  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        4      133        4        1      6.5    7.667 
    ##                               
    ## Value         1    3    7   15
    ## Frequency     1    1    1    1
    ## Proportion 0.25 0.25 0.25 0.25
    ## ---------------------------------------------------------------------------
    ## var82O228 : Metro Area:Of the [question('value'), id='60'] days you participated in CAMPING activities on or along the water, how many were spent in each basin? Please count only those days when CAMPING was the primary reason of your outing  If none of your out  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        4      133        3      0.9     1.75    1.833 
    ##                          
    ## Value         0    1    3
    ## Frequency     1    1    2
    ## Proportion 0.25 0.25 0.50
    ## ---------------------------------------------------------------------------
    ## var82O229 : North Platte River Basin:Of the [question('value'), id='60'] days you participated in CAMPING activities on or along the water, how many were spent in each basin? Please count only those days when CAMPING was the primary reason of your outing  If no  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        5      132        5        1     78.6    147.8 
    ##                               
    ## Value        0   4  10  15 364
    ## Frequency    1   1   1   1   1
    ## Proportion 0.2 0.2 0.2 0.2 0.2
    ## ---------------------------------------------------------------------------
    ## var82O230 : Rio Grande River Basin:Of the [question('value'), id='60'] days you participated in CAMPING activities on or along the water, how many were spent in each basin? Please count only those days when CAMPING was the primary reason of your outing  If none  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        3      134        2     0.75    1.333   0.6667 
    ##                       
    ## Value          1     2
    ## Frequency      2     1
    ## Proportion 0.667 0.333
    ## ---------------------------------------------------------------------------
    ## var82O231 : South Platte River Basin (excluding Metro Area):Of the [question('value'), id='60'] days you participated in CAMPING activities on or along the water, how many were spent in each basin? Please count only those days when CAMPING was the primary reason   Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        5      132        5        1      3.4      2.6 
    ##                               
    ## Value        1   2   3   5   6
    ## Frequency    1   1   1   1   1
    ## Proportion 0.2 0.2 0.2 0.2 0.2
    ## ---------------------------------------------------------------------------
    ## var82O232 : Southwest River Basin:Of the [question('value'), id='60'] days you participated in CAMPING activities on or along the water, how many were spent in each basin? Please count only those days when CAMPING was the primary reason of your outing  If none  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        3      134        3        1    2.333        2 
    ##                             
    ## Value          1     2     4
    ## Frequency      1     1     1
    ## Proportion 0.333 0.333 0.333
    ## ---------------------------------------------------------------------------
    ## var82O233 : Yampa-White River Basin:Of the [question('value'), id='60'] days you participated in CAMPING activities on or along the water, how many were spent in each basin? Please count only those days when CAMPING was the primary reason of your outing  If non  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        5      132        3      0.9        2      1.4 
    ##                       
    ## Value        1   2   4
    ## Frequency    2   2   1
    ## Proportion 0.4 0.4 0.2
    ## ---------------------------------------------------------------------------
    ## var83O235 : Arkansas River Basin:Of the [question('value'), id='61'] days you participated in PICNICKING OR RELAXING activities on or along the water, how many were spent in each basin? Please count only those days when PICNICKING OR RELAXING was the primary reaso  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##       10      127        5    0.873     12.8    19.07 
    ##                               
    ## Value        1   3   6  10  86
    ## Frequency    1   5   1   2   1
    ## Proportion 0.1 0.5 0.1 0.2 0.1
    ## ---------------------------------------------------------------------------
    ## var83O236 : Colorado River Basin:Of the [question('value'), id='61'] days you participated in PICNICKING OR RELAXING activities on or along the water, how many were spent in each basin? Please count only those days when PICNICKING OR RELAXING was the primary reaso  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##       18      119        6    0.947    13.11    21.52 
    ##                                               
    ## Value          1     2     3     5     7   182
    ## Frequency      2     5     5     4     1     1
    ## Proportion 0.111 0.278 0.278 0.222 0.056 0.056
    ## ---------------------------------------------------------------------------
    ## var83O237 : Gunnison River Basin:Of the [question('value'), id='61'] days you participated in PICNICKING OR RELAXING activities on or along the water, how many were spent in each basin? Please count only those days when PICNICKING OR RELAXING was the primary reaso  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        4      133        4        1     2.25    2.167 
    ##                               
    ## Value         0    2    3    4
    ## Frequency     1    1    1    1
    ## Proportion 0.25 0.25 0.25 0.25
    ## ---------------------------------------------------------------------------
    ## var83O238 : Metro Area:Of the [question('value'), id='61'] days you participated in PICNICKING OR RELAXING activities on or along the water, how many were spent in each basin? Please count only those days when PICNICKING OR RELAXING was the primary reason of your  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd      .05      .10 
    ##       23      114       10    0.972    20.09    35.57      0.1      1.0 
    ##      .25      .50      .75      .90      .95 
    ##      1.5      2.0      5.0     10.8     86.6 
    ##                                                                       
    ## Value          0     1     2     3     4     5    10    11    95   300
    ## Frequency      2     4     6     2     1     4     1     1     1     1
    ## Proportion 0.087 0.174 0.261 0.087 0.043 0.174 0.043 0.043 0.043 0.043
    ## ---------------------------------------------------------------------------
    ## var83O239 : North Platte River Basin:Of the [question('value'), id='61'] days you participated in PICNICKING OR RELAXING activities on or along the water, how many were spent in each basin? Please count only those days when PICNICKING OR RELAXING was the primary r  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        3      134        3        1    63.67    118.7 
    ##                             
    ## Value          4     5   182
    ## Frequency      1     1     1
    ## Proportion 0.333 0.333 0.333
    ## ---------------------------------------------------------------------------
    ## var83O240 : Rio Grande River Basin:Of the [question('value'), id='61'] days you participated in PICNICKING OR RELAXING activities on or along the water, how many were spent in each basin? Please count only those days when PICNICKING OR RELAXING was the primary rea  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        1      136        1        0        2       NA 
    ##             
    ## Value      2
    ## Frequency  1
    ## Proportion 1
    ## ---------------------------------------------------------------------------
    ## var83O241 : South Platte River Basin (excluding Metro Area):Of the [question('value'), id='61'] days you participated in PICNICKING OR RELAXING activities on or along the water, how many were spent in each basin? Please count only those days when PICNICKING OR RELA  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd      .05      .10 
    ##       18      119       10    0.959    13.22    21.86     0.85     1.00 
    ##      .25      .50      .75      .90      .95 
    ##     1.00     3.00     5.75    19.50    48.00 
    ##                                                                       
    ## Value          0     1     2     3     5     6    10    15    30   150
    ## Frequency      1     5     1     5     1     1     1     1     1     1
    ## Proportion 0.056 0.278 0.056 0.278 0.056 0.056 0.056 0.056 0.056 0.056
    ## ---------------------------------------------------------------------------
    ## var83O242 : Southwest River Basin:Of the [question('value'), id='61'] days you participated in PICNICKING OR RELAXING activities on or along the water, how many were spent in each basin? Please count only those days when PICNICKING OR RELAXING was the primary reas  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        1      136        1        0        5       NA 
    ##             
    ## Value      5
    ## Frequency  1
    ## Proportion 1
    ## ---------------------------------------------------------------------------
    ## var83O243 : Yampa-White River Basin:Of the [question('value'), id='61'] days you participated in PICNICKING OR RELAXING activities on or along the water, how many were spent in each basin? Please count only those days when PICNICKING OR RELAXING was the primary re  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        3      134        2     0.75        2        2 
    ##                       
    ## Value          1     4
    ## Frequency      2     1
    ## Proportion 0.667 0.333
    ## ---------------------------------------------------------------------------
    ## var84O245 : Arkansas River Basin:Of the [question('value'), id='99'] days you participated in WATER SPORT activities on or along the water, how many were spent in each basin? Please count only those days when WATER SPORTS were the primary reason of your outing    Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        3      134        3        1    3.333        4 
    ##                             
    ## Value          1     2     7
    ## Frequency      1     1     1
    ## Proportion 0.333 0.333 0.333
    ## ---------------------------------------------------------------------------
    ## var84O246 : Colorado River Basin:Of the [question('value'), id='99'] days you participated in WATER SPORT activities on or along the water, how many were spent in each basin? Please count only those days when WATER SPORTS were the primary reason of your outing    Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##       13      124        6     0.97    4.077    3.333 
    ##                                               
    ## Value          0     1     3     4     5    10
    ## Frequency      1     2     3     3     2     2
    ## Proportion 0.077 0.154 0.231 0.231 0.154 0.154
    ## ---------------------------------------------------------------------------
    ## var84O247 : Gunnison River Basin:Of the [question('value'), id='99'] days you participated in WATER SPORT activities on or along the water, how many were spent in each basin? Please count only those days when WATER SPORTS were the primary reason of your outing    Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        3      134        2     0.75    4.667   0.6667 
    ##                       
    ## Value          4     5
    ## Frequency      1     2
    ## Proportion 0.333 0.667
    ## ---------------------------------------------------------------------------
    ## var84O248 : Metro Area:Of the [question('value'), id='99'] days you participated in WATER SPORT activities on or along the water, how many were spent in each basin? Please count only those days when WATER SPORTS were the primary reason of your outing  If none o  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##       10      127        6    0.933      5.3    8.733 
    ##                                   
    ## Value        0   1   3   5   6  35
    ## Frequency    4   1   2   1   1   1
    ## Proportion 0.4 0.1 0.2 0.1 0.1 0.1
    ## ---------------------------------------------------------------------------
    ## var84O249 : North Platte River Basin:Of the [question('value'), id='99'] days you participated in WATER SPORT activities on or along the water, how many were spent in each basin? Please count only those days when WATER SPORTS were the primary reason of your outin  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        5      132        3      0.8        3      0.8 
    ##                       
    ## Value        2   3   4
    ## Frequency    1   3   1
    ## Proportion 0.2 0.6 0.2
    ## ---------------------------------------------------------------------------
    ## var84O250 : Rio Grande River Basin:Of the [question('value'), id='99'] days you participated in WATER SPORT activities on or along the water, how many were spent in each basin? Please count only those days when WATER SPORTS were the primary reason of your outing  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        5      132        4     0.95      4.4        6 
    ##                           
    ## Value        1   2   3  15
    ## Frequency    2   1   1   1
    ## Proportion 0.4 0.2 0.2 0.2
    ## ---------------------------------------------------------------------------
    ## var84O251 : South Platte River Basin (excluding Metro Area):Of the [question('value'), id='99'] days you participated in WATER SPORT activities on or along the water, how many were spent in each basin? Please count only those days when WATER SPORTS were the primar  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        3      134        3        1    36.67       40 
    ##                             
    ## Value         15    20    75
    ## Frequency      1     1     1
    ## Proportion 0.333 0.333 0.333
    ## ---------------------------------------------------------------------------
    ## var84O252 : Southwest River Basin:Of the [question('value'), id='99'] days you participated in WATER SPORT activities on or along the water, how many were spent in each basin? Please count only those days when WATER SPORTS were the primary reason of your outing <c2>  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        4      133        3      0.9      1.5        2 
    ##                          
    ## Value         0    1    4
    ## Frequency     1    2    1
    ## Proportion 0.25 0.50 0.25
    ## ---------------------------------------------------------------------------
    ## var84O253 : Yampa-White River Basin:Of the [question('value'), id='99'] days you participated in WATER SPORT activities on or along the water, how many were spent in each basin? Please count only those days when WATER SPORTS were the primary reason of your outing  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        6      131        4    0.943        3    4.133 
    ##                                   
    ## Value          0     2     4    10
    ## Frequency      2     2     1     1
    ## Proportion 0.333 0.333 0.167 0.167
    ## ---------------------------------------------------------------------------
    ## var85O255 : Arkansas River Basin:Of the [question('value'), id='63'] days you participated in SNOW SPORT activities on or along the water, how many were spent in each basin? Please count only those days when SNOW SPORTS were the primary reason of your outing  If  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        1      136        1        0        1       NA 
    ##             
    ## Value      1
    ## Frequency  1
    ## Proportion 1
    ## ---------------------------------------------------------------------------
    ## var85O256 : Colorado River Basin:Of the [question('value'), id='63'] days you participated in SNOW SPORT activities on or along the water, how many were spent in each basin? Please count only those days when SNOW SPORTS were the primary reason of your outing  If  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        6      131        3    0.857    3.167    3.533 
    ##                             
    ## Value          1     3    10
    ## Frequency      3     2     1
    ## Proportion 0.500 0.333 0.167
    ## ---------------------------------------------------------------------------
    ## var85O257 : Gunnison River Basin:Of the [question('value'), id='63'] days you participated in SNOW SPORT activities on or along the water, how many were spent in each basin? Please count only those days when SNOW SPORTS were the primary reason of your outing  If  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        3      134        2     0.75    3.667    2.667 
    ##                       
    ## Value          1     5
    ## Frequency      1     2
    ## Proportion 0.333 0.667
    ## ---------------------------------------------------------------------------
    ## var85O259 : North Platte River Basin:Of the [question('value'), id='63'] days you participated in SNOW SPORT activities on or along the water, how many were spent in each basin? Please count only those days when SNOW SPORTS were the primary reason of your outing  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        1      136        1        0        4       NA 
    ##             
    ## Value      4
    ## Frequency  1
    ## Proportion 1
    ## ---------------------------------------------------------------------------
    ## var85O260 : Rio Grande River Basin:Of the [question('value'), id='63'] days you participated in SNOW SPORT activities on or along the water, how many were spent in each basin? Please count only those days when SNOW SPORTS were the primary reason of your outing    Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        1      136        1        0        1       NA 
    ##             
    ## Value      1
    ## Frequency  1
    ## Proportion 1
    ## ---------------------------------------------------------------------------
    ## var85O262 : Southwest River Basin:Of the [question('value'), id='63'] days you participated in SNOW SPORT activities on or along the water, how many were spent in each basin? Please count only those days when SNOW SPORTS were the primary reason of your outing  I  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        1      136        1        0        4       NA 
    ##             
    ## Value      4
    ## Frequency  1
    ## Proportion 1
    ## ---------------------------------------------------------------------------
    ## var85O263 : Yampa-White River Basin:Of the [question('value'), id='63'] days you participated in SNOW SPORT activities on or along the water, how many were spent in each basin? Please count only those days when SNOW SPORTS were the primary reason of your outing <c2>  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        1      136        1        0        5       NA 
    ##             
    ## Value      5
    ## Frequency  1
    ## Proportion 1
    ## ---------------------------------------------------------------------------
    ## var86O266 : Colorado River Basin:Of the [question('value'), id='64'] days you participated in HUNTING & SHOOTING activities on or along the water, how many were spent in each basin? Please count only those days when HUNTING & SHOOTING was the primary reason of yo  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        2      135        1        0        1        0 
    ##             
    ## Value      1
    ## Frequency  2
    ## Proportion 1
    ## ---------------------------------------------------------------------------
    ## var86O267 : Gunnison River Basin:Of the [question('value'), id='64'] days you participated in HUNTING & SHOOTING activities on or along the water, how many were spent in each basin? Please count only those days when HUNTING & SHOOTING was the primary reason of yo  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        1      136        1        0        7       NA 
    ##             
    ## Value      7
    ## Frequency  1
    ## Proportion 1
    ## ---------------------------------------------------------------------------
    ## var86O269 : North Platte River Basin:Of the [question('value'), id='64'] days you participated in HUNTING & SHOOTING activities on or along the water, how many were spent in each basin? Please count only those days when HUNTING & SHOOTING was the primary reason o  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        3      134        3        1    1.667        2 
    ##                             
    ## Value          0     2     3
    ## Frequency      1     1     1
    ## Proportion 0.333 0.333 0.333
    ## ---------------------------------------------------------------------------
    ## var86O271 : South Platte River Basin (excluding Metro Area):Of the [question('value'), id='64'] days you participated in HUNTING & SHOOTING activities on or along the water, how many were spent in each basin? Please count only those days when HUNTING & SHOOTING was  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        2      135        2        1        2        2 
    ##                   
    ## Value        1   3
    ## Frequency    1   1
    ## Proportion 0.5 0.5
    ## ---------------------------------------------------------------------------
    ## var86O273 : Yampa-White River Basin:Of the [question('value'), id='64'] days you participated in HUNTING & SHOOTING activities on or along the water, how many were spent in each basin? Please count only those days when HUNTING & SHOOTING was the primary reason of  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        3      134        3        1       10       16 
    ##                             
    ## Value          1     4    25
    ## Frequency      1     1     1
    ## Proportion 0.333 0.333 0.333
    ## ---------------------------------------------------------------------------
    ## var87O275 : Arkansas River Basin:Of the [question('value'), id='102'] days you participated in FISHING activities on or along the water, how many were spent in each basin? Please count only those days when FISHING was the primary reason of your outing  If none  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        8      129        5     0.94     5.75    5.286 
    ##                                         
    ## Value          2     3     4     5    20
    ## Frequency      2     1     1     3     1
    ## Proportion 0.250 0.125 0.125 0.375 0.125
    ## ---------------------------------------------------------------------------
    ## var87O276 : Colorado River Basin:Of the [question('value'), id='102'] days you participated in FISHING activities on or along the water, how many were spent in each basin? Please count only those days when FISHING was the primary reason of your outing  If none  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        8      129        5     0.94    3.125    2.679 
    ##                                         
    ## Value          1     2     3     5     7
    ## Frequency      3     1     1     2     1
    ## Proportion 0.375 0.125 0.125 0.250 0.125
    ## ---------------------------------------------------------------------------
    ## var87O277 : Gunnison River Basin:Of the [question('value'), id='102'] days you participated in FISHING activities on or along the water, how many were spent in each basin? Please count only those days when FISHING was the primary reason of your outing  If none  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        5      132        5        1      4.6      4.6 
    ##                               
    ## Value        1   2   3   7  10
    ## Frequency    1   1   1   1   1
    ## Proportion 0.2 0.2 0.2 0.2 0.2
    ## ---------------------------------------------------------------------------
    ## var87O278 : Metro Area:Of the [question('value'), id='102'] days you participated in FISHING activities on or along the water, how many were spent in each basin? Please count only those days when FISHING was the primary reason of your outing  If none of your ou  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        5      132        5        1      3.6      4.6 
    ##                               
    ## Value        0   1   3   4  10
    ## Frequency    1   1   1   1   1
    ## Proportion 0.2 0.2 0.2 0.2 0.2
    ## ---------------------------------------------------------------------------
    ## var87O279 : North Platte River Basin:Of the [question('value'), id='102'] days you participated in FISHING activities on or along the water, how many were spent in each basin? Please count only those days when FISHING was the primary reason of your outing  If n  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        3      134        3        1        5        6 
    ##                             
    ## Value          1     4    10
    ## Frequency      1     1     1
    ## Proportion 0.333 0.333 0.333
    ## ---------------------------------------------------------------------------
    ## var87O281 : South Platte River Basin (excluding Metro Area):Of the [question('value'), id='102'] days you participated in FISHING activities on or along the water, how many were spent in each basin? Please count only those days when FISHING was the primary reason<c2>  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        6      131        5    0.971    19.33    33.33 
    ##                                         
    ## Value          2     3     4     5   100
    ## Frequency      2     1     1     1     1
    ## Proportion 0.333 0.167 0.167 0.167 0.167
    ## ---------------------------------------------------------------------------
    ## var87O282 : Southwest River Basin:Of the [question('value'), id='102'] days you participated in FISHING activities on or along the water, how many were spent in each basin? Please count only those days when FISHING was the primary reason of your outing  If none  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        1      136        1        0        1       NA 
    ##             
    ## Value      1
    ## Frequency  1
    ## Proportion 1
    ## ---------------------------------------------------------------------------
    ## var87O283 : Yampa-White River Basin:Of the [question('value'), id='102'] days you participated in FISHING activities on or along the water, how many were spent in each basin? Please count only those days when FISHING was the primary reason of your outing  If no  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        3      134        3        1        7    8.667 
    ##                             
    ## Value          2     4    15
    ## Frequency      1     1     1
    ## Proportion 0.333 0.333 0.333
    ## ---------------------------------------------------------------------------
    ## var88O285 : Arkansas River Basin:Of the [question('value'), id='66'] days you participated in WILDLIFE-WATCHING activities on or along the water, how many were spent in each basin? Please count only those days when WILDLIFE-WATCHING was the primary reason of your  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        6      131        5    0.971        8    8.933 
    ##                                         
    ## Value          1     2     5    15    20
    ## Frequency      1     1     2     1     1
    ## Proportion 0.167 0.167 0.333 0.167 0.167
    ## ---------------------------------------------------------------------------
    ## var88O286 : Colorado River Basin:Of the [question('value'), id='66'] days you participated in WILDLIFE-WATCHING activities on or along the water, how many were spent in each basin? Please count only those days when WILDLIFE-WATCHING was the primary reason of your  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##       11      126        4    0.864    2.636      2.4 
    ##                                   
    ## Value          1     2     5    10
    ## Frequency      4     5     1     1
    ## Proportion 0.364 0.455 0.091 0.091
    ## ---------------------------------------------------------------------------
    ## var88O287 : Gunnison River Basin:Of the [question('value'), id='66'] days you participated in WILDLIFE-WATCHING activities on or along the water, how many were spent in each basin? Please count only those days when WILDLIFE-WATCHING was the primary reason of your  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        2      135        2        1      4.5        1 
    ##                   
    ## Value        4   5
    ## Frequency    1   1
    ## Proportion 0.5 0.5
    ## ---------------------------------------------------------------------------
    ## var88O288 : Metro Area:Of the [question('value'), id='66'] days you participated in WILDLIFE-WATCHING activities on or along the water, how many were spent in each basin? Please count only those days when WILDLIFE-WATCHING was the primary reason of your outing    Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        6      131        6        1    20.67    33.47 
    ##                                               
    ## Value          2     3     4     5    15    95
    ## Frequency      1     1     1     1     1     1
    ## Proportion 0.167 0.167 0.167 0.167 0.167 0.167
    ## ---------------------------------------------------------------------------
    ## var88O289 : North Platte River Basin:Of the [question('value'), id='66'] days you participated in WILDLIFE-WATCHING activities on or along the water, how many were spent in each basin? Please count only those days when WILDLIFE-WATCHING was the primary reason of  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        4      133        3      0.9      4.5    4.333 
    ##                          
    ## Value         2    4   10
    ## Frequency     2    1    1
    ## Proportion 0.50 0.25 0.25
    ## ---------------------------------------------------------------------------
    ## var88O290 : Rio Grande River Basin:Of the [question('value'), id='66'] days you participated in WILDLIFE-WATCHING activities on or along the water, how many were spent in each basin? Please count only those days when WILDLIFE-WATCHING was the primary reason of yo  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        1      136        1        0        5       NA 
    ##             
    ## Value      5
    ## Frequency  1
    ## Proportion 1
    ## ---------------------------------------------------------------------------
    ## var88O291 : South Platte River Basin (excluding Metro Area):Of the [question('value'), id='66'] days you participated in WILDLIFE-WATCHING activities on or along the water, how many were spent in each basin? Please count only those days when WILDLIFE-WATCHING was t  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##       11      126        7    0.973    12.27    18.73 
    ##                                                     
    ## Value          1     2     3     4     5    15    90
    ## Frequency      2     1     1     2     3     1     1
    ## Proportion 0.182 0.091 0.091 0.182 0.273 0.091 0.091
    ## ---------------------------------------------------------------------------
    ## var88O293 : Yampa-White River Basin:Of the [question('value'), id='66'] days you participated in WILDLIFE-WATCHING activities on or along the water, how many were spent in each basin? Please count only those days when WILDLIFE-WATCHING was the primary reason of y  Format:F8.0 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##        3      134        3        1        3    3.333 
    ##                             
    ## Value          0     4     5
    ## Frequency      1     1     1
    ## Proportion 0.333 0.333 0.333
    ## ---------------------------------------------------------------------------
    ## 
    ## Variables with all observations missing:
    ## 
    ## [1] var81O220 var85O258 var86O265 var86O270 var86O272 var88O292
