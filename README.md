
## Overview

For Southwick internal use only; Dan's portion of the analysis for the CO survey. 

## Usage

The analysis can be run from `code/run.R`

### Survey Data

Survey data was reshaped into 3 tables ("data-work/1-svy/svy-reshape"), 1 table per dimension:

- person [1 row per respondent]: Vrid, id (IPSOS), Vstatus, demographics
- act [person by activity]: participation & days overall vs. along water
- basin [person by activity by basin]: participation & days

Details are available in the [Survey Data Dictionary](https://southwickassociatesinc.sharepoint.com/:x:/s/B4W-19-01/EUfzP3tm7O5Kpim_RuhzFzABWy7W_i-17pSKllDirAeU9g?e=GFT2ZJ)

### Respondent Flagging

Flagging has been performed for assigning valid quotas for IPSOS (out/1-svy):

- flags-all.csv: all flagged values
- flags-core.csv: respondents that didn't make the cut for the IPSOS quota
- flags-ipsos-okay.csv: respondents that did make the quota (shared with IPSOS by Lisa B)

See "code/1-svy/flag-summary.md" for an overview

### Folder Organization

- R: R functions
- code: analysis scripts
- data: raw data
- data-work: intermediate data
- out: output & results

## R Package Library

This project was setup using package 'saproj'

Certain files shouldn't be edited by hand:
- .Rprofile             specifies R version and project library
- snapshot-library.csv  details project-specific packages (if they exist)
