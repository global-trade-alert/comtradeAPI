#' Download bulk data from Comtrade
#'
#' @param key API key for the comtrade API (MANDATORY)
#' @param typeCode Type of trade: C for commodities and S for service (MANDATORY)
#' @param freqCode Trade frequency: A for annual and M for monthly (MANDATORY)
#' @param clCode Trade (IMTS) classification: HS, SITC, BEC or EBOPS (MANDATORY)
#' @param reporterCode Reporter Code (possible values are M49 code of the countries)
#' Multi value input via vectors accepted
#'  See \code{ComtradeAPI::reporterCode} for country, code pairs (NOT MANDATORY)
#' @param period Year or month. Year should be 4 digit year.
#' Month should be six digit integer with the values of the form YYYYMM. Ex: 201002 for 2010 February.
#' Multi value input via vectors accepted (NOT MANDATORY)
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
    if (missing(filePath)){
        cli::cli_abort("Parameter FilePath is missing")
    }
    # base URL with mandatory parameters
    base_url <- glue::glue("{base_url}/{typeCode}/{freqCode}/{clCode}")

    links <- previewBulkData(
        base_url = "https://comtradeapi.un.org/bulk/v1/get",
        key = key,
        typeCode = typeCode,
        freqCode = freqCode,
        clCode = clCode,
        reporterCode = reporterCode,
        period = period,
        publishedDateFrom = publishedDateFrom,
        publishedDateTo = publishedDateTo
    )

    if (length(links) == 0) {
        cli::cli_abort("No files found with these parameters")
    } else {
        getBulkDataFromLink(key, links, filePath)
    }
}