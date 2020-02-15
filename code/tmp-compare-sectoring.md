Find Disagreements in Sectoring Schemes
================
February 15, 2020

## Motivation

Running Implan depends on mapping spending categories (“Food -
Groceries”, etc.) to implan sectors. We currently store these
sectoring schemes (or category-sector crosswalks) separately for
different activities (fish, hunt, etc.). For efficiency, we should use a
master sector scheme as a single source of truth, and only change it
when (1) new categories are needed, or (2) the sectoring scheme needs
updating.

However, there is disagreement between the 4 sectoring schemes examined.
As far as I can tell, these shouldn’t disagree. If that is the case,
then we should fix these discrepancies in a new master sectoring scheme.

The R code for this analysis [is stored
here](https://github.com/southwick-associates/B4W-19-01/blob/master/code/tmp-compare-sectoring.Rmd).

### Sectoring Scheme

For reference, a few rows of the hunting sectoring scheme (note the
leading 3000 was stripped from commodity sector IDs for comparison
purposes):

| group | category  | sector | description                       |     share | retail | act  |
| :---- | :-------- | -----: | :-------------------------------- | --------: | :----- | :--- |
| Comm  | Ammo      |    257 | Small arms ammunition             | 0.3248092 | Yes    | hunt |
| Comm  | Ammo      |    258 | Ammunition, except for small arms | 0.6751908 | Yes    | hunt |
| Comm  | Bass boat |    364 | Boats                             | 1.0000000 | Yes    | hunt |

## Show Duplication

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

| category         | sector | fish | hunt | oia | wildlife |
| :--------------- | -----: | :--- | :--- | :-- | :------- |
| Boat fuel        |    159 | No   | Yes  |     | Yes      |
| Food - Groceries |     13 | No   | Yes  | Yes | Yes      |
| Food - Groceries |     18 | Yes  | No   | No  | No       |
| Food - Groceries |    104 | No   | Yes  | Yes | Yes      |
| Food - Groceries |    105 | No   | Yes  | Yes | Yes      |
| Food - Groceries |    106 | No   | Yes  | Yes | Yes      |
| Food - Groceries |    107 | No   | Yes  | Yes | No       |
| Food - Groceries |    108 | Yes  | Yes  | Yes | No       |
| Food - Groceries |    109 | Yes  | Yes  | Yes | No       |
| Food - Groceries |    396 | No   | Yes  | Yes | Yes      |
| Food - Groceries |    397 | Yes  | Yes  | Yes | No       |
| Food - Groceries |    401 | No   | Yes  | Yes | Yes      |
| Food - Groceries |    402 | No   | Yes  | Yes | Yes      |

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

### Any Disagreement

Shows complete records for those category-sectors which have some
disagreement between the 4 activities (i.e., a synthesis of the 3 tables
above). Note that the descriptions can disagree with Ind/Comm
disagreement.

| group | category                             | sector | description                                                                 |     share | retail |
| :---- | :----------------------------------- | -----: | :-------------------------------------------------------------------------- | --------: | :----- |
| Comm  | Boat fuel                            |    159 | Petroleum lubricating oil and grease                                        | 0.0230000 | Yes    |
| Comm  | Boat fuel                            |    159 | Petroleum lubricating oil and grease                                        | 0.0230000 | No     |
| Ind   | Boat launching                       |    496 | Other amusement and recreation industries                                   | 0.3102121 | No     |
| Comm  | Boat launching                       |    496 | Other amusement and recreation                                              | 1.0000000 | No     |
| Ind   | Boat mooring                         |    494 | Amusement parks and arcades                                                 | 0.3919445 | No     |
| Ind   | Boat mooring                         |    494 | Amusement parks and arcades                                                 | 0.6897879 | No     |
| Ind   | Boat mooring                         |    496 | Other amusement and recreation industries                                   | 0.6080555 | No     |
| Ind   | Boat mooring                         |    496 | Other amusement and recreation industries                                   | 0.3102121 | No     |
| Ind   | Cabins                               |     59 | Construction of new single-family residential structures                    | 0.3333333 | No     |
| Ind   | Cabins                               |     59 | Construction of new single-family residential structures                    | 0.4525928 | No     |
| Comm  | Cabins                               |     59 | Newly constructed single-family residential structures                      | 0.4525928 | No     |
| Ind   | Cabins                               |     63 | Maintenance and repair construction of residential structures               | 0.3333333 | No     |
| Ind   | Cabins                               |     63 | Maintenance and repair construction of residential structures               | 0.0474072 | No     |
| Ind   | Cabins                               |    440 | Real estate                                                                 | 0.3333333 | No     |
| Ind   | Cabins                               |    440 | Real estate                                                                 | 0.5000000 | No     |
| Comm  | Cabins                               |    440 | Real estate buying and selling, leasing, managing, and related services     | 0.5000000 | No     |
| Comm  | Dues and contributions               |    516 | Labor and civic services                                                    | 1.0000000 | No     |
| Ind   | Dues and contributions               |    516 | Labor and civic organizations                                               | 0.5287067 | No     |
| Ind   | Equipment rental                     |    443 | General and consumer goods rental except video tapes and discs              | 1.0000000 | No     |
| Comm  | Equipment rental                     |    443 | General and consumer goods rental servicesexcept video tapes and discs      | 1.0000000 | No     |
| Comm  | Food - Groceries                     |     13 | Poultry and egg products                                                    | 0.0049540 | Yes    |
| Comm  | Food - Groceries                     |     13 | Poultry and egg products                                                    | 0.0049540 | No     |
| Comm  | Food - Groceries                     |     18 | Wild game products, pelts, and furs                                         | 0.0002670 | No     |
| Ind   | Food - Groceries                     |     18 | Commercial hunting and trapping                                             | 0.0002670 | No     |
| Comm  | Food - Groceries                     |     18 | Wild game products, pelts, and furs                                         | 0.0002670 | Yes    |
| Comm  | Food - Groceries                     |    104 | Spices and extracts                                                         | 0.0080430 | Yes    |
| Comm  | Food - Groceries                     |    104 | Spices and extracts                                                         | 0.0080430 | No     |
| Comm  | Food - Groceries                     |    105 | All other food products                                                     | 0.0202340 | Yes    |
| Comm  | Food - Groceries                     |    105 | All other food products                                                     | 0.0202340 | No     |
| Comm  | Food - Groceries                     |    106 | Bottled and canned soft drinks and water                                    | 0.0500795 | Yes    |
| Comm  | Food - Groceries                     |    106 | Bottled and canned soft drinks and water                                    | 0.0500795 | No     |
| Comm  | Food - Groceries                     |    107 | Manufactured ice                                                            | 0.0026855 | Yes    |
| Comm  | Food - Groceries                     |    107 | Manufactured ice                                                            | 0.0026855 | No     |
| Comm  | Food - Groceries                     |    108 | Beer, ale, malt liquor and nonalcoholic beer                                | 0.0386770 | Yes    |
| Comm  | Food - Groceries                     |    108 | Beer, ale, malt liquor and nonalcoholic beer                                | 0.0386770 | No     |
| Comm  | Food - Groceries                     |    109 | Wine and brandies                                                           | 0.0144550 | Yes    |
| Comm  | Food - Groceries                     |    109 | Wine and brandies                                                           | 0.0144550 | No     |
| Comm  | Food - Groceries                     |    396 | Retail services - Motor vehicle and parts dealers                           | 0.0000040 | Yes    |
| Comm  | Food - Groceries                     |    396 | Retail services - Motor vehicle and parts dealers                           | 0.0000040 | No     |
| Comm  | Food - Groceries                     |    397 | Retail services - Furniture and home furnishings stores                     | 0.0000040 | Yes    |
| Comm  | Food - Groceries                     |    397 | Retail services - Furniture and home furnishings stores                     | 0.0000040 | No     |
| Comm  | Food - Groceries                     |    401 | Retail services - Health and personal care stores                           | 0.0000040 | Yes    |
| Comm  | Food - Groceries                     |    401 | Retail services - Health and personal care stores                           | 0.0000040 | No     |
| Comm  | Food - Groceries                     |    402 | Retail services - Gasoline stores                                           | 0.0648680 | Yes    |
| Comm  | Food - Groceries                     |    402 | Retail services - Gasoline stores                                           | 0.0648680 | No     |
| Comm  | Food - Groceries                     |    408 | Air transportation services                                                 | 0.0016640 | No     |
| Ind   | Food - Groceries                     |    408 | Air transportation                                                          | 0.0016640 | No     |
| Comm  | Food - Groceries                     |    409 | Rail transportation services                                                | 0.0024070 | No     |
| Ind   | Food - Groceries                     |    409 | Rail transportation                                                         | 0.0024070 | No     |
| Comm  | Food - Groceries                     |    410 | Water transportation services                                               | 0.0001840 | No     |
| Ind   | Food - Groceries                     |    410 | Water transportation                                                        | 0.0001840 | No     |
| Comm  | Food - Groceries                     |    411 | Truck transportation services                                               | 0.0205050 | No     |
| Ind   | Food - Groceries                     |    411 | Truck transportation                                                        | 0.0205050 | No     |
| Ind   | Land leased for fishing              |    440 | Real estate                                                                 | 1.0000000 | No     |
| Comm  | Land leased for fishing              |    440 | Real estate buying and selling, leasing, managing, and related services     | 1.0000000 | No     |
| Ind   | Land purchased for fishing           |    440 | Real estate                                                                 | 1.0000000 | No     |
| Comm  | Land purchased for fishing           |    440 | Real estate buying and selling, leasing, managing, and related services     | 1.0000000 | No     |
| Comm  | Pick-ups, campers, motor homes, etc. |    344 | Light trucks and utility vehicles                                           | 0.6052517 | Yes    |
| Comm  | Pick-ups, campers, motor homes, etc. |    344 | Light trucks and utility vehicles                                           | 1.0000000 | Yes    |
| Comm  | Private land use fees                |    517 | Cooking, housecleaning, gardening, and other services to private households | 1.0000000 | No     |
| Ind   | Private land use fees                |    517 | Private households                                                          | 1.0000000 | No     |
| Ind   | Public transportation                |    409 | Rail transportation                                                         | 0.3333333 | No     |
| Comm  | Public transportation                |    409 | Rail transportation services                                                | 0.3333333 | No     |
| Comm  | Public transportation                |    409 | Rail transportation services                                                | 0.3330000 | No     |
| Ind   | Public transportation                |    410 | Water transportation                                                        | 0.3333333 | No     |
| Comm  | Public transportation                |    410 | Water transportation services                                               | 0.3333333 | No     |
| Comm  | Public transportation                |    410 | Water transportation services                                               | 0.3330000 | No     |
| Ind   | Public transportation                |    412 | Transit and ground passenger transportation                                 | 0.3333333 | No     |
| Comm  | Public transportation                |    412 | Transit and ground passenger transportation services                        | 0.3333333 | No     |
| Comm  | Public transportation                |    412 | Transit and ground passenger transportation services                        | 0.3340000 | No     |
