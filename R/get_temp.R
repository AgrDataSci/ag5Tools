#'This set of functions extract temperature data from locally stored AgERA5 data
#'@name get_temp

#'@param .date a date or character representing the date of the point data to be extracted
#'@param .location_xy a data.frame or an object to be coerced, with longitud and latitude
#'@param .var a character of the variable of interest
#'@param .statistic an integer for the statistic to extract, options are:
#'1 = Max-24h,
#'2 = Max-Day-Time
#'3 = Mean-24h
#'4 = Mean-Day-Time
#'5 = Mean-Night-Time
#'6 = Min-24h
#'7 = Min-Night-Time
#'
#'@param .agera5_folder a character with folder location
#'


#'@export
agera5_temp_extract <- function(.date,
                           .location_xy,
                           .var,
                           .statistic,
                           .agera5_folder){

  file_path <- get_filepath(.var, .statistic, .date,.agera5_folder)

  agera5_brick <- brick(file_path)

  data_out <- raster::extract(agera5_brick, .location_xy)

  date_to_extract <- gsub(x = .date, pattern = "-", replacement = ".")

  date_to_extract <- paste0("X", date_to_extract)

  extracted_data <- data_out[1, date_to_extract]

  return(extracted_data)

}

#'@export
extract_period <- function(.start_date,
                           .end_date,
                           .location_xy,
                           .var,.statistic,
                           .agera5_folder){

  .start_date <- as.Date(.start_date,format = "%m/%d/%Y")
  .end_date <- as.Date(.end_date,format = "%m/%d/%Y")
  time_span <- seq.Date(from = .start_date, to = .end_date, by = "days")
  data_out_period <- array(dim = c(1, length(time_span)))

  for(i in 1:length(time_span)){
    data_out_period[, i] <- agera5_temp_extract(time_span[i], .location_xy, .var, .statistic, .agera5_folder)
  }

  colnames(data_out_period) <- as.character(time_span)

  data_out_period <- data_out_period - 273.15

  return(data_out_period)
}

get_filepath <- function(.var, .statistic, .date_to_search, .agera5_folder){
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

  var_to_search <- .var

  temp_prefix <- paste0("Temperature-Air-2m-", stat_code, "_C3S-glob-agric_AgERA5_daily_")

  year_to_search <- format(.date_to_search, "%Y")
  month_to_search <- format(.date_to_search, "%m")
  date_pattern <- paste0(year_to_search, month_to_search)
  agera5_file_pattern <- paste0(temp_prefix, date_pattern)
  files_ <- list.files(paste(.agera5_folder, var_to_search, year_to_search, sep = "/"))
  file_name <- files_[stringr::str_detect(files_, agera5_file_pattern)]
  agera5_file_path <- paste(.agera5_folder, var_to_search, year_to_search, file_name, sep="/")

  return(agera5_file_path)

}


#'@export
extract_temp_dataset <- function(.trial_dataset,
                                 .stat,
                                 .agera5_folder){

  extracted_dataset <- NULL

  progress_bar <- txtProgressBar(min = 0, max = nrow(.trial_dataset), style = 3)

  for(i in 1:nrow(.trial_dataset)){
    extracted_dataset[[i]] <- extract_period(.trial_dataset[i, ]$pdate,
                                             .trial_dataset[i, ]$hdate,
                                             data.frame(lon = .trial_dataset[i, ]$lon, lat = .trial_dataset[i, ]$lat),
                                             "temp",
                                             .stat,
                                             .agera5_folder)

    Sys.sleep(0.1)
    setTxtProgressBar(progress_bar, i)

}
  return(extracted_dataset)

  close(progress_bar)
}

