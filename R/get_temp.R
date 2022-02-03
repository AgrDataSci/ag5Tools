#' Extract temperature values from locally stored AgERA5 data
#'@name get_temp


#'@param .date a date or character representing the date of the point data to be extracted
#'@param .location_xy a data.frame or an object to be coerced, with longitude and latitude
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
#'@param .trial_dataset Data containing the required parameters, usually the trial data points
#'@param .start_date Character Name of the column that holds the start date of the time period to extract
#'@param .end_date Character Name of the column that holds the end date of the time period to extract
#'@param .lon Character Name of the column that holds the longitude
#'@param .lat Character Name of the column that holds the latitude
#'@param .agera5_folder a character with agera5 data folder location
#'
#'
#'@details
#'\strong{valid .statistic values}
#'\itemize{
#'   \item 24_hour_maximum
#'   \item 24_hour_mean
#'   \item 24_hour_minimum
#'   \item day_time_maximum
#'   \item day_time_mean
#'   \item night_time_mean
#'   \item night_time_minimum}

#@describeIn get_temp Get temperature data for one location using terra package

#'@export
get_temp.data_point <- function(.date,
                                .lon,
                                .lat,
                                .var,
                                .statistic,
                                .agera5_folder){

  file_path <- get_file_path(.var, .statistic, .date, .agera5_folder)

  agera5_spat_rast <- terra::rast(file_path)

  data_out <- terra::extract(x = agera5_spat_rast, y = cbind(.lon, .lat), factors = F)

  data_out <- data_out[1] - 273.15

  return(data_out)

}


#'@describeIn get_temp Get temperature data for one location for a provided time period

#'@export
get_temp.period <- function(.start_date,
                            .end_date,
                            .lon,
                            .lat,
                            .var,
                            .statistic,
                            .agera5_folder){

  .start_date <- as.Date(.start_date)#, format = "%m/%d/%Y")
  #print(.start_date)

  .end_date <- as.Date(.end_date)#, format = "%m/%d/%Y")
  #print(.end_date)

  time_span <- seq.Date(from = .start_date, to = .end_date, by = "days")

  data_out_period <- vector(mode = "numeric", length = length(time_span))

  # nc_files_list <- vapply(X = time_span,
  #                         FUN.VALUE = vector(mode = "character", length = 1),
  #                         function(X) get_file_path(.var = .var,
  #                                                   .statistic = .statistic,
  #                                                   .date = X,
  #                                                   .agera5_folder = .agera5_folder))

  nc_files_list <- get_file_path(.var = .var,
                                 .statistic = .statistic,
                                 .date = time_span,
                                 .agera5_folder = .agera5_folder)

  temp_stack <- terra::rast(nc_files_list)

  data_out_period <- terra::extract(temp_stack, cbind(.lon, .lat))

  names(data_out_period) <- as.character(time_span)

  return(data_out_period)
}


#'@describeIn get_temp Iterates across a data set to extract all required data points

#'@export
get_temp.dataset <- function(.trial_dataset = NULL,
                             .stat = NULL,
                             .start_date = "pdate",
                             .end_date = "hdate",
                             .lon = "lon",
                             .lat = "lat",
                             .agera5_folder){

  output_list <- vector(mode = "list", length = nrow(.trial_dataset))

  progress_bar <- txtProgressBar(min = 0, max = nrow(.trial_dataset), style = 3)

  for(i in 1:nrow(.trial_dataset)){
    output_list[[i]] <- get_temp.period(.start_date = .trial_dataset[i, .start_date],
                                              .end_date =  .trial_dataset[i, .end_date],
                                              .lon = .trial_dataset[i, .lon],
                                              .lat = .trial_dataset[i, .lat],
                                              .var = "temp",
                                              .statistic = .stat,
                                              .agera5_folder = .agera5_folder)

    Sys.sleep(0.1)
    setTxtProgressBar(progress_bar, i)

}
  return(output_list)

  close(progress_bar)

}




get_file_path <- function(.var, .statistic, .date_to_search, .agera5_folder){

  var_to_search <- .var

  #temp_prefix <- paste0("Temperature-Air-2m-", get_stat_code(.statistic), "_C3S-glob-agric_AgERA5_daily_")

  temp_prefix <- paste0("Temperature-Air-2m-", get_stat_code(.statistic), "_C3S-glob-agric_AgERA5_")

  date_pattern <- gsub("-", "", .date_to_search)

  agera5_file_pattern <- paste0(temp_prefix, date_pattern)

  #print(paste("searching for: ", agera5_file_pattern))

  # target_file_path <- list.files(path = .agera5_folder,
  #                                pattern = agera5_file_pattern,
  #                                full.names = TRUE,
  #                                recursive = TRUE)

  target_file_path <- as.character(sapply(agera5_file_pattern,
                                          function(X){
                                            fs::dir_ls(path = .agera5_folder,
                                                       regexp = X,
                                                       recurse = TRUE)
                                          }
  ))


  if(is.null(target_file_path))
    print("File not found")

  # year_to_search <- format(.date_to_search, "%Y")
  # month_to_search <- format(.date_to_search, "%m")
  # date_pattern <- paste0(year_to_search, month_to_search)
  #
  # agera5_file_pattern <- paste0(temp_prefix, date_pattern)
  #
  # files_ <- list.files(paste(.agera5_folder, var_to_search, year_to_search, sep = "/"))
  # file_name <- files_[stringr::str_detect(files_, agera5_file_pattern)]
  # agera5_file_path <- paste(.agera5_folder, var_to_search, year_to_search, file_name, sep="/")

  #return(agera5_file_path)

  return(target_file_path)

}


