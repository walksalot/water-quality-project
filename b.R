library(dataRetrieval)
# Choptank River near Greensboro, MD
siteNumber <- "14070500"
ChoptankInfo <- readNWISsite(siteNumber)
parameterCd <- "00060"

# Raw daily data:
rawDailyData <- readNWISdv(
  siteNumber, parameterCd,
  "2010-01-01", "2017-01-01"
)


pCode <- readNWISpCode(parameterCd)


# Continuing from the previous example:
# This pulls out just the daily, mean data:

dailyDataAvailable <- whatNWISdata(
  siteNumber = "14070500",
  service = "dv",
  statCd = "00003"
)# Continuing from the previous example:
# This pulls out just the daily, mean data:

dailyDataAvailable <- whatNWISdata(
  siteNumber = "14070500",
  service = "dv",
  statCd = "00003"
)
