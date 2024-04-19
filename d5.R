siteNo <- "14070500"
pcode <- readNWISpCode("all")
start.date <- "2011-10-01"
end.date <- "2024-01-01"

MIDDLED <- readNWISuv(siteNumbers = siteNo,
                       parameterCd = pCode,
                       startDate = start.date,
                       endDate = end.date)

# View the first few rows of the data
head(MIDDLED)

# Summary of the data to understand distributions and possible missing values
summary(MIDDLED)

# Structure of the data to understand types of columns
str(MIDDLED)


# Removing rows with missing data
MIDDLED <- na.omit(MIDDLED)

# Filtering based on a condition, for example, removing extremely low flows that might be errors
MIDDLED <- MIDDLED[MIDDLED$X_00060_00003 > 10, ]

# Load necessary library
library(ggplot2)

# Plotting streamflow data
ggplot(MIDDLED, aes(x = dateTime, y = X_00060_00003)) +
  geom_line() +  # Line plot
  labs(title = "Streamflow Over Time", x = "Date", y = "Streamflow (cfs)") +
  theme_minimal()

