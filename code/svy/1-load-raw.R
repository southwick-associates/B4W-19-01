# load raw data into RDS

library(tidyverse)
library(haven)

infile <- "data/raw/svy/2019-12-31/spss.sav"
outfile <- "data/interim/svy-raw.rds"

# Load Raw ----------------------------------------------------------------

svy_in <- read_sav(infile)
svy <- svy_in
dim(svy_in)

# drop unneeded variables
svy <- select(svy_in, Vrid:Vstatus, id = var105, var2O1:var13)
dim(svy)

# SPSS Labels -------------------------------------------------------------

# variable labs
# - save these in a table for later reference
varlabs <- list()
for (i in names(svy)) {
    varlabs[[i]] <- data.frame(
        var = i,
        lab = attributes(svy[[i]])$label,
        stringsAsFactors = FALSE
    )
}
varlabs <- bind_rows(varlabs)
head(varlabs, 4)

# value labels
# - convert labelled values to R factors
svy <- haven::as_factor(svy)

# - check some value labels
svy_in[, c("var2O1", "var2O2")]
svy[, c("var2O1", "var2O2")]

# - list labelled variables
list_factor_vars <- function(df) {
    factors <- sapply(names(df), function(nm) is.factor(df[[nm]]))
    names(df)[factors]
}
list_factor_vars(svy)
list_factor_vars(svy_in)

# Save --------------------------------------------------------------------

# variables labels
write_csv(varlabs, "data/interim/svy-varlabs.csv")

# svy data
saveRDS(svy, outfile)
