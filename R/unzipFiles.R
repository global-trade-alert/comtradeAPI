# function decompresses all files with .txt.gz endings
decompressFiles <- function(filePath) {
    filePath <- stringr::str_remove(filePath, "/$")
    files <- list.files(filePath)
    files <- files[stringr::str_detect(files, ".txt.gz$")]

    for (i in seq_along(files)) {
        temp <- data.table::fread(glue::glue('{filePath}/{files[i]}'))
        data.table::fwrite(temp, file = stringr::str_remove(files[i], ".txt.gz"))
        msg <- cli::style_bold(glue::glue("file {i}/{length(files)} done"))
        cat("\r", msg)
    }
}
