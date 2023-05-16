#' @title generate_van_event_url
#' @description Determines the URL link for a given eventID so it's easier to find it in the smartVAN UI. Because why would they just let us search by event ID?? Can't let things be too easy! This process can work for many other ID types so this function could be expanded in the future.
#'
#' @param event_id Numeric event identifier
#'
#' @return A URL for the event
#'
#' @export
#'
#' @importFrom broman convert2hex
#' @importFrom stringr str_to_upper
#' @importFrom stringi stri_reverse
generate_van_event_url <- function(event_id){

  # The alphanumeric code at the end of the event URL is comprised of two parts. 1.) a reversed base-16 conversion of the eventID that we know and love. 2.) A letter from A-Q (why Q?!?) that was determined when the given event was created based on the event created previously. The steps below reverse engineer this madness.

  # 1.) Converting eventID to base-16 and reversing it, easy part
  eid_hex <- broman::convert2hex(event_id) %>% stringr::str_to_upper() %>% stringi::stri_reverse()

  # 2.) Determining where a given eventID is in the sequence of A-Q
  letter_pos <- (event_id %% 17)+1 # Calculate the remainder when the number is divided by 17. In order to get correct letter position, numbers must range from 1-17, instead of 0-16
  letter <- letters[letter_pos] %>% stringr::str_to_upper()

  # Putting it all together
  url <- paste0("https://www.targetsmartvan.com/EventDetailsNew.aspx?EventID=EID",eid_hex,letter)

  return(url)
}
