setPrimaryKey <- function(key = NULL){
    if (is.null(key)){
        key <- askpass::askpass("Enter your API Key")
    }
    Sys.setenv("COMTRADE_KEY" = key)
}

getPrimaryKey <- function(){
    key <- Sys.getenv("COMTRADE_KEY")
    if (key != ""){
        return(key)
    } else {
        cli::cli_abort("No API Key found. Please use `setPrimaryKey()` to set one")
    }
}
