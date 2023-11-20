#' Preview files to be downloaded from comtradeAPI::getBulkData()
#'
#' @description
#' This function allows you to catch a glimpse at the links which would be downloaded
#' were you to pass the same parameters in \code{comtradeAPI::getBulkData}
#' This includes information such as the size of each file as well as its contents
#'
#' When you wish to download multiple files in bulk, it is recommended to run this function first and store the output as a dataframe
#' to check which files you will be downloading. In case you do not wish to download all files, simply remove
#' the rows which you do not want to download and then pass the dataframe to the parameter 'data' in \code{comtradeAPI::getBulkDataFromLink}

#' @inheritParams getBulkData

previewBulkData <- function(
    base_url = "https://comtradeapi.un.org/bulk/v1/get",
    key = getPrimaryKey(),
    typeCode = "C",
    freqCode = "A",
    clCode = "HS",
    reporterCode = NULL,
    period = NULL,
    publishedDateFrom = NULL,
    publishedDateTo = NULL
) {
    # base URL with mandatory parameters
    base_url <- glue::glue("{base_url}/{typeCode}/{freqCode}/{clCode}")

    # add optional parameters & API key to url
    attributes <- list("subscription-key" = key)

    # get function arguments supplied
    argValues <- match.call() %>%
        as.list()

    # remove values which are specified in base_url
    mandatory_values <- c("", "key", "base_url", "typeCode", "freqCode, clCode", "fileLocation")
    argValues <- argValues[!names(argValues) %in% mandatory_values]
    argNames <- names(argValues)

    for (i in seq_along(argValues)) {
        if (!is.null(argValues[i])) {
            attributes <- append(attributes, setNames(argValues[i], argNames[i]))
        }
    }
    # get data
    content <- apiRequest(base_url, attributes)
    return(content)
}
