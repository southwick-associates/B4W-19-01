
## Overview

For Southwick internal use only, this represents the analysis for the CO survey. Currently working on survey data prep:

- identifying suspicious respondents for potential removal (code/1-svy/3-flags.R & flag-summary.Rmd)
- data cleaning to deal with treatment of missing data, respondents to be excluded, and (maybe) outlier identification
- survey weighting

## Usage

The analysis can be run from `code/run.R`

### Survey Data (Suggested restructure)

Use 4 tables:

- person (1 row per respondent)
    + dimension = All Respondents
    + variablse = Vrid, id (IPSOS), Vstatus, demographics
    
- act (1 row per respondent-activity)
    + dimension = All Respondents
    + variables = part, days, is_targeted (to identify 9 activities of interest)
    
- act_water (1 row per respondent-activity)
    + dimension = All Participants (for 9 activities of interest)
    + variables = part_water, days_water
    
- basin (1 row per respondent-activity-basin)
    + dimension = All along the water participants (9 activities)
    + variables = part_water, days_water
    
### Survey Data (Current structure)

Survey data was reshaped into 3 tables related by Vrid ("data-work/1-svy/svy-reshape"), 1 table per dimension:

- person [1 row per respondent]: Vrid, id (IPSOS), Vstatus, demographics
- act [person by activity]: participation & days overall vs. along water
    + part: Overall participation (for all respondents)
    + days: Overall days (for participants)
    + part_water: Water-specific participation (for participants)
    + days_water: Water specific days (for water participants)
- basin [person by activity by basin]: participation & days
    + part_water: Participation by basin (for state-level water participants)
    + days_water: Days by basin (for basin-level water participants)

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
