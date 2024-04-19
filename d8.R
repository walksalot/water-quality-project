library(ggplot2)
library(dataRetrieval)
library(forecast)
options(width = 1000)  # Set this to a large enough value
#options(width = defaultWidth)  # Reset to default or a manageable width

siteNo <- "14070500"
pCode <- readNWISpCode("all")
start.date <- "2018-01-01"
end.date <- "2019-01-01"

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
# Plotting streamflow data
ggplot(MIDDLED, aes(x = dateTime, y = X_00060_00003)) +
  geom_line() +  # Line plot
  labs(title = "Streamflow Over Time", x = "Date", y = "Streamflow (cfs)") +
  theme_minimal()

# Example: Simple Time Series Analysis
# Convert data to a time series object
flow_ts <- ts(MIDDLED$X_00060_00003, frequency = 365)
# Decompose the time series
decomp <- stl(flow_ts, s.window = "periodic")
# Plot the decomposed components
plot(decomp)


print(attr(MIDDLED, "url"), width = 1000)  # Increase the width as necessary

cat(attr(MIDDLED, "url"), "\n")  # This will print the full URL followed by a newline


