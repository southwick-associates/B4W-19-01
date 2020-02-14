# update from 536 to 546 implan sectoring
# https://implanhelp.zendesk.com/hc/en-us/articles/360034896614-546-Industries-Conversions-Bridges-Construction-2018-Data

library(tidyverse)
library(readxl)
library(implan)

infile <- "data/raw/implan/category_to_sector536.xlsx"
outfile <- "data/processed/category_to_sector546.xlsx"

# implan sectoring information
data("sectors546", "sector536_to_sector546")

# sectoring scheme for 536
acts <- c("oia", "fish", "hunt", "wildlife")
category_to_sector536 <- acts %>%
    sapply(function(x) read_excel(infile, x) %>% mutate(act_group = x), 
           simplify = FALSE) %>%
    bind_rows()

# update sectoring scheme
category_to_sector546 <- category_to_sector536 %>%
    sector_update(sector536_to_sector546, sectors546)

# write to Excel (to preserve original format)
for (i in acts) {
    x <- filter(category_to_sector546, act_group == i) %>% select(-act_group)
    xlsx_write_table(x, i, outfile)
}
