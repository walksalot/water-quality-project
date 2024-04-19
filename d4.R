siteNo <- "14070500"
pCode <- "00060"
start.date <- "2011-10-01"
end.date <- "2018-01-01"

middled <- readNWISuv(siteNumbers = siteNo,
                       parameterCd = pCode,
                       startDate = start.date,
                       endDate = end.date)