% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_signup_vanids.R
\name{get_signup_vanids}
\alias{get_signup_vanids}
\title{get_signup_vanids}
\usage{
get_signup_vanids(event_id)
}
\arguments{
\item{event_id}{Numeric event identifier}
}
\value{
A table table containing the VAN ID, first/last name, and signup date for event registrants
}
\description{
Function that makes an API call for VANIDs associated with a given event and returns a table of all event registrants. Can be expanded for more fields
}
