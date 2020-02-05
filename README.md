
## Overview

For Southwick internal use only; Dan's portion of the analysis for the B4W-19-01 project:

- CO survey prep: [data-work/1-svy/svy-final-csv.zip](data-work/1-svy/svy-final-csv.zip)
- OIA-based tgtRate: 77.1%
- Spending profiles: [out/profile-2019.xlsx](out/profile-2019.xlsx)
- Report figures: [out/fig](out/fig)

The analysis can be reproduced from `code/run.R`.

### Software Environment

This project was setup using package [saproj](https://github.com/southwick-associates/saproj) with a [Southwick-specific R Setup](https://github.com/southwick-associates/R-setup). Two files shouldn't be edited by hand:

- `.Rprofile` specifies R version and project library
- `snapshot-library.csv` details project-specific packages

## CO Survey Data

Survey details are available on O365 > B4W-19-01:

- [Survey Data Dictionary](https://southwickassociatesinc.sharepoint.com/:x:/s/B4W-19-01/EUfzP3tm7O5Kpim_RuhzFzABWy7W_i-17pSKllDirAeU9g?e=LAeALG)
- [Questionnaire](https://southwickassociatesinc.sharepoint.com/:w:/s/B4W-19-01/ESlQqzDJbg5BplbAPakEnoEBL8F7pUZLftXywcK4F01exA?e=hfEiig)

### Weighting

The dataset was weighted on 4 demographic variables. For an overview:  [code/1-svy/weight-summary.md](code/1-svy/weight-summary.md)

### Respondent Flagging

Flagging was done to (1) assign valid quotas for IPSOS, and (2) remove unreliable respondents. Data is stored in `out/1-svy`:

- `flags-all.csv`: all flagged values
- `flags-core.csv`: respondents that didn't make the cut for the IPSOS quota
- `flags-ipsos-okay.csv`: respondents that did make the quota (shared with IPSOS by Lisa B)

For an overview: [code/1-svy/flag-summary.md](code/1-svy/flag-summary.md)

### Outlier Removal

Days outliers were identified using [Tukey's rule]( https://en.wikipedia.org/wiki/Outlier#Tukey%27s_fences) with a slight modification to log transform the variables prior to running the test (to provide a more normal distribution). Three days variables were recoded to some degree:

- `act$days`: Overall days had any outliers set to missing
- `act$water_days`: Water-specific days had any outliers set to missing, and were also set to missing where `act$days` was set to missing
- `basin$water_days`: Basin-level days were top-coded such that outliers were set to the top Tukey fence, to avoid losing data when estimating share of activity for each basin.

For a code summary:  [code/1-svy/log/7-recode-outliers.md](code/1-svy/log/7-recode-outliers.md). 
Initial work is available here: [code/1-svy/outlier-testing.md](code/1-svy/outlier-testing.md)

## Secondary Data Sources

Details included in [data/README.md](data/README.md). Overview:

- OIA 2016 Survey
    + Define the CO survey target population (and subsequent weighting)
    + Produce spending profiles
- USFWS Nat Survey: spending profiles for fish/hunt/wildlife
- AZ 2018 Survey: picnic spending profile
- US Census: population estimates
- Federal Reserve Bank: CPI estimates

## Implan

Some thoughts on whether the implan preparation should be done in R:

- The "conversion" step: [data/implan/implan-relate.xlsx](data/implan/implan-relate.xlsx) is used to convert spending by item (e.g., "food") to spending by Implan category (e.g., "Food - Groceries")
- The "staging" step [data/implan/implate-sectroing.xlsx](data/implan/implate-sectroing.xlsx) which is used to allocate Implan categories to [Sectors](https://implanhelp.zendesk.com/hc/en-us/articles/115009674428-IMPLAN-Sectoring-NAICS-Correspondences)
- The "event" (wording???) step which places implan sectors into 2 tabs (Industry, Commercial) in a structure used for input into Implan models, using an Excel template: [data/implan/implate_import_template.xls](implate_import_template.xls)

Advantages of R approach:

- Separates data (spending, conversion, staging) from the workflow (R code)
- It's less error-prone
- It scales much better
- It's more generalizable (i.e., should be easier to implement in new projects)

Disadvantages of R approach: 

- Not all analysts know R
- It's different from what we've done in the past
