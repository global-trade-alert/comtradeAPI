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

    # convert period input
    if (!is.null(period)) {
        # generate monthly period values if freq is M but period is in years
        if (freqCode == "M" && all(stringr::str_length(period) == 4)) {
            months <- 1:12 %>%
                stringr::str_pad(width = "2", pad = "0", side = "left")
            period <- rep(period, each = length(months))
            period <- paste0(period, months, collapse = ",")
        } else if (freqCode == "M" && !all(stringr::str_length(period) == 6)) {
            cli::cli_abort("Supplied period values are not all in same format")
        } else if (freqCode == "A" && !all(stringr::str_length(period) == 4)) {
            cli::cli_abort("FreqCode A indicated but not all periods are YYYY")
        } else {
            period <- paste(period, collapse = ",")
        }
        attributes <- append(attributes, setNames(period, "period"))
    }
	
	# values with possible vector input
    if (!is.null(reporterCode)) {
        reporterCode <- paste(reporterCode, collapse = ",")
        attributes <- append(attributes, setNames(reporterCode, "reporterCode"))
    }

	# single values
	singleValues <- c("publishedDateFrom" = publishedDateFrom, "publishedDateTo" = publishedDateTo)
	
	for (i in seq_along(singleValues)){
    	if (!is.null(singleValues[i])) {
        	attributes <- append(attributes, setNames(singleValues[i], names(singleValues)[i])
    	}
	}

    # get data
    content <- apiRequest(base_url, attributes)
    return(content)
}
