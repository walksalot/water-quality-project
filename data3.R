# Ensure the dataRetrieval package is installed and loaded
if (!requireNamespace("dataRetrieval", quietly = TRUE)) {
  install.packages("dataRetrieval")
}
library(dataRetrieval)

# Define variables for the site number, parameter code, and the start and end dates
siteNo <- "14070500"        # USGS site number
pCode <- "00060"            # Parameter code for discharge, cubic feet per second
start.date <- "2017-01-01"  # Start date for data retrieval
end.date <- "2018-09-30"    # End date for data retrieval

# Fetch daily values (daily data) for the specified site and parameter over the given date range
# Use the correct parameter names as expected by the readNWISdv function
daily_data <- readNWISdv(site = siteNo, parameterCd = pCode, startDate = start.date, endDate = end.date)

# Check if data was retrieved successfully and print the first few rows
if (nrow(daily_data) > 0) {
  print(head(daily_data))
  
  # Save the fetched data to a CSV file for offline analysis or backup
  # The file will be named 'KIBAKUSGS_Data.csv', and row names will not be included in the file
  write.csv(daily_data, file = "KIBAKUSGS_Data.csv", row.names = FALSE)
} else {
  cat("No data found for the given parameters.\n")
}


