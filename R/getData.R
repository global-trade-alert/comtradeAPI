#' Download data from comtrade
#'
#' @param key API key for the comtrade API (MANDATORY)
#' @param typeCode Type of trade: C for commodities and S for service (MANDATORY)
#' @param freqCode Trade frequency: A for annual and M for monthly (MANDATORY)
#' @param clCode Trade (IMTS) classification: HS, SITC, BEC or EBOPS (MANDATORY)
#' Available Options: HS, H0 - H6, S1-S4, BE, BE5, Eb, EB10, EB02, EBSDMX
#' @param reporterCode Reporter Code (possible values are M49 code of the countries)
#' Multi value input via vectors accepted
#'  See \code{ComtradeAPI::reporterCode} for country, code pairs (NOT MANDATORY)
#' @param period Year or month. Year should be 4 digit year.
#' Month should be six digit integer with the values of the form YYYYMM. Ex: 201002 for 2010 February.
#' Multi value input via vectors accepted  (NOT MANDATORY)
#' @param partnerCode Partner code (Possible values are M49 code) Multi value input via vectors accepted
#' @param Second partner/consignment code (Possible values are M49 code) Multi value input via vectors accepted
#' @param cmdCode Commodity code. Multi value input via vectors accepted.
#' @param flowCode Trade flow code. Multi value input via vectors accepted
#' @param customsCode Customs code. Multi value input via vectors accepted
#' @param motCode Mode of transport code. Multi value input via vectors accepted
#' @param aggregateBy Add parameters in csv list on which you want the results to be aggregated
#' @param breakdownMode Mode to choose from
#' @param includeDesc Include descriptions of data variables
#' @param maxRecords Maximum number of rows the query should return
#' @export
getData <- function(
    base_url = "https://comtradeapi.un.org/data/v1/get/",
    key = getPrimaryKey(),
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

    # add API key to query
    attributes <- list("subscription-key" = key)

    # add optional attributes to query
    argValues <- list(
        reporterCode = reporterCode, period = period, partnerCode = partnerCode, partner2Code = partner2Code,
        cmdCode = cmdCode, flowCode = flowCode, customsCode = customsCode, motCode = motCode,
        aggregateBy = aggregateBy, breakdownMode = breakdownMode, includeDesc = includeDesc, maxRecords = maxRecords
    )
    for (i in seq_along(argValues)) {
        attributes <- appendAttributes(names(argValues)[i], argValues[i], attributes, freqCode)
    }

    # get data
    out <- apiRequest(base_url, attributes)
    return(out)
}

