######################################
#Code to extract AgERA5 data from locally stored files
#
#
#David Brown - WUR - ABC
#Created 2020-05-08
#
######################################
library(raster)
library(dplyr)
library(tidyr)
library(stringr)


#Function to extract each variable data for one location for one date
agera5_srf_extract <- function(.date, 
                               .location_xy, 
                               .agera5_folder){
  
  file_path <- get_srf_filepath(.date, .agera5_folder)
  
  agera5_brick <- brick(file_path)
  
  data_out <- raster::extract(agera5_brick, .location_xy)
  
  date_to_extract <- gsub(x = .date, pattern = "-", replacement = ".")
  date_to_extract <- paste0("X", date_to_extract)
  extracted_data <- data_out[1, date_to_extract]
  
  return(extracted_data)
}


extract_srf_period <- function(.start_date, 
                               .end_date, 
                               .location_xy, 
                               .agera5_folder){
  
  .start_date <- as.Date(.start_date, format = "%m/%d/%Y")
  .end_date <- as.Date(.end_date,format = "%m/%d/%Y")
  time_span <- seq.Date(from = .start_date, to = .end_date, by = "days")
  data_out_period <- array(dim=c(1, length(time_span)))
  
  for(i in 1:length(time_span)){
    data_out_period[, i] <- agera5_srf_extract(time_span[i], .location_xy, .agera5_folder)
  }
  colnames(data_out_period) <- as.character(time_span)
  
  return(data_out_period)
}

get_srf_filepath <- function(.date_to_search, .agera5_folder){
  
  date_to_search <- as.Date(.date_to_search)
 
  prec_prefix <- "Solar-Radiation-Flux_C3S-glob-agric_AgERA5_daily_"
  prec_sufix <- "_final-v1.0.nc"
  
  year_to_search <- format(date_to_search, "%Y")
  
  month_to_search <- format(date_to_search, "%m")
  
  date_pattern <- paste0(year_to_search, month_to_search)
  
  agera5_file_pattern <- paste0(prec_prefix, date_pattern)
  
  files_ <- list.files(paste(.agera5_folder, "srf", year_to_search, sep = "/"))
  #print(date_pattern)
  #print("__________________________")
  #print(agera5_file_pattern)
  #print("__________________________")
 # print(files_)
  file_name <- files_[str_detect(files_, agera5_file_pattern)]
  #print(file_name)
  agera5_file_path <- paste(.agera5_folder, "srf", year_to_search, file_name, sep = "/")  
  #print(agera5_file_path)
  
  return(agera5_file_path)
}

extract_srf_dataset <- function(trial_dataset, .agera5_folder){
  extracted_dataset <- NULL
  progress_bar <- txtProgressBar(min = 0, max = nrow(trial_dataset), style = 3)
  
  for(i in 1:nrow(trial_dataset)){
    extracted_dataset[[i]] <- extract_srf_period(trial_dataset[i, ]$pdate,
                                             trial_dataset[i, ]$hdate,
                                             data.frame(lon = trial_dataset[i, ]$lon, lat=trial_dataset[i, ]$lat),
                                             .agera5_folder)
    
    Sys.sleep(0.1)
    setTxtProgressBar(progress_bar, i)
    
  }
  return(extracted_dataset)
  close(progress_bar)
}




