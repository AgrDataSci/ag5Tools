#'Extract precipitation data for one location and one date
#'@param .date a date or character representing the date of the data point to be extracted
#'@param .lon numeric Longitude for the point of interest
#'@param .lat numeric Latitude for the point of interest
#'@param .agera5_folder Folder in the local system where the AgERA5 data is stored.
#'@return numeric
#'
#'@export
get_prec_dp <- function(.date,
                                .lon,
                                .lat,
                                .agera5_folder){

  file_path <- get_file_path.prec(.date,
                                 .agera5_folder)

  agera5_spat_rast <- terra::rast(file_path)

  data_out <- terra::extract(x = agera5_spat_rast, y = cbind(.lon, .lat), factors = F)

  return(data_out[1])
}


#'Extract precipitation data for one location and one time series
#'@param .start_date Date or character to be coerced as Date The starting date for the period to extract
#'@param .end_date Date or character to be coerced as Date The end date for the period to extract
#'@param .lon numeric Longitude for the point of interest
#'@param .lat numeric Latitude for the point of interest
#'@param .agera5_folder Folder in the local system where the AgERA5 data is stored.
#'@return numeric vector with precipitation values

#'@export
get_prec_ts <- function(.start_date,
                            .end_date,
                            .lon,
                            .lat,
                            .agera5_folder){

  start_date <- as.Date(.start_date)#, format = "%m/%d/%Y")
  end_date <- as.Date(.end_date)#, format = "%m/%d/%Y")

  time_span <- seq.Date(from = .start_date, to = .end_date, by = "days")

  data_out_ts <- vector(mode = "numeric", length = length(time_span))

  nc_files_list <- vapply(X = time_span,
                          FUN.VALUE = vector(mode = "character", length = 1),
                          function(X) get_file_path.prec(.date_to_search = X,
                                                         .agera5_folder = .agera5_folder))

  prec_stack <- terra::rast(nc_files_list)

  data_out_ts <- terra::extract(prec_stack, cbind(.lon, .lat),)

  names(data_out_ts) <- as.character(time_span)

  return(data_out_ts)
}



#'Extract precipitation data for a dataset
#'@param .trial_dataset data.frame with columns required
#'@param .start_date character Name of the column in the dataset
#'@param .end_date character Name of the column in the dataset
#'@param .lon chracter Name of the column in the dataset
#'@param .lat chracter Name of the column in the dataset
#'@param .agera5_folder Folder in the local system where the agera5 data is stored.
#'@return a list of numeric vectors with requested precipation values
#'@export
get_prec_ds <- function(.trial_dataset = NULL,
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
    output_list[[i]] <- get_prec_ts(.trial_dataset[i, .start_date],
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




