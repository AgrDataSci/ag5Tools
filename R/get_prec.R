#'This set of functions extract precipitation data from locally stored AgERA5 data
#'@name get_prec

#'@param .date a date or character representing the date of the point data to be extracted
#'@param .location_xy a data.frame or an object to be coerced, with longitude and latitude
#'@param .var a character of the variable of interest
#'@param .statistic an integer for the statistic to extract, options are:
#'




#'@export
agera5_prec_extract <- function(.date,
                                .location_xy,
                                .agera5_folder){

  file_path <- get_prec_filepath(.date,
                                 .agera5_folder)

  #agera5_brick <- raster::brick(file_path)

  agera5_spat_rast <- terra::rast(file_path)

  #agera5_brick <- raster::brick("D:/Dropbox (Bioversity CR)/dbrown_files/AgERA5/prec/2015/Precipitation-Flux_C3S-glob-agric_AgERA5_daily_20150101-20150131_final-v1.0.nc")
  #data_out <- raster::extract(agera5_brick, .location_xy)
  data_out <- terra::extract(agera5_spat_rast, .location_xy, factors = F)


  # date_to_extract <- gsub(x = .date, pattern = "-", replacement = ".")
  # date_to_extract <- paste0("X", date_to_extract)

  day_to_extract <- lubridate::day(.date)
  extracted_data <- data_out[1, paste0("Precipitation_Flux_", day_to_extract)]

  return(extracted_data)
}

#'@export
extract_prec_period <- function(.start_date,
                                .end_date,
                                .location_xy,
                                .agera5_folder){

  start_date <- as.Date(.start_date, format = "%m/%d/%Y")
  end_date <- as.Date(.end_date, format = "%m/%d/%Y")
  time_span <- seq.Date(from = .start_date, to = .end_date, by = "days")
  data_out_period <- array(dim = c(1, length(time_span)))

  for(i in 1:length(time_span)){
    data_out_period[, i] <- agera5_prec_extract(time_span[i], .location_xy, .agera5_folder)
  }
  colnames(data_out_period) <- as.character(time_span)

  return(data_out_period)
}

get_prec_filepath <- function(.date_to_search, .agera5_folder){

  date_to_search <- as.Date(.date_to_search)
  prec_prefix <- "Precipitation-Flux_C3S-glob-agric_AgERA5_daily_"
  prec_sufix <- "_final-v1.0.nc"
  year_to_search <- format(date_to_search, "%Y")
  month_to_search <- format(date_to_search, "%m")
  date_pattern <- paste0(year_to_search, month_to_search)
  agera5_file_pattern <- paste0(prec_prefix, date_pattern)

  files_ <- list.files(paste(.agera5_folder, "prec", year_to_search, sep = "/"))
  file_name <- files_[stringr::str_detect(files_, agera5_file_pattern)]
  agera5_file_path <- paste(.agera5_folder, "prec", year_to_search, file_name, sep="/")


  return(agera5_file_path)
}

#'@export
extract_prec_dataset <- function(.trial_dataset, .agera5_folder){

  #initialize output variable
  extracted_dataset <- NULL

  #set progress bar
  progress_bar <- txtProgressBar(min = 0, max = nrow(.trial_dataset), style = 3)

  #loop to get the data
  for(i in 1:nrow(.trial_dataset)){
    extracted_dataset[[i]] <- extract_prec_period(.trial_dataset[i, ]$pdate,
                                                  .trial_dataset[i, ]$hdate,
                                                  data.frame(lon = .trial_dataset[i, ]$lon,
                                                             lat = .trial_dataset[i, ]$lat),
                                                  .agera5_folder)
    Sys.sleep(0.1)
    setTxtProgressBar(progress_bar, i)

  }

  return(extracted_dataset)
  close(progress_bar)

}




