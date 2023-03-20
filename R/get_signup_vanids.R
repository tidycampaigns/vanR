#' @title get_signup_vanids
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
get_signup_vanids <- function(event_id){

  # TO DO: Pull this auth check out as it's own function
  # Making sure API key is available
  if(exists('api_base64')){
    print("Authentication found, making API call")
  }else if(!exists('api_base64')){
    stop("Authentication needed, run van_auth() first.")
    # TO DO: Maybe actually run van_auth() instead of telling user to
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
