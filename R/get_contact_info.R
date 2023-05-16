#' get_contact_info
#'
#' @description Function to pull all people info on a given vanid.
#'
#'
#' @param vanid Numeric person identifier
#' @param expand Character string representing a block of extra fields to include. Options are: phones, emails, addresses, customFields, externalIds, recordedAddresses, preferences, suppressions, reportedDemographics, disclosureFieldValues.
#'
#' @return A table with all information found on a given individual
#'
#' @export
#'
#' @import httr
#' @import dplyr
#' @importFrom glue glue
#' @importFrom tidyr unnest_wider
#' @importFrom tibble tibble_row
get_contact_info <- function(vanid, expand='None'){

  # TO DO: Pull this auth check out as it's own function
  # Making sure API key is available
  if(exists('api_base64')){
    print("Authentication found, making API call")
  }else if(!exists('api_base64')){
    stop("Authentication needed, run van_auth() first.")
    # TO DO: Maybe actually run van_auth() instead of telling user to
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
