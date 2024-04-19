# Package installation and loading
packages <- c("dataRetrieval", "DBI", "RSQLite", "logging", "lubridate", "progress")
lapply(packages, function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
  library(pkg, character.only = TRUE)
})

# Setup database connection and prepare table
setupDatabaseConnection <- function(dbname) {
  dbConn <- dbConnect(RSQLite::SQLite(), dbname = dbname)
  if (!dbExistsTable(dbConn, "WaterData")) {
    dbExecute(dbConn, "CREATE TABLE WaterData (SiteNumber TEXT, DateTime DATE, Value DOUBLE)")
    dbExecute(dbConn, "CREATE INDEX IF NOT EXISTS idx_date ON WaterData(DateTime)")
  }
  return(dbConn)
}

# Function to retrieve and store water data with corrected date handling
retrieveAndStoreData <- function(siteNumber, parameterCd, startDate, endDate, dbConn) {
  startDate <- as.Date(startDate)
  endDate <- as.Date(endDate)
  intervals <- ceiling(as.integer(difftime(endDate, startDate, units = "days")) / 365)
  pb <- progress_bar$new(total = intervals, format = "  downloading [:bar] :percent :etas", width = 60)

  for (i in 0:(intervals - 1)) {
    yearStart <- max(startDate, ceiling_date(startDate + years(i), "year"))
    yearEnd <- min(endDate, floor_date(startDate + years(i + 1), "year") - days(1))

    if (yearStart > yearEnd) {
      logwarn(paste("Skipping invalid date range:", as.character(yearStart), "to", as.character(yearEnd)))
      next
    }

    loginfo(paste("Retrieving data for period:", as.character(yearStart), "to", as.character(yearEnd)))
    attempt_limit <- 3
    for (attempt in 1:attempt_limit) {
      try({
        waterData <- readNWISdv(siteNumbers = siteNumber, parameterCd = parameterCd, startDate = yearStart, endDate = yearEnd)
        if (nrow(waterData) > 0) {
          dbWriteTable(conn = dbConn, name = "WaterData", value = waterData, append = TRUE, row.names = FALSE)
          loginfo(paste("Stored", nrow(waterData), "records from", as.character(yearStart), "to", as.character(yearEnd)))
          pb$tick()
          break
        } else {
          loginfo(paste("No data retrieved for", as.character(yearStart), "to", as.character(yearEnd)))
        }
      }, silent = TRUE)
      if (attempt == attempt_limit) {
        logwarn(paste("Failed to retrieve data after", attempt_limit, "attempts for period:", as.character(yearStart), "to", as.character(yearEnd)))
      }
    }
  }
}

# Function to check the database file size
checkFileSize <- function(dbname) {
  fileInfo <- file.info(dbname)
  fileSize <- fileInfo$size / 1024^2
  loginfo(paste("Current database size:", round(fileSize, 2), "MB"))
}

# Main function to orchestrate the workflow
main <- function() {
  basicConfig()
  loginfo("Starting data retrieval process")

  dbConn <- setupDatabaseConnection("my_water_data.db")
  retrieveAndStoreData("14070500", "00060", "1900-01-01", "2020-12-31", dbConn)

  checkFileSize("my_water_data.db")
  dbDisconnect(dbConn)
  loginfo("Data retrieval and storage process completed successfully.")
}

# Execute the main function
main()
