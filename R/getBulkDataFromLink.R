# need to supply a few more parameters!
getBulkDataFromLink <- function(key = key, data, fileLocation) {

    if (!all(c("fileUrl", "reporterCode", "freqCode", "typeCode", "classificationCode", "period") %in% colnames(data))) {
        stop("make sure input data frame contains the required columns")
    }
    # retreive files and store
    key_attr <- list("subscription-key" = key)
    for (i in content$fileUrl) {
        tryCatch(
        {
            file_url <- httr::modify_url(i, query = key_attr)
            name <- glue::glue("{data$reporterCode}_{data$freqCode}_{data$typeCode}_{data$classificationCode}_{data$period}")
            download.file(file_url, destfile = glue::glue("{fileLocation}/{name}.gz"))
        },
            error = function(e) {
                print("something went wrong") # specify behavior more clearly
            }
        )
        # sleep 5s after every 10th call
        if (i %% 10 == 0) {
            Sys.sleep(5)
        }
    }
}