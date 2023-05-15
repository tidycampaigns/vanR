#' export_saved_list
#'
#' @description Function to pull all VANIDs from a given saved list.
#'#'
#' @param listid Numeric saved list identifier
#' @param listname Name for vector of saved list in global environment
#'
#' @return A vector of all VANIDs in the saved list
#'
#' @export
#'
#' @import httr
#' @import dplyr
#' @importFrom glue "glue"

export_saved_list <- function(listid, listname=NULL) {
  
  # Making sure API key is available
  if(exists('api_base64')){
    print("Authentication found, making API call")
  }else if(!exists('api_base64')){
    stop("Authentication needed, run van_auth() first.")
  }
  
  # URL for API Call
  url_export <- glue::glue("https://api.securevan.com/v4/exportJobs")
  url_savedlist <- glue::glue("https://api.securevan.com/v4/savedLists/{listid}")
  
  # Body for API Call
  json_export <- list(
    savedListID = as.character(listid),
    type = 4,
    webhookUrl = "https://webhook.example.org/completedExportJobs"
    )
  
  json_listname <- list(
    savedListID = as.character(listid)
  )

  # API Call
  datareturn <- VERB("POST", url_export, add_headers('authorization' = api_base64), content_type("application/json"), accept("application/json"), body = json_export, encode = "json") %>%
    content()
  
  name_return <- VERB("GET", url_savedlist, add_headers('authorization' = api_base64), content_type("application/json"), accept("application/json"), body = json_listname, encode = "json") %>%
    content()
  
  # Pull VANIDs from CSV at Download URL and save to global environment
  export <- read.csv(datareturn$downloadUrl) %>% pull(VanID)

  name <- coalesce(listname, name_return$name)

  assign(name, export, envir = .GlobalEnv)

  print(paste0("successfully downloaded list: ", name))
}