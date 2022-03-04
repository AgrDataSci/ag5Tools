#' Extracts 2m_temperature
#'
#' extracts temperature values of the variable 2m_temperature
#' from locally stored AgERA5 files

#'
#'@details
#'\strong{valid .statistic values}
#'\itemize{
#'   \item Max-24h
#'   \item Mean-24h
#'   \item 24_hour_minimum
#'   \item Max-Day-Time
#'   \item Mean-Day-Time
#'   \item Mean-Night-Time
#'   \item Min-Night-Time}


#'@name get_temp.data_point
#'@param .date Date or character representing the date of the point data to be extracted
#'@param .lon  numeric with longitude and latitude
#'@param .lat numeric data.frame or an object to be coerced, with longitude and latitude
#'@param .statistic character of the .statistic of interest, see details
#'@param .agera5_folder character of the .statistic of interest, see details
#'

#'@export
get_temp.data_point <- function(.date,
                                .lon,
                                .lat,
                                .statistic,
                                .agera5_folder){

  file_path <- get_file_path.temp(.date_to_search = .date,
                                  .variable = "2m_temperature",
                                  .statistic = .statistic,
                                  .agera5_folder = .agera5_folder)

  agera5_spat_rast <- terra::rast(file_path)

  data_out <- terra::extract(x = agera5_spat_rast, y = cbind(.lon, .lat), factors = F)

  data_out <- data_out[1] - 273.15

  return(data_out)

}


#'@name get_temp.time_series
#'@param .start_date Date or character representing the date of the point data to be extracted
#'@param .lon  numeric with longitude and latitude
#'@param .lat numeric data.frame or an object to be coerced, with longitude and latitude
#'@param .statistic character of the .statistic of interest, see details
#'@param .agera5_folder character of the .statistic of interest, see details

#'@export
get_temp.time_series <- function(.start_date,
                                 .end_date,
                                 .lon,
                                 .lat,
                                 .statistic,
                                 .agera5_folder){

  .start_date <- as.Date(.start_date)

  .end_date <- as.Date(.end_date)


  time_span <- seq.Date(from = .start_date, to = .end_date, by = "days")

  data_out_period <- vector(mode = "numeric", length = length(time_span))



  nc_files_list <- vapply(X = time_span,
                          FUN.VALUE = vector(mode = "character", length = 1),
                          FUN = function(X){
                            get_file_path.temp(.date_to_search = X,
                                          .variable = "2m_temperature",
                                          .statistic = .statistic,
                                          .agera5_folder = .agera5_folder)})

  temp_stack <- terra::rast(nc_files_list)

  data_out_period <- terra::extract(temp_stack, cbind(.lon, .lat))

  names(data_out_period) <- as.character(time_span)

  return(data_out_period)
}


#'@name get_temp.dataset
#'Iterates across a data set to extract all required data points
#'@param .trial_dataset \code{data.frame} containing the required variables, usually from the trial data points
#'@param .start_date character Name of the column that holds the start date of the time period to extract
#'@param .end_date character Name of the column that holds the end date of the time period to extract
#'@param .lon character Name of the column that holds the longitude
#'@param .lat character Name of the column that holds the latitude
#'@param .statistic character Name of the statistic to extract, see details for valid options
#'@param .agera5_folder character Location of data folder that contains AgERA5 files

#'@export
get_temp.dataset <- function(.trial_dataset,
                             .statistic,
                             .start_date = "pdate",
                             .end_date = "hdate",
                             .lon = "lon",
                             .lat = "lat",
                             .agera5_folder){

  output_list <- vector(mode = "list", length = nrow(.trial_dataset))

  progress_bar <- txtProgressBar(min = 0, max = nrow(.trial_dataset), style = 3)

  for(i in 1:nrow(.trial_dataset)){
    output_list[[i]] <- get_temp.time_series(.start_date = .trial_dataset[i, .start_date],
                                             .end_date =  .trial_dataset[i, .end_date],
                                             .lon = .trial_dataset[i, .lon],
                                             .lat = .trial_dataset[i, .lat],
                                             .statistic = .statistic,
                                             .agera5_folder = .agera5_folder)

    Sys.sleep(0.1)
    setTxtProgressBar(progress_bar, i)

}
  return(output_list)

  close(progress_bar)

}




# get_file_path <- function(.variable, .statistic, .date_to_search, .agera5_folder){
#
#   var_to_search <- .variable
#
#   #temp_prefix <- paste0("Temperature-Air-2m-", get_stat_code(.statistic), "_C3S-glob-agric_AgERA5_daily_")
#
#   temp_prefix <- paste0("Temperature-Air-2m-", .statistic, "_C3S-glob-agric_AgERA5_")
#
#   date_pattern <- gsub("-", "", .date_to_search)
#
#   agera5_file_pattern <- paste0(temp_prefix, date_pattern)
#
#   #print(paste("searching for: ", agera5_file_pattern))
#
#   # target_file_path <- list.files(path = .agera5_folder,
#   #                                pattern = agera5_file_pattern,
#   #                                full.names = TRUE,
#   #                                recursive = TRUE)
#
#   target_file_path <- as.character(sapply(agera5_file_pattern,
#                                           function(X){
#                                             fs::dir_ls(path = .agera5_folder,
#                                                        regexp = X,
#                                                        recurse = TRUE)
#                                           }
#   ))
#
#
#   if(is.null(target_file_path))
#     print("File not found")
#
#   # year_to_search <- format(.date_to_search, "%Y")
#   # month_to_search <- format(.date_to_search, "%m")
#   # date_pattern <- paste0(year_to_search, month_to_search)
#   #
#   # agera5_file_pattern <- paste0(temp_prefix, date_pattern)
#   #
#   # files_ <- list.files(paste(.agera5_folder, var_to_search, year_to_search, sep = "/"))
#   # file_name <- files_[stringr::str_detect(files_, agera5_file_pattern)]
#   # agera5_file_path <- paste(.agera5_folder, var_to_search, year_to_search, file_name, sep="/")
#
#   #return(agera5_file_path)
#
#   return(target_file_path)
#
# }


