# function decompresses all files with .txt.gz endings
decompressFiles <- function(filePath, removeOriginal = FALSE) {
    filePath <- stringr::str_remove(filePath, "/$")
    files <- list.files(filePath)
    files <- files[stringr::str_detect(files, ".txt.gz$")]

    for (i in seq_along(files)) {
        temp <- data.table::fread(glue::glue('{filePath}/{files[i]}'))
        outName <- stringr::str_remove(files[i], ".txt.gz")
        outName <- glue::glue("{filePath}/{outName}.csv")
        data.table::fwrite(temp, file = outName)

        if (removeOriginal){
            unlink(glue::glue('{filePath}/{files[i]}'))
        }

        msg <- cli::style_bold(glue::glue("file {i}/{length(files)} done"))
        cat("\r", msg)
    }
}