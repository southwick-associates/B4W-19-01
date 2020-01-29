# workflow functions

# render a script, storing as .md in a log subfolder
# the function is a bit verbose, but it's nice to have markdown files for github
# - script_path file path to code to be executed
run_script <- function(script_path) {
    rmarkdown::render(
        output_format = "github_document", # outputs to .md 
        input = script_path,
        knit_root_dir = getwd()
    )
    # clean-up
    # - define file paths
    script_name <- basename(script_path) %>% tools::file_path_sans_ext()
    indir <- dirname(script_path)
    outdir <- file.path(indir, "log")
    dir.create(outdir, showWarnings = FALSE)
    
    # - move .md files to log folder & remove any html previews
    file.remove(file.path(indir, paste0(script_name, ".html")))
    file.rename(
        file.path(indir, paste0(script_name, ".md")),
        file.path(outdir, paste0(script_name, ".md"))
    )
    # these will be produced if figures are included in the .md
    # and they need to be moved along with the .md
    file.rename(
        file.path(indir, paste0(script_name, "_files")),
        file.path(outdir, paste0(script_name, "_files"))
    )
}
