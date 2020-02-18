Find Disagreements in Implan (536) Sectoring Schemes
================
February 18, 2020

## Motivation

Running Implan depends on mapping spending categories (“Food -
Groceries”, etc.) to implan sectors. We currently store these
sectoring schemes (or category-sector crosswalks) separately by activity
(fish, hunt, etc.). For efficiency, we might consider using a master
sector scheme as a single source of truth, and only change it when (1)
new categories are needed, or (2) the sectoring scheme needs updating.

However, there is disagreement between the 4 sectoring schemes examined.
As far as I can tell, these shouldn’t disagree. If that is the case,
then we should fix these discrepancies in a new master sectoring scheme.

An output (Excel) master table [is downloadable
here](https://github.com/southwick-associates/B4W-19-01/blob/master/data/interim/compare-sectoring.xlsx)
(and R code for this analysis [is stored
here](https://github.com/southwick-associates/B4W-19-01/blob/master/code/summary/compare-implan-sectoring.Rmd)).

### Sectoring Scheme

For reference, a few rows of the hunting sectoring scheme (note the
leading 3000 was stripped from commodity sector IDs for comparison
purposes):

| group | category  | sector | description                       |     share | retail | act  |
| :---- | :-------- | -----: | :-------------------------------- | --------: | :----- | :--- |
| Comm  | Ammo      |    257 | Small arms ammunition             | 0.3248092 | Yes    | hunt |
| Comm  | Ammo      |    258 | Ammunition, except for small arms | 0.6751908 | Yes    | hunt |
| Comm  | Bass boat |    364 | Boats                             | 1.0000000 | Yes    | hunt |

## Show Disagreement

There are 3 relevant variables that can potentionally disagree between
activity sectoring schemes:

  - Share: The proportion of the category spending allocated to a sector
  - Retail: “Yes” or “No”
  - Group: “Ind” (industry) or “Comm” (commodity)

### Share Disagreement

| category                             | sector |      fish |      hunt | oia |  wildlife |
| :----------------------------------- | -----: | --------: | --------: | --: | --------: |
| Boat launching                       |    494 | 0.6897879 |           |     |           |
| Boat launching                       |    496 | 0.3102121 |           |     | 1.0000000 |
| Boat mooring                         |    494 | 0.6897879 | 0.3919445 |     |           |
| Boat mooring                         |    496 | 0.3102121 | 0.6080555 |     |           |
| Cabins                               |     59 | 0.4525928 | 0.3333333 |     | 0.4525928 |
| Cabins                               |     60 |           |           |     | 0.0474072 |
| Cabins                               |     63 | 0.0474072 | 0.3333333 |     |           |
| Cabins                               |    440 | 0.5000000 | 0.3333333 |     | 0.5000000 |
| Dues and contributions               |    515 |           |           |     | 0.4712933 |
| Dues and contributions               |    516 | 1.0000000 |           |     | 0.5287067 |
| Pick-ups, campers, motor homes, etc. |    343 | 0.3947483 |           |     |           |
| Pick-ups, campers, motor homes, etc. |    344 | 0.6052517 |           |     | 1.0000000 |
| Public transportation                |    409 | 0.3333333 | 0.3333333 |     | 0.3330000 |
| Public transportation                |    410 | 0.3333333 | 0.3333333 |     | 0.3330000 |
| Public transportation                |    412 | 0.3333333 | 0.3333333 |     | 0.3340000 |

### Retail Disagreement

| category         | sector | fish | hunt | oia | wildlife | disagree\_retail |
| :--------------- | -----: | :--- | :--- | :-- | :------- | ---------------: |
| Boat fuel        |    159 | No   | Yes  |     | Yes      |                1 |
| Food - Groceries |     13 | No   | Yes  | Yes | Yes      |                1 |
| Food - Groceries |     18 | Yes  | No   | No  | No       |                1 |
| Food - Groceries |    104 | No   | Yes  | Yes | Yes      |                1 |
| Food - Groceries |    105 | No   | Yes  | Yes | Yes      |                1 |
| Food - Groceries |    106 | No   | Yes  | Yes | Yes      |                1 |
| Food - Groceries |    107 | No   | Yes  | Yes | No       |                1 |
| Food - Groceries |    108 | Yes  | Yes  | Yes | No       |                1 |
| Food - Groceries |    109 | Yes  | Yes  | Yes | No       |                1 |
| Food - Groceries |    396 | No   | Yes  | Yes | Yes      |                1 |
| Food - Groceries |    397 | Yes  | Yes  | Yes | No       |                1 |
| Food - Groceries |    401 | No   | Yes  | Yes | Yes      |                1 |
| Food - Groceries |    402 | No   | Yes  | Yes | Yes      |                1 |

### Industry/Commodity Disagreement

| category                   | sector | fish | hunt | oia  | wildlife |
| :------------------------- | -----: | :--- | :--- | :--- | :------- |
| Boat launching             |    496 | Ind  |      |      | Comm     |
| Cabins                     |     59 | Ind  | Ind  |      | Comm     |
| Cabins                     |    440 | Ind  | Ind  |      | Comm     |
| Dues and contributions     |    516 | Comm |      |      | Ind      |
| Equipment rental           |    443 | Ind  |      |      | Comm     |
| Food - Groceries           |     18 | Comm | Ind  | Comm | Comm     |
| Food - Groceries           |    408 | Comm | Ind  | Comm | Comm     |
| Food - Groceries           |    409 | Comm | Ind  | Comm | Comm     |
| Food - Groceries           |    410 | Comm | Ind  | Comm | Comm     |
| Food - Groceries           |    411 | Comm | Ind  | Comm | Comm     |
| Land leased for fishing    |    440 | Ind  |      |      | Comm     |
| Land purchased for fishing |    440 | Ind  |      |      | Comm     |
| Private land use fees      |    517 | Comm |      |      | Ind      |
| Public transportation      |    409 | Comm | Ind  |      | Comm     |
| Public transportation      |    410 | Comm | Ind  |      | Comm     |
| Public transportation      |    412 | Comm | Ind  |      | Comm     |

### Master

Preparing a master table with one row per category-sector (saved in
Excel). Flag variables are included for disagreement, and corresponding
variables are set to missing. The idea is that this table can be easily
manually edited to fix discrepancies.
