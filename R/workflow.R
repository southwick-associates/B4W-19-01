# workflow functions

# Run a script, storing rendered output as .md in a log subfolder
# This function is a bit verbose, but it's nice to have markdown files for github
run_script <- function(script_path) {
    # source script & render to markdown
    rmarkdown::render(
        output_format = "github_document",
        input = script_path,
        knit_root_dir = getwd()
    )
    # clean-up
    # - define file paths
    script_name <- basename(script_path) %>% tools::file_path_sans_ext()
    indir <- dirname(script_path)
    outdir <- file.path(indir, "log")
    dir.create(outdir, showWarnings = FALSE)
    
    # - remove any html preview files
    file.remove(file.path(indir, paste0(script_name, ".html")))
    
    # - move .md files to log folder 
    file.rename(
        file.path(indir, paste0(script_name, ".md")),
        file.path(outdir, paste0(script_name, ".md"))
    )
    # - a files folder will be produced if figures are included in the md file
    # - and it needs to be moved along with the md file
    old <- file.path(indir, paste0(script_name, "_files"))
    new <- file.path(outdir, paste0(script_name, "_files"))
    file.copy(old, new, recursive = TRUE)
    unlink(old, recursive = TRUE)
}
