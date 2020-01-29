
## Overview

For Southwick internal use only; Dan's portion of the analysis for the CO survey:

- preparing CO and OIA survey data
- producing OIA-based estimation profiles

### Usage

The analysis can be reproduced from `code/run.R`. Folder organization: 

- R (R functions), code (analysis scripts), data (raw data), data-work (intermediate data), out (output & results)

### Software Environment

This project was setup using package [saproj](https://github.com/southwick-associates/saproj) with a [Southwick-specific R Setup](https://github.com/southwick-associates/R-setup). Two files shouldn't be edited by hand:

- `.Rprofile` specifies R version and project library
- `snapshot-library.csv` details project-specific packages

## CO Survey Data

Final survey data is available for download at [data-work/1-svy/svy-weight-csv.zip](data-work/1-svy/svy-weight-csv.zip), stored in 3 tables:

- person [1 row per respondent]: Vrid, id (IPSOS), Vstatus, demographics
- act [person by activity]: participation & days overall vs. along water
- basin [person by activity by basin]: participation & days

Survey details are available on O365:

- [Survey Data Dictionary](https://southwickassociatesinc.sharepoint.com/:x:/s/B4W-19-01/ETchk1k_EfZKgZe0z3PzS_kB3D_QBvQsxGPhABfOPMIHdg?e=07goQ1)
- [Questionnaire](https://southwickassociatesinc.sharepoint.com/:w:/s/B4W-19-01/ESlQqzDJbg5BplbAPakEnoEBL8F7pUZLftXywcK4F01exA?e=hfEiig)

### Respondent Flagging

Flagging has been performed for assigning valid quotas for IPSOS, stored in `out/1-svy`:

- `flags-all.csv`: all flagged values
- `flags-core.csv`: respondents that didn't make the cut for the IPSOS quota
- `flags-ipsos-okay.csv`: respondents that did make the quota (shared with IPSOS by Lisa B)

See the flag summary for an overview:  [code/1-svy/flag-summary.md](code/1-svy/flag-summary.md)

## OIA Survey Data

Used for defining the CO survey target population (and subsequent weighting). The cleaned dataset is available at [data-work/oia/oia-co.csv](data-work/oia/oia-co.csv)

- link to questionnaire
- data is stored on the server: E:/SA/...
- other info?
