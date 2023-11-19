# helper function not exported from the package
apiRequest <- function(base_url, attributes) {

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

    # transform to dataframe
    content <- content %>%
        purrr::map_dfr(\(x) x)

    return(content)
}