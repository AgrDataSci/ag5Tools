#'Downloads AgERA5 data from the Copernicus Climate Change Service - Copernicus Climate Data Store
#'
#'@description The data is downloaded from Copernicus Climate Change Service (C3S) using the
#'Copernicus Climate Data Store (CDSAPI) Python library
#'<https://github.com/ecmwf/cdsapi>
#'
#'This function  provides programmatic access to the AgERA5 dataset.
#'For more information about the data license, please visit:
#'<https://cds.climate.copernicus.eu/api/v2/terms/static/licence-to-use-copernicus-products.pdf>
#'
#'To download the data you should have a valid CDS account,
#'an CDS API key. Please follow the instructions at: <https://cds.climate.copernicus.eu/api-how-to>
#'to create a file to store your API key. You do not need to install Python or the cdsapi, Ag5Tools
#'will do it if required.

#'@name ag5_download
#'@param variable character The variable to be downloaded. See details
#'@param statistic character Only required for some variables. See details for options.
#'@param year numeric (Integer) Year to download. Should be between 1979 - 2022
#'@param month numeric Month to be requested. Use \code{month = "all"}  download
#' all the months for the requested year.
#'@param day numeric Days of the month for the requested data.
#' Use \code{day = "all"}  to download all days from requested month
#'@param time Character Only required for "2m_relative_humidity".
#'@param version Character Version 1_1 is currently the default and recommended
#'See details for available options.
#'@param path Character Target folder in an local hardrive e.g. "C:/agera5".
#' The folder should exist and the user should have write permission.
#'
#'@details
#'# AgERA5 variables available for download:
#'\itemize{
#'\item cloud_cover
#'\item liquid_precipitation_duration_fraction
#'\item snow_thickness_lwe
#'\item solar_radiation_flux
#'\item 2m_temperature
#'\item 2m_dewpoint_temperature
#'\item precipitation_flux
#'\item solid_precipitation_duration_fraction
#'\item snow_thickness
#'\item vapour_pressure
#'\item 10m_wind_speed
#'\item 2m_relative_humidity
#'}
#'
#'
#'# Statistics for variable "2m_temperature"
#'Variable "2m_temperature" requires to indicate at least one of the following
#'options in \code{statistic}:
#'\itemize{
#'\item 24_hour_maximum
#'\item 24_hour_mean
#'\item 24_hour_minimum
#'\item day_time_maximum
#'\item day_time_mean
#'\item night_time_mean
#'\item night_time_minimum
#'}
#'
#'# Parameter "time" for Variable "2m_relative_humidity"
#'Variable "2m_relative_humidity" requires to indicate one of the following
#'options in \code{time}:
#'\itemize{
#'\item 06_00
#'\item 09_00
#'\item 12_00
#'\item 15_00
#'\item 18_00
#'}
#'
#'# Variables that require statistic
#'For the following variables, only "24_hour_mean" statistic is available, but should
#'be explicitly indicated.
#'\itemize{
#'\item cloud_cover
#'\item snow_thickness_lwe
#'\item 2m_dewpoint_temperature
#'\item snow_thickness
#'\item vapour_pressure
#'\item 10m_wind_speed

#'}
#'@return No return value, called for side effects.


#'@examples
#'\dontrun{
#'ag5_download(variable = "2m_temperature",
#'             statistic = "night_time_minimum",
#'             day = "all",
#'             month = "all",
#'             year = 2015,
#'             path = "C:/custom_target_folder"
#'             )
#'             }
#'
#'@importFrom utils unzip

#'@export
ag5_download <- function(variable,
                         statistic = NULL,
                         year,
                         month,
                         day,
                         time = NULL,
                         version = "1_1",
                         path){

  if(length(month) == 1 && month == "all"){
    month <- formatC(x = seq(1:12), width = 2, flag = 0)
  }

  if(is.numeric(month)){

    month <- formatC(x = month, width = 2, flag = 0)
  }


  if(length(day) == 1 && day == "all"){
    day <- formatC(x = seq(1:31), width = 2, flag = 0)
  }


  if(is.numeric(day) ){
    day <- formatC(x = day, width = 2, flag = 0)
  }



  if(length(year) > 1 | length(month > 1)){
    years <- year

    for(i in seq_along(years)){
      for(j in month){
        ag5_request(variable = variable,
                    statistic = statistic,
                    day = day,
                    month = j,
                    time = time,
                    year = years[i],
                    version = version,
                    path = paste0(path,
                                  years[i]))
      }
    }
  }
  else{
    ag5_request(variable = variable,
                statistic = statistic,
                day = day,
                month = month,
                time = time,
                year = year,
                version = version,
                path = paste0(path,
                                 year))

  }
}


ag5_request <- function(variable,
                        statistic = NULL,
                        day,
                        month,
                        year,
                        time = NULL,
                        version = version,
                        path){

  c <- cdsapi$Client()


  results <- c$retrieve('sis-agrometeorological-indicators',
                          list("variable" = variable,
                               "year" = as.integer(year),
                               "statistic" = statistic,
                               "month" = month,
                               "day" = day,
                               "time" = time,
                               "version" = version))


  file_name_path <- paste(path,
                          "agera5_download",
                          sep = "/")


  #add zip extension
  file_name_path <- paste0(file_name_path, ".zip")

  if(!dir.exists(path)){
    dir.create(path)
  }

  results$download(file_name_path)

  print(paste("unzipping: ", file_name_path, " to: ", path))

  unzip(zipfile = file_name_path, exdir = path)

  file.remove(file_name_path)

  print("Download process completed")

}


