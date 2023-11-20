# need to supply a few more parameters!
getBulkDataFromLink <- function(
    key = getPrimaryKey(),
    data,
    filePath,
    timeout = 300
) {
    if (!all(c("fileUrl", "reporterCode", "freqCode", "typeCode", "classificationCode", "period") %in% colnames(data))) {
        cli::cli_abort("make sure input data frame contains the required columns")
    }
    # retreive files and store
    key_attr <- list("subscription-key" = key)

    defaultTimeout <- getOption("timeout")
    options(timeout = timeout)

    for (i in seq_along(data$fileUrl)) {
        tryCatch(
        {
            # downlaod as binary
            file_url <- httr::modify_url(data$fileUrl[i], query = key_attr)
            entry <- data[i,]
            name <- glue::glue("{entry$reporterCode}_{entry$freqCode}_{entry$typeCode}_{entry$classificationCode}_{entry$period}")
            sizeMsg <- cli::style_bold(glue::glue("downloading {data$fileSize[i]} ..."))
            progressMsg <- cli::style_bold(cli::col_green(glue::glue("file {i}/{nrow(data)} downloading")))
            cat("\r", sizeMsg, " ", progressMsg)
            download.file(file_url, destfile = glue::glue("{filePath}/{name}.txt.gz"), mode = "wb", quiet = TRUE)
        },
            error = function(e) {
                cli::cli_abort("Error in download of file {entry$reporterCode}_{entry$freqCode}_{entry$typeCode}_{entry$classificationCode}_{entry$period}")
            }
        )
        # sleep 4s after every 10th call
        if (i %% 10 == 0) {
            Sys.sleep(4)
        }
    }
    # set timeout back to default
    options(timeout = defaultTimeout)
}