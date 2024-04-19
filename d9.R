# Load the required packages
library(dataRetrieval)
library(ggplot2)

# Define parameters for the data retrieval
siteNo <- "14070500"  # USGS site number
pCode <- "00060"      # Parameter code for streamflow, cubic feet per second
start.date <- "2020-01-01"  # Starting date for data retrieval
end.date <- format(Sys.Date(), "%Y-%m-%d")  # Ending date set to today's date

# Fetch data using readNWISuv to get unit value time series data
tryCatch({
    middled <- readNWISuv(siteNumbers = siteNo, parameterCd = pCode, startDate = start.date, endDate = end.date)
}, error = function(e) {
    cat("Error in fetching data: ", e$message, "\n")
})

# Check if data is fetched and print structure
if (exists("middled") && nrow(middled) > 0) {
    print("Data fetched successfully.")
    str(middled)
} else {
    cat("No data fetched or 'middled' not created.\n")
    # Early exit if data not fetched to avoid further errors
    return()
}

# Ensure columns are not lists and convert to appropriate types
middled[] <- lapply(middled, function(x) {
    if (is.list(x)) {
        as.numeric(unlist(x))
    } else {
        x
    }
})

# Check the structure again to confirm changes
str(middled)

# Proceed with data visualization
# Plotting the streamflow data
if ("dateTime" %in% names(middled) && "X_00060_00003" %in% names(middled)) {
    ggplot(middled, aes(x = dateTime, y = X_00060_00003)) +
        geom_line() +
        labs(title = "Streamflow Over Time",
             x = "Date",
             y = "Streamflow (cfs)") +
        theme_minimal()
} else {
    cat("The necessary columns for plotting are not available in 'middled'.\n")
}
