previewBulkData <- function(
    base_url = "https://comtradeapi.un.org/bulk/v1/get",
    key = key,
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
