#' Decompress the files downloaded with comtradeAPI::getBulkDataFromLink / comtradeAPI::getBulkData
#'
#' This function lcoates all files with ending .txt.gz in the specified filePath and decompressed them.
#' Please make sure that the filePath you supply contains only files you wish to decompress!
#'
#' @param filePath the path where the to-be decompressed files are located
#' @param removeOriginal if TRUE, the function will delete the compressed files after decompression
#' @description
#' decompressFiles(
#'  filePath,
#'  removeOriginal = FALSE
#' )
#'
#' @export
decompressFiles <- function(filePath, removeOriginal = FALSE) {
    filePath <- stringr::str_remove(filePath, "/$")
    files <- list.files(filePath)
    files <- files[stringr::str_detect(files, ".txt.gz$")]

    for (i in seq_along(files)) {
        temp <- data.table::fread(glue::glue("{filePath}/{files[i]}"))
        outName <- stringr::str_remove(files[i], ".txt.gz")
        outName <- glue::glue("{filePath}/{outName}.csv")
        data.table::fwrite(temp, file = outName)

        if (removeOriginal) {
            unlink(glue::glue('{filePath}/{files[i]}'))
        }

        msg <- cli::style_bold(glue::glue("file {i}/{length(files)} done"))
        cat("\r", msg)
    }
}
