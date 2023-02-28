# Functions to make pulling VAN data easier

#' @title van_auth
#' @description Function to turn API key information in proper format for data retrieval
#'
#' @param username username associated with API Key
#' @param password The API Key
#' @param db For db, enter 1 for EA, 0 for myVoters
#'
#' @export
#' @importFrom RCurl "base64"
van_auth <- function(username,password,db){

  # Because of course it has to be sent in base64...
  api_key <- paste0(username,':',password,'|', db)
  api_base64 <<- paste0('Basic ',base64(api_key)[1])

}

#' get_contact_info
#'
#' @description Function to pull all people info on a given vanid.
#'
#' Options for expand: phones, emails, addresses, customFields, externalIds, recordedAddresses,
#' preferences, suppressions, reportedDemographics, disclosureFieldValues
#'
#' @param vanid Numeric person identifier
#' @param expand Character string representing a block of extra fields to include
#'
#' @return A table with all information found on a given individual
#'
#' @export
#'
#' @import httr
#' @import dplyr
#' @importFrom glue "glue"
#' @importFrom tidyr "unnest_wider"
#' @importFrom tibble "tibble_row"
get_contact_info <- function(vanid, expand='None'){

  # Making sure API key is available
  if(exists('api_base64')){
    print("Authentication found, making API call")
  }else if(!exists('api_base64')){
    stop("Authentication needed, run van_auth() first.")
  }

  # URL for API Call
  url <- if_else(expand == 'None'
                 ,glue("https://api.securevan.com/v4/people/{vanid}")
                 ,glue("https://api.securevan.com/v4/people/{vanid}?$expand={expand}")
                 )

  # API Call
  contact_raw <- VERB("GET", url, add_headers('authorization' = api_base64), content_type("application/octet-stream"), accept("application/json")) %>%
    content()

  # Turning returned JSON into a table
  contact <- contact_raw %>%
    list() %>%
    tibble_row(newdata=`.`) %>%
    unnest_wider(col=newdata)

  return(contact)

}

#' @title get_vanids
#' @description Function that makes an API call for VANIDs associated with a given event and returns a table of all event registrants. Can be expanded for more fields
#'
#' @param event_id Numeric event identifier
#'
#' @return A table table containing the VAN ID, first/last name, and signup date for event registrants
#'
#' @export
#'
#' @import dplyr
#' @import httr
get_vanids <- function(event_id){

  # Making sure API key is available
  if(exists('api_base64')){
    print("Authentication found, making API call")
  }else if(!exists('api_base64')){
    stop("Authentication needed, run van_auth() first.")
  }

  van_url <- glue("https://api.securevan.com/v4/signups?eventId={event_id}")

  signups_raw <- VERB("GET", van_url, add_headers('authorization' = api_base64), content_type("application/octet-stream"), accept("application/json"))

  signups <- content(signups_raw)$items

  event_vanid_tbl <- tibble(
    eventid = character()
    ,vanid = numeric()
    ,firstname = character()
    ,lastname = character()
    ,signup_dte=character())

  if(length(signups) > 0){
    for (x in 1:length(signups)){

      signupdte = signups[[x]]$dateModified

      event_vanid_tbl <- add_row(
        event_vanid_tbl
        ,eventid = event_id
        ,firstname = signups[[x]]$person$firstName
        ,lastname = signups[[x]]$person$lastName
        ,vanid = signups[[x]]$person$vanId
        ,signup_dte = signupdte
      )
    }

    print(paste0('done with eventid: ', event_id))

    return(event_vanid_tbl)
  }

}
