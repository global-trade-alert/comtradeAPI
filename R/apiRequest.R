# helper function not exported from the package
apiRequest <- function(base_url, attributes) {

    url <- httr::modify_url(base_url, query = attributes)

    # check query length
    if (stringr::str_length(url) > 4095) {
        cli::cli_abort("generated request is > 4096 characters. Please supply less arguments", call = NULL)
    }

    # define transient behavior
    isTransient <- function(resp) {
        return(httr2::resp_status(resp) == 429)
    }

    comtradeAfter <- function(resp) {
        after <- as.numeric(httr2::resp_header(resp, "Retry-After"))
        return(after)
    }

    # execute request
    request <- httr2::request(url) %>%
        httr2::req_throttle(rate = 20 / 60) %>% # rate limit of 20 calls per minute
        httr2::req_retry(is_transient = isTransient, after = comtradeAfter, max_tries = 2) %>%
        httr2::req_perform()

    content <- httr2::resp_body_json(request, simplifyVector = TRUE)
    content <- content$data

    return(content)
}