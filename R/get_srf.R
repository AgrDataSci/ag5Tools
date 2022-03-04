#'Extracts solar radiation flux data from locally stored AgERA5 data





#'@name get_srf.data_point
#'@param .date a date or character representing the date of the point data to be extracted
#'@param .lon character longitude
#'@param .lat character latitude
#'@param .agera5_folder character The location the of the folder with agera5 (*.nc) files
#'@export
get_srf.data_point <- function(.date,
                               .lon,
                               .lat,
                               .agera5_folder){

  file_path <- get_srf_filepath(.date,
                                .agera5_folder)

  agera5_spat_rast <- terra::rast(file_path)

  data_out <- terra::extract(x = agera5_spat_rast, y = cbind(.lon, .lat), factors = F)

  return(data_out[1])
}


#'@name get_srf.time_series
#'get_srf Get solar radiation flux data for one location for a provided time period

#'@export
get_srf.time_series <- function(.start_date,
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


#'@name get_srf.dataset
#' Iterates across a dataset to extract all required data points

#'@export
get_srf.dataset <- function(.trial_dataset,
                            .start_date = "pdate",
                            .end_date = "hdate",
                            .lon = "lon",
                            .lat = "lat",
                            .agera5_folder){

  output_list <- vector(mode = "list", length = nrow(.trial_dataset))

  progress_bar <- txtProgressBar(min = 0, max = nrow(.trial_dataset), style = 3)

  for(i in 1:nrow(.trial_dataset)){

    output_list[[i]] <- get_srf.time_series(.start_date = .trial_dataset[i, .start_date],
                                             .end_date = .trial_dataset[i, .end_date],
                                             .lon = .trial_dataset[i, .lon],
                                             .lat = .trial_dataset[i, .lat],
                                             .agera5_folder)

    Sys.sleep(0.1)
    setTxtProgressBar(progress_bar, i)

  }
  return(output_list)
  close(progress_bar)
}


#internal function to get the file path
get_srf_filepath <- function(.date_to_search, .agera5_folder){

  date_pattern <- gsub("-", "", .date_to_search)

  file_prefix <- "Solar-Radiation-Flux_C3S-glob-agric_AgERA5_"



  agera5_file_pattern <- paste0(file_prefix, date_pattern)

  # target_file_path <- list.files(path = .agera5_folder,
  #                                pattern = agera5_file_pattern,
  #                                full.names = TRUE,
  #                                recursive = TRUE)

  target_file_path <- vector(mode = "character", length = length(.date_to_search))

  target_file_path <- as.character(sapply(agera5_file_pattern,
                                          function(X){
                                            fs::dir_ls(path = .agera5_folder,
                                                       regexp = X,
                                                       recurse = TRUE)
                                          }
  ))




  return(target_file_path)
  ################################# OLD code


  # date_to_search <- as.Date(.date_to_search)
  #
  # prec_prefix <- "Solar-Radiation-Flux_C3S-glob-agric_AgERA5_daily_"
  # prec_sufix <- "_final-v1.0.nc"
  #
  # year_to_search <- format(date_to_search, "%Y")
  #
  # month_to_search <- format(date_to_search, "%m")
  #
  # date_pattern <- paste0(year_to_search, month_to_search)
  #
  # agera5_file_pattern <- paste0(prec_prefix, date_pattern)
  #
  # files_ <- list.files(paste(.agera5_folder, "srf", year_to_search, sep = "/"))
  #
  # file_name <- files_[stringr::str_detect(files_, agera5_file_pattern)]
  #
  # agera5_file_path <- paste(.agera5_folder, "srf", year_to_search, file_name, sep = "/")
  #
  #
  # return(agera5_file_path)
}







