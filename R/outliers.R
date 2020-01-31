# identify outliers using tukey's rule ( > 1.5 * iqr)
# https://en.wikipedia.org/wiki/Outlier#Tukey%27s_fences

# flag outliers based on tukey's rule
# returns a logical vector where TRUE indicates outliers
# - x: input values to check
# - k: the iqr multiplier that determines the fence level
#   Increasing will make outlier identification less strict (& vice-versa)
# - ignore_lwr: If TRUE, don't use the lower fence for identifying outliers
# - apply_log: If TRUE, log transform input values prior to applying tukey's rule
# - ingnore_zero: If TRUE, will exclude zero values from IQR & flagging
#   Note that zeroes will automatically be ignored if apply_log = TRUE
tukey_outlier <- function(
    x, k = 1.5, ignore_lwr = FALSE, apply_log = FALSE, ignore_zero = FALSE
) {
    if (ignore_zero) x <- ifelse(x == 0, NA, x)
    
    # distributions often have a log-normal shape (e.g., spending)
    if (apply_log) x <- log(x)
    
    quartiles <- quantile(x, probs = c(0.25, 0.75), na.rm = TRUE)
    iqr <- diff(quartiles)
    bottom <- quartiles[1] - k * iqr
    top <- quartiles[2] + k * iqr
    
    if (ignore_lwr) {
        ifelse(is.na(x) | x < top, FALSE, TRUE)
    }
    ifelse(is.na(x) | (x < top & x > bottom), FALSE, TRUE)
}

# get the top (non-outlier) value for top-coding
tukey_top <- function(x, k = 1.5, apply_log = FALSE) {
    if (apply_log) x <- log(x)
    quartiles <- quantile(x, probs = c(0.25, 0.75), na.rm = TRUE)
    iqr <- diff(quartiles)
    exp(quartiles[2] + k * iqr)
}
