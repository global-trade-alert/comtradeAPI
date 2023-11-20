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
            entry <- data[i, ]
            name <- glue::glue("{entry$reporterCode}_{entry$freqCode}_{entry$typeCode}_{entry$classificationCode}_{entry$period}")
            download.file(file_url, destfile = glue::glue("{filePath}/{name}.txt.gz"), mode = "wb")
        },
            error = function(e) {
                print("something went wrong") # specify behavior more clearly
            }
        )
        # sleep 3s after every 5th call
        if (i %% 5 == 0) {
            Sys.sleep(3)
        }
    }
    # set timeout back to default
    options(timeout = defaultTimeout)
}