#' Download bulk data from Comtrade
#'
#' @param key API key for the comtrade API (MANDATORY)
#' @param typeCode Type of trade: C for commodities and S for service (MANDATORY)
#' @param freqCode Trade frequency: A for annual and M for monthly (MANDATORY)
#' @param clCode Trade (IMTS) classification: HS, SITC, BEC or EBOPS (MANDATORY)
#' @param reporterCode Reporter Code (possible values are M49 code of the countries)
#'  See \code{ComtradeAPI::reporterCode} for country, code pairs (NOT MANDATORY)
#' @param period Year or month. Year should be 4 digit year. (NOT MANDATORY)
#' Month should be six digit integer with the values of the form YYYYMM. Ex: 201002 for 2010 February.
#' Multi value input should be in the form of csv (Codes separated by comma (,))
#' @param publishedDateFrom Publication date From YYYY-MM-DD (NOT MANDATORY)
#' @param publishedDateTo Publication date To YYYY-MM-DD (NOT MANDATORY)
#' @returns # description of what the function returns
#' @description
#' getBulkData(
#'  base_url = "https://comtradeapi.un.org/bulk/v1/get"
#'  key,
#'  typeCode = "C",
#'  freqCode = "A",
#'  clCode = "HS",
#'  reporterCode = NULL,
#'  period = NULL,
#'  publishedDateFrom = NULL,
#'  publishedDateTo = NULL,
#'  fileLocation = NULL
#')
#' @export
getBulkData <- function(
    base_url = "https://comtradeapi.un.org/bulk/v1/get",
    key = getPrimaryKey(),
    fileLocation,
    typeCode = "C",
    freqCode = "A",
    clCode = "HS",
    reporterCode = NULL,
    period = NULL,
    publishedDateFrom = NULL,
    publishedDateTo = NULL
) {

    # get file with links
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

    getBulkDataFromLink(key, links, fileLocation)
}