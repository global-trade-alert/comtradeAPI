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
    key = key,
    fileLocation,
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

    url <- httr::modify_url(base_url, query = attributes)
    # make API request
    request <- httr::GET(url)

    # check if request succeeded
    status <- httr::status_code(request)
    if (status != 200) {
        status <- httr::http_status(request)
        cli::cli_abort(status$message, call = NULL)
    } else if (status == 429) {
        cli::cli_abort("Rate limit exceeded: API Error Message: {status$message}", call = NULL)
    }

    content <- httr::content(request)
    content <- content$data

    # retreive files and store
    key_attr <- list("subscription-key" = key)
    for (i in seq_along(content)) {
        tryCatch(
        {
            cell <- content[[i]]
            file_url <- httr::modify_url(cell$fileUrl, query = key_attr)
            name <- glue::glue("{cell$reporterCode}_{cell$freqCode}_{cell$typeCode}_{cell$classificationCode}_{cell$period}")
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