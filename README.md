
## Overview

For Southwick internal use only; Dan's portion of the analysis for the CO survey. 

## Usage

The analysis can be reproduced from `code/run.R`

### Survey Data

Final survey data is [available for download here](data-work/1-svy/svy-weight-csv.zip), stored in 3 tables:

- person [1 row per respondent]: Vrid, id (IPSOS), Vstatus, demographics
- act [person by activity]: participation & days overall vs. along water
- basin [person by activity by basin]: participation & days

Details are available in the [O365 Survey Data Dictionary](https://southwickassociatesinc.sharepoint.com/:x:/s/B4W-19-01/EUfzP3tm7O5Kpim_RuhzFzABWy7W_i-17pSKllDirAeU9g?e=GFT2ZJ)

### Respondent Flagging

Flagging has been performed for assigning valid quotas for IPSOS, stored in `out/1-svy`:

- flags-all.csv: all flagged values
- flags-core.csv: respondents that didn't make the cut for the IPSOS quota
- flags-ipsos-okay.csv: respondents that did make the quota (shared with IPSOS by Lisa B)

See [the flag summary](code/1-svy/flag-summary.md) for an overview.

### Folder Organization

- R: R functions
- code: analysis scripts
- data: raw data
- data-work: intermediate data
- out: output & results

## Software Environment

This project was setup using package [saproj](https://github.com/southwick-associates/saproj) with a [Southwick-specific R Setup](https://github.com/southwick-associates/R-setup). Certain files shouldn't be edited by hand:

- .Rprofile             specifies R version and project library
- snapshot-library.csv  details project-specific packages
