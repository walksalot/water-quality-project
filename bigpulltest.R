# Load packages
library(dataRetrieval)
library(dplyr)

# state code information for the 48 conterminous United States plus DC:
state_cd_cont <- stateCd[c(2,4:12,14:52),] 
rownames(state_cd_cont) <- seq(length=nrow(state_cd_cont)) # reset row sequence

for(i in seq_len(nrow(state_cd_cont))){
  
  state_cd <- state_cd_cont$STATE[i]
  state_nm <- state_cd_cont$STUSAB[i]
  message("Getting: ", state_nm)
  
  df_summary <- tryCatch({
    readWQPsummary(statecode = state_cd,
                   CharacteristicName = "Nitrogen",
                   siteType = "Stream")
  }, 
  error=function(cond) {
    message(paste("No data in:", state_nm))
    break()
  })
  
  sites <- df_summary |> 
    filter(YearSummarized >= 1995,
           YearSummarized <= 2020) |> 
    group_by(MonitoringLocationIdentifier, MonitoringLocationName, Provider) |> 
    summarise(start_year = min(YearSummarized, na.rm = TRUE),
              end_year = max(YearSummarized, na.rm = TRUE),
              count_activity = sum(ActivityCount, na.rm = TRUE),
              count_result = sum(ResultCount, na.rm = TRUE)) |> 
    ungroup() |> 
    filter(count_activity >= 40)
  
  if(nrow(sites) > 0){
    df_state <- tryCatch({
      readWQPdata(siteid = sites$MonitoringLocationIdentifier,
                  CharacteristicName = "Nitrogen",
                  startDateLo = "1995-01-01",
                  startDateHi = "2023-12-31",
                  sampleMedia = "Water", 
                  convertType = FALSE,
                  ignore_attributes = TRUE)
    }, 
    error=function(cond) {
      message(paste("No data in:", state_nm))
    })
    
    if(nrow(df_state) > 0){
      # I would write the data here, just in case:
      saveRDS(df_state, file = paste(state_nm, "data.rds", 
                                     sep = "_"))
      
    } else {
      message("No data in:", state_nm)
    }
  }
}
