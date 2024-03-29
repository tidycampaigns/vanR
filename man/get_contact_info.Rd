% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_contact_info.R
\name{get_contact_info}
\alias{get_contact_info}
\title{get_contact_info}
\usage{
get_contact_info(vanid, expand = "None")
}
\arguments{
\item{vanid}{Numeric person identifier}

\item{expand}{Character string representing a block of extra fields to include. Options are: phones, emails, addresses, customFields, externalIds, recordedAddresses, preferences, suppressions, reportedDemographics, disclosureFieldValues.}
}
\value{
A table with all information found on a given individual
}
\description{
Function to pull all people info on a given vanid.
}
