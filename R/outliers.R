# identify outliers using tukey's rule ( > 1.5 * iqr)
# https://en.wikipedia.org/wiki/Outlier#Tukey%27s_fences

# flag outliers based on tukey's rule
# returns a logical vector where TRUE indicates outliers
# - x: input values to check
# - k: the iqr multiplier that determines the fence level
# - ignore_lwr: If TRUE, don't use the lower fence for identifying outliers
# - apply_log: If TRUE, log transform input values prior to applying tukey's rule
tukey_outlier <- function(
    x, k = 1.5, ignore_lwr = FALSE, apply_log = FALSE
) {
    # distributions often have a log-normal shape (e.g., spending)
    if (apply_log) x <- log(x)
    
    quartiles <- quantile(x, probs = c(0.25, 0.75), na.rm = TRUE)
    iqr <- diff(quartiles)
    bottom <- quartiles[1] - k * iqr
    top <- quartiles[2] + k * iqr
    
    if (ignore_lwr) {
        return(x > top)
    }
    x > top | x < bottom
}

# get the top (non-outlier) value for top-coding
tukey_top <- function(x, k = 1.5, apply_log = FALSE) {
    if (apply_log) x <- log(x)
    quartiles <- quantile(x, probs = c(0.25, 0.75), na.rm = TRUE)
    iqr <- diff(quartiles)
    exp(quartiles[2] + k * iqr)
}
