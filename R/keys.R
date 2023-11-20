#' set and retreive comtrade API key
#'
#' Use thesee functions to supply your comtrade API key which is needed for the other functions
#' in this package to interact with the API
#'
#' @param key your comtrade API key
#' @description
#' setPrimaryKey(key)
#' getPrimaryKey()
#' @export
#'
#' @describeIn Keys set API key
setPrimaryKey <- function(key = NULL){
    if (is.null(key)){
        key <- askpass::askpass("Enter your API Key")
    }
    Sys.setenv("COMTRADE_KEY" = key)
}

#' @describeIn Keys get API key
getPrimaryKey <- function(){
    key <- Sys.getenv("COMTRADE_KEY")
    if (key != ""){
        return(key)
    } else {
        cli::cli_abort("No API Key found. Please use `setPrimaryKey()` to set one")
    }
}

