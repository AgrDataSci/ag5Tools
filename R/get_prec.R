#'This set of functions extract precipitation data from locally stored AgERA5 data
#'@name get_prec
#'

#'@param .date a date or character representing the date of the data point to be extracted
#'@param .lon numeric Longitude for the point of interest
#'@param .lat numeric Latitude for the point of interest
#'@param .agera5_folder Folder in the local system where the agera5 data is stored. Usually the root folder will work as the function will
#'search recursively
#'

get_prec <- function(...){

  UseMethod("get_prec")

}


#'
#'@export
get_prec.data_point <- function(.date,
                                .lon,
                                .lat,
                                .agera5_folder){

  file_path <- get_file_path(.date,
                                 .agera5_folder)

  agera5_spat_rast <- terra::rast(file_path)

  data_out <- terra::extract(x = agera5_spat_rast, y = cbind(.lon, .lat), factors = F)

  return(data_out[1])
}

#'@describeIn get_prec Get precipitation data for one location for a provided time period
#'@param .start_date Date or character to be coerced as Date The starting date for the period to extract
#'@param .end_date Date or character to be coerced as Date The end date for the period to extract
#'

#@export
# get_prec.period <- function(.start_date,
#                             .end_date,
#                             .lon,
#                             .lat,
#                             .agera5_folder){
#
#   start_date <- as.Date(.start_date)#, format = "%m/%d/%Y")
#   end_date <- as.Date(.end_date)#, format = "%m/%d/%Y")
#
#   time_span <- seq.Date(from = .start_date, to = .end_date, by = "days")
#
#   data_out_period <- vector(mode = "numeric", length = length(time_span))
#
#   for(i in 1:length(time_span)){
#     data_out_period[i] <- get_prec.data_point(time_span[i], .lon, .lat, .agera5_folder)
#   }
#   names(data_out_period) <- as.character(time_span)
#
#   return(data_out_period)
# }

#'
#'@export
get_prec.time_series <- function(.start_date,
                            .end_date,
                            .lon,
                            .lat,
                            .agera5_folder){

  start_date <- as.Date(.start_date)#, format = "%m/%d/%Y")
  end_date <- as.Date(.end_date)#, format = "%m/%d/%Y")

  time_span <- seq.Date(from = .start_date, to = .end_date, by = "days")

  data_out_period <- vector(mode = "numeric", length = length(time_span))

  # nc_files_list <- vapply(X = time_span,
  #                         FUN.VALUE = vector(mode = "character", length = 1),
  #                         function(X) get_prec_file_path(.date_to_search = X,
  #                                                        .agera5_folder = .agera5_folder))

  nc_files_list <- get_prec_file_path(time_span,
                                      .agera5_folder)

  prec_stack <- terra::rast(nc_files_list)

  data_out_period <- terra::extract(prec_stack, cbind(.lon, .lat),)

  names(data_out_period) <- as.character(time_span)

  return(data_out_period)
}


#'@describeIn get_prec Iterates across a data set to extract all required data points

#'@export
get_prec.dataset <- function(.trial_dataset = NULL,
                             .start_date = "pdate",
                             .end_date = "hdate",
                             .lon = "lon",
                             .lat = "lat",
                             .agera5_folder){

  #initialize output variable
  output_list <- vector(mode = "list", length = nrow(.trial_dataset))

  #set progress bar
  progress_bar <- txtProgressBar(min = 0, max = nrow(.trial_dataset), style = 3)

  #loop to get the data
  for(i in 1:nrow(.trial_dataset)){
    output_list[[i]] <- get_prec.time_series(.trial_dataset[i, .start_date],
                                              .trial_dataset[i, .end_date],
                                              .lon = .trial_dataset[i, .lon],
                                              .lat = .trial_dataset[i, .lat],
                                              .agera5_folder)
    Sys.sleep(0.1)
    setTxtProgressBar(progress_bar, i)

  }

  return(output_list)
  close(progress_bar)

}




