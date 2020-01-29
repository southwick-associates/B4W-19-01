
## Overview

For Southwick internal use only; Dan's portion of the analysis for the B4W-19-01 project:

- Preparing Survey data:
    + CO: [data-work/1-svy/svy-weight-csv.zip](data-work/1-svy/svy-weight-csv.zip)
    + OIA: [data-work/oia/oia-co.csv](data-work/oia/oia-co.csv)
- Estimating OIA-based profiles

### Usage

The analysis can be reproduced from `code/run.R`. Folder organization: 

- R (R functions), code (analysis scripts), data (raw data), data-work (intermediate data), out (output & results)

### Software Environment

This project was setup using package [saproj](https://github.com/southwick-associates/saproj) with a [Southwick-specific R Setup](https://github.com/southwick-associates/R-setup). Two files shouldn't be edited by hand:

- `.Rprofile` specifies R version and project library
- `snapshot-library.csv` details project-specific packages

## CO Survey Data

Final survey data is stored in 3 tables:

- person [1 row per respondent]: Vrid, id (IPSOS), Vstatus, demographics
- act [person by activity]: participation & days overall vs. along water
- basin [person by activity by basin]: participation & days

Survey details are available on O365 > B4W-19-01:

- [Survey Data Dictionary](https://southwickassociatesinc.sharepoint.com/:x:/s/B4W-19-01/EUfzP3tm7O5Kpim_RuhzFzABWy7W_i-17pSKllDirAeU9g?e=LAeALG)
- [Questionnaire](https://southwickassociatesinc.sharepoint.com/:w:/s/B4W-19-01/ESlQqzDJbg5BplbAPakEnoEBL8F7pUZLftXywcK4F01exA?e=hfEiig)

### Respondent Flagging

Flagging has been performed for assigning valid quotas for IPSOS, stored in `out/1-svy`:

- `flags-all.csv`: all flagged values
- `flags-core.csv`: respondents that didn't make the cut for the IPSOS quota
- `flags-ipsos-okay.csv`: respondents that did make the quota (shared with IPSOS by Lisa B)

See the flag summary for an overview:  [code/1-svy/flag-summary.md](code/1-svy/flag-summary.md)

## OIA Survey Data

Used for defining the CO survey target population (and subsequent weighting). More docs to prepare:

- [link to OIA questionnaire](https://southwickassociatesinc.sharepoint.com/:w:/s/oia2016-001recreationeconreport/EbI0t01qsPdHtU1GFu5o0ukBovyynTC6IqkskwEAbgSJxQ?e=uuJI6d)
- data is stored on the server: E:/SA/...
- other info?
