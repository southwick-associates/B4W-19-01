
## Organization

Based on [Cookiecutter Data Science](https://drivendata.github.io/cookiecutter-data-science/#directory-structure)

- external = input data from outside (publicly-available) sources
- interim = intermediate data (produced in this analysis)
- processed = final data for estimation (produced in this analysis)
- raw = input data from internal (non-publicly-available) sources

### external

From [US Census](https://www.census.gov/data/tables/time-series/demo/popest/2010s-state-detail.html#par_textimage_785300169) 

- SCPRC-EST2019-18+POP-RES: Population by states in 2019 (18+ vs total)
- sc-est2018-agesex-civ: Pop by age-sex-state 2010 thru 2018

### raw

- usfws-profiles.xlsx: Average estimated spending per day (by item) for fish vs. hunt vs. wildlife viewing in Colorado
    + From [O365 > CO-SCORP-18-01 > Analysis](https://southwickassociatesinc.sharepoint.com/:f:/s/co-scorp-18-01/EhKdG4KGp6NMtyy9KvFw5m4B9PnrF-POwxoBCp9o1z-4xg?e=lUwfPU). Pulled together from work done by Tom in 2016 Fish Hunt WW profiles.xlsx
    
- spend-picnic-az.rds: Picnic spending  (avg per day) from [O365 > Audubon AZ-18-01](https://southwickassociatesinc.sharepoint.com/sites/AudubonAZ-18-01/Shared%20Documents/Forms/AllItems.aspx)

- Participation Profiles - B4W coh2o: From Eric, participation estimates based on CO survey prepared here

#### svy

From Colorado 2019 survey

- 2019-12-31 (etc.): CO survey data
- act_labs.xlsx: CO survey activity labels
- basin_labs.xlsx: CO survey basin labels
- pipe_labs.xlsx: CO survey activity piping labels

#### oia

From 2016 OIA analysis, stored on O365: [OIA 2016 > Analysis Resources](https://southwickassociatesinc.sharepoint.com/:w:/s/oia2016-001recreationeconreport/EdZ4EMXUfXtKsEurnqCqlbcBbxarVPTtLkyCNiYti18vUA?e=zvmc87):

- oia-activities.xlsx: OIA survey activity info
- results.RDATA: OIA survey results
- svy-wtd.RDATA: OIA survey data
- Vehicle_act1.xlsx: vehicle to activity group relation table

#### implan

- Implan546...xlsx: Reference file for all [2018 Implan sectors](https://implanhelp.zendesk.com/hc/en-us/articles/360034895094-BEA-Benchmark-The-New-546-Sectoring-Scheme)
- implan-categories.xlsx: Relation table for converting from spending data (by item) to implan spending categories
- implan-sectors.xlsx: Relation table for converting from implan categories to implan sectors
