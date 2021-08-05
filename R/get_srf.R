#'This set of functions extract solar radiatio flux data from locally stored AgERA5 data
#'@name get_srf

#'@param .date a date or character representing the date of the point data to be extracted
#'@param .location_xy a data.frame or an object to be coerced, with longitude and latitude
#'@param .var a character of the variable of interest
#'@param .statistic an integer for the statistic to extract, options are:


#'@export
get_srf.data_point <- function(.date,
                               .lon,
                               .lat,
                               .agera5_folder){

  file_path <- get_srf_filepath(.date, .agera5_folder)

  agera5_spat_rast <- terra::rast(file_path)

  data_out <- terra::extract(x = agera5_spat_rast, y = cbind(.lon, .lat), factors = F)

  day_to_extract <- lubridate::day(.date)

  extracted_data <- data_out[1, paste0("Solar-Radiation-Flux_", day_to_extract)]


  # date_to_extract <- gsub(x = .date, pattern = "-", replacement = ".")
  # date_to_extract <- paste0("X", date_to_extract)
  # extracted_data <- data_out[1, date_to_extract]

  return(extracted_data)
}

#'@describeIn get_srf Get solar radiation flux data for one location for a provided time period

#'@export
get_srf.period <- function(.start_date,
                           .end_date,
                           .lon,
                           .lat,
                           .agera5_folder){

  .start_date <- as.Date(.start_date, format = "%m/%d/%Y")
  .end_date <- as.Date(.end_date,format = "%m/%d/%Y")
  time_span <- seq.Date(from = .start_date, to = .end_date, by = "days")

  data_out_period <- vector(mode = "numeric", length = length(time_span))

  for(i in 1:length(time_span)){
    data_out_period[i] <- get_srf.data_point(time_span[i], .lon, .lat, .agera5_folder)
  }
  names(data_out_period) <- as.character(time_span)

  return(data_out_period)
}


#'@describeIn get_srf Iterates across a data set to extract all required data points

#'@export
get_srf.dataset <- function(.trial_dataset = NULL,
                            .start_date = "pdate",
                            .end_date = "hdate",
                            .lon = "lon",
                            .lat = "lat",
                            .agera5_folder){

  output_list <- vector(mode = "list", length = nrow(.trial_dataset))

  progress_bar <- txtProgressBar(min = 0, max = nrow(trial_dataset), style = 3)

  for(i in 1:nrow(trial_dataset)){

    output_list[[i]] <- get_srf.period(.start_date = trial_dataset[i, .start_date],
                                             .end_date = trial_dataset[i, .end_date],
                                             .lon = trial_dataset[i, .lon],
                                             .lat = trial_dataset[i, .lat],
                                             .agera5_folder)

    Sys.sleep(0.1)
    setTxtProgressBar(progress_bar, i)

  }
  return(output_list)
  close(progress_bar)
}


#internal function to get the file path
get_srf_filepath <- function(.date_to_search, .agera5_folder){

  date_to_search <- as.Date(.date_to_search)

  prec_prefix <- "Solar-Radiation-Flux_C3S-glob-agric_AgERA5_daily_"
  prec_sufix <- "_final-v1.0.nc"

  year_to_search <- format(date_to_search, "%Y")

  month_to_search <- format(date_to_search, "%m")

  date_pattern <- paste0(year_to_search, month_to_search)

  agera5_file_pattern <- paste0(prec_prefix, date_pattern)

  files_ <- list.files(paste(.agera5_folder, "srf", year_to_search, sep = "/"))

  file_name <- files_[stringr::str_detect(files_, agera5_file_pattern)]

  agera5_file_path <- paste(.agera5_folder, "srf", year_to_search, file_name, sep = "/")


  return(agera5_file_path)
}







