




#'@export
get_stat_code <- function(.statistic){
  # Available temperature statistics
  #Max-24h
  #Max-Day-Time
  #Mean-24h
  #Mean-Day-Time
  #Mean-Night-Time
  #Min-24h
  #Min-Night-Time
  if(.statistic == 1)stat_code <- "Max-24h"
  if(.statistic == 2)stat_code <- "Max-Day-Time"
  if(.statistic == 3)stat_code <- "Mean-24h"
  if(.statistic == 4)stat_code <- "Mean-Day-Time"
  if(.statistic == 5)stat_code <- "Mean-Night-Time"
  if(.statistic == 6)stat_code <- "Min-24h"
  if(.statistic == 7)stat_code <- "Min-Night-Time"

  return(stat_code)

}

#'@export
#'
get_temp_stats <- function(){
  return(c("1 = Max-24h",
           "2 = Max-Day-Time",
           "3 = Mean-24h",
           "4 = Mean-Day-Time",
           "5 = Mean-Night-Time",
           "6 = Min-24h",
           "7 = Min-Night-Time"))
}

#'@export
get_temp_stats_cds <- function(){
  cat("Available temperature statistics: \n
  24_hour_maximum\n
  24_hour_mean\n
  24_hour_minimum\n
  day_time_maximum\n
  day_time_mean\n
  night_time_mean\n
  night_time_minimum")
}







