#' Download data from comtrade
#'
#' @param key API key for the comtrade API (MANDATORY)
#' @param typeCode Type of trade: C for commodities and S for service (MANDATORY)
#' @param freqCode Trade frequency: A for annual and M for monthly (MANDATORY)
#' @param clCode Trade (IMTS) classification: HS, SITC, BEC or EBOPS (MANDATORY)
#' Available Options: HS, H0 - H6, S1-S4, BE, BE5, Eb, EB10, EB02, EBSDMX
#' @param reporterCode Reporter Code (possible values are M49 code of the countries)
#'  See \code{ComtradeAPI::reporterCode} for country, code pairs (NOT MANDATORY)
#' @param period Year or month. Year should be 4 digit year. (NOT MANDATORY)
#' Month should be six digit integer with the values of the form YYYYMM. Ex: 201002 for 2010 February.
#' Multi value input should be in the form of csv (Codes separated by comma (,))
#' @param partnerCode Partner code (Possible values are M49 code of the countries separated by comma (,))
#' @param Second partner/consignment code (Possible values are M49 code of the countries separated by comma (,))
#' @param cmdCode Commodity code. Multi value input should be in the form of csv (Codes separated by comma (,))
#' @param flowCode Trade flow code. Multi value input should be in the form of csv (Codes separated by comma (,))
#' @param customsCode Customs code. Multi value input should be in the form of csv (Codes separated by comma (,))
#' @param motCode Mode of transport code. Multi value input should be in the form of csv (Codes separated by comma (,))
#' @param aggregateBy Add parameters in csv list on which you want the results to be aggregated
#' @param breakdownMode Mode to choose from
#' @param includeDesc Include descriptions of data variables
#' @param maxRecords Maximum number of rows the query should return
#' @description
#' getData(
#'  base_url = "https://comtradeapi.un.org/data/v1/get/",
#'  key,
#'  typeCode = "C",
#'  freqCode = "A",
#'  clCode = "HS",
#'  reporterCode = NULL,
#'  period = NULL,
#'  partnerCode = NULL,
#'  partner2Code = NULL,
#'  cmdCode = NULL,
#'  flowCode = NULL,
#'  customsCode = NULL,
#'  motCode = NULL,
#'  aggregateBy = NULL,
#'  breakdownMode = NULL,
#'  includeDesc = NULL,
#'  maxRecords = NULL
#' )
#' @import magrittr
#'
#' @export
getData <- function(
    base_url = "https://comtradeapi.un.org/data/v1/get/",
    key,
    typeCode = "C",
    freqCode = "A",
    clCode = "HS",
    reporterCode = NULL,
    period = NULL,
    partnerCode = NULL,
    partner2Code = NULL,
    cmdCode = NULL,
    flowCode = NULL,
    customsCode = NULL,
    motCode = NULL,
    aggregateBy = NULL,
    breakdownMode = NULL,
    includeDesc = NULL,
    maxRecords = NULL
) {

    # base URL with mandatory parameters
    base_url <- glue::glue("{base_url}/{typeCode}/{freqCode}/{clCode}")

    # add optional parameters & API key to url
    attributes <- list("subscription-key" = key)

    # get function arguments supplied
    argValues <- match.call() %>%
        as.list()

    # remove values which are specified in base_url
    mandatory_values <- c("", "key", "base_url", "typeCode", "freqCode, clCode")
    argValues <- argValues[!names(argValues) %in% mandatory_values]
    argNames <- names(argValues)

    for (i in seq_along(argValues)) {
        if (!is.null(argValues[i])) {
            attributes <- append(attributes, setNames(argValues[i], argNames[i]))
        }
    }

    url <- httr::modify_url(base_url, query = attributes)

    # make API request
    request <- httr::GET(url)

    # check if request succeeded
    status <- httr::status_code(request)
    if (!status == 200) {
        status <- httr::http_status(request)
        cli::cli_abort(status$message)
    } else if (status == 429) {
        cli::cli_abort("Rate limit exceeded API Error Message: {status$message}", call = NULL)
    }

    content <- httr::content(request)
    content <- content$data

    # convertes nested list to dataFrame
    out <- content %>%
        purrr::map_dfr(\(x) x)

    return(out)
}
