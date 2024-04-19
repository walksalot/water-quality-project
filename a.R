install.packages("dataRetrieval")
library(dataRetrieval)
# Choptank River near Greensboro, MD
siteNumber <- "14070500"
ChoptankInfo <- readNWISsite(siteNumber)
parameterCd <- "00060"

# Raw daily data:
rawDailyData <- readNWISdv(
  siteNumber, parameterCd,
  "2015-01-01", "2020-01-01"
)

pCode <- readNWISpCode(parameterCd) 

specificCond <- readWQPqw(
  siteNumbers = "WIDNR_WQX-10032762",
  parameterCd = "Specific conductance",
  startDate = "2011-05-01",
  endDate = "2011-09-30"
)

features <- findNLDI(
  nwis = "14070500z",
  nav = "UT",
  find = c("basin", "wqp")
)

library(remotes)
install_github("DOI-USGS/dataRetrieval",
               build_vignettes = TRUE, 
               build_opts = c("--no-resave-data",
                              "--no-manual"))
