# NGP VAN API Sync

last update: 5/16/2023

## Purpose

This package is intended to contain helpful functions for working with NGP VAN's API. Use of any of the functions require that the user have an API key. [API Documentation](https://docs.ngpvan.com/reference/overview)

## Functions

Below contains a brief description of each function with their intended purpose.

**van_auth:** Combines username, API key, and database type and converts it into base64 for data retrieval.

**get_contact_info:** Pulls all person information for a given VANID. Can expand request for more extra fields. Options for expansion are: phones, emails, addresses, customFields, externalIds, recordedAddresses, preferences, suppressions, reportedDemographics, disclosureFieldValues.

## Permissions

When you intitially get a VAN API key, you will need to request some specific permissions from VAN Support.

- In order to export a List, you will need to specifically ask for your API to be permissioned for ExportJobsTypeId = 4

**get_signup_vanids:** Pulls VANIDs associated with a given event and returns a table of all event registrants. Returns a table with VANID, first/last name, and signup date.

**export_saved_list:** Pulls all VANIDs from a given saved list. Returns vector of VANIDs.

**generate_van_event_url:** Determines the URL link for a given eventID so it's easier to find it in the smartVAN UI. This process can work for many other ID types so this function could be expanded in the future.
