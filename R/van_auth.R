# Functions to make pulling VAN data easier

#' @title van_auth
#' @description Function to turn API key information into proper format for data retrieval
#'
#' @param username username associated with API Key
#' @param password The API Key
#' @param db For db, enter 1 for EA, 0 for myVoters
#'
#' @export
#' @importFrom RCurl base64
van_auth <- function(username,password,db){

  # Because of course it has to be sent in base64...
  api_key <- paste0(username,':',password,'|', db)
  api_base64 <<- paste0('Basic ',base64(api_key)[1])

}
