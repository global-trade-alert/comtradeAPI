#' Download bulk data from Comtrade
#'
#' @param key API key for the comtrade API (MANDATORY)
#' @param typeCode Type of trade: C for commodities and S for service (MANDATORY)
#' @param freqCode Trade frequency: A for annual and M for monthly (MANDATORY)
#' @param clCode Trade (IMTS) classification: HS, SITC, BEC or EBOPS (MANDATORY)
#' @param reporterCode Reporter Code (possible values are M49 code of the countries)
#'  See \code{ComtradeAPI::reporterCode} for country, code pairs (NOT MANDATORY)
#' @param period Year or month. Year should be 4 digit year.
#' Month should be six digit integer with the values of the form YYYYMM. Ex: 201002 for 2010 February.
#' Multi value input should be in the form of csv (Codes separated by comma (,))  (NOT MANDATORY)
#' @param publishedDateFrom Publication date From YYYY-MM-DD (NOT MANDATORY)
#' @param publishedDateTo Publication date To YYYY-MM-DD (NOT MANDATORY)
#' @export
getBulkData <- function(
    base_url = "https://comtradeapi.un.org/bulk/v1/get",
    key = getPrimaryKey(),
    filePath,
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
    links <- apiRequest(base_url, attributes)

    if (length(links) == 0){
        cli::cli_abort("No files found with these parameters")
    } else {
        getBulkDataFromLink(key, links, filePath)
    }
}