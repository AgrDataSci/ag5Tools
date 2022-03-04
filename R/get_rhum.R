#' Extract relative humidity values from locally stored AgERA5 data


#'@details
#'\strong{valid .time values}
#'\itemize{
#'   \item 06h
#'   \item 09h
#'   \item 12h
#'   \item 15h
#'   \item 18h
#'   }



#'@name get_rhum.data_point
#'@param .date a date or character representing the date of the point data to be extracted
#'@param .lon a data.frame or an object to be coerced, with longitude and latitude
#'@param .lat a data.frame or an object to be coerced, with longitude and latitude
#'@param .time a data.frame or an object to be coerced, with longitude and latitude
#'@param .agera5_folder character indicating the folder where agera5 nc files are located
#'
#'@export
get_rhum.data_point <- function(.date,
                                .lon,
                                .lat,
                                .time,
                                .agera5_folder){

  file_path <- get_file_path(.time, .date, .agera5_folder)

  agera5_spat_rast <- terra::rast(file_path)

  data_out <- terra::extract(x = agera5_spat_rast, y = cbind(.lon, .lat), factors = F)

  data_out <- data_out[1]

  return(data_out)

}


#'@name get_rhum.time_series

#'@export
get_rhum.time_series <- function(.start_date,
                            .end_date,
                            .lon,
                            .lat,
                            .time,
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

  nc_files_list <- get_file_path(.date = time_span,
                                 .time = .time,
                                 .agera5_folder = .agera5_folder)

  temp_stack <- terra::rast(nc_files_list)

  data_out_period <- terra::extract(temp_stack, cbind(.lon, .lat))

  names(data_out_period) <- as.character(time_span)

  return(data_out_period)
}


#'@name get_rhum.dataset
#'@param .trial_dataset data.frame containing the required parameters, usually the trial data points
#'@param .start_date character Name of the column that holds the start date of the time period to extract
#'@param .end_date character Name of the column that holds the end date of the time period to extract
#'@param .lon character Name of the column that holds the longitude
#'@param .lat character Name of the column that holds the latitude
#'@param .lat character time of the day from the options available in AgERA5 dataset, see details
#'@param .agera5_folder a character with agera5 data folder location

#'@export
get_rhum.dataset <- function(.trial_dataset = NULL,
                             .start_date = "pdate",
                             .end_date = "hdate",
                             .lon = "lon",
                             .lat = "lat",
                             .time = "time",
                             .agera5_folder){

  output_list <- vector(mode = "list", length = nrow(.trial_dataset))

  progress_bar <- txtProgressBar(min = 0, max = nrow(.trial_dataset), style = 3)

  for(i in 1:nrow(.trial_dataset)){
    output_list[[i]] <- get_rhum.period(.start_date = .trial_dataset[i, .start_date],
                                        .end_date =  .trial_dataset[i, .end_date],
                                        .lon = .trial_dataset[i, .lon],
                                        .lat = .trial_dataset[i, .lat],
                                        .time = .time,
                                        .agera5_folder = .agera5_folder)

    Sys.sleep(0.1)
    setTxtProgressBar(progress_bar, i)

}
  return(output_list)

  close(progress_bar)

}







