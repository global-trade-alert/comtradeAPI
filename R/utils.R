# not exported helper function
appendAttributes <- function(name, value, attributeList, freqCode) {
    if (name == "period") {
        if (!is.null(value) && value != "NULL") {
            # generate monthly period values if freq is M but period is in years
            if (freqCode == "M" && all(nchar(value) == 4)) {
                months <- 1:12 %>%
                    stringr::str_pad(width = "2", pad = "0", side = "left")
                value <- rep(value, each = length(months))
                value <- paste0(value, months, collapse = ",")
            } else if (freqCode == "M" && !all(nchar(value) == 6)) {
                cli::cli_abort("Supplied period values are not all in same format")
            } else if (freqCode == "A" && !all(nchar(value) == 4)) {
                cli::cli_abort("FreqCode A indicated but not all periods are YYYY")
            } else {
                value <- paste(value, collapse = ",")
            }
            attributeList <- append(attributeList, setNames(value, "period"))
        }
    } else {
        if (!is.null(value) && value != "NULL") {
            temp <- paste0(value, collapse = ",")
            attributeList <- append(attributeList, setNames(temp, name))
        }
    }
    return(attributeList)
}