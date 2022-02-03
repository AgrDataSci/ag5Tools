#'Downloads AgERA5 data from the Copernicus Climate Change Service
#'
#'The data is downloaded from Copernicus Climate Change Service (C3) using the cdsapi python library
#'https://github.com/ecmwf/cdsapi
#'This function  provides programmatic access to the dataset
#'For more information about the data license, please visit:
#'https://cds.climate.copernicus.eu/api/v2/terms/static/licence-to-use-copernicus-products.pdf



#'@name download_agera5
#'@param agera5_var Character The variable to be downloaded. See details
#'@param agera5_stat Character Requested statistic for the requested variable. See details
#'@param day Character Day of the week for the requested data. NULL will download all days from requested month
#'@param month Character Month to be requested. NULL will download all the months for the requested year.
#'@param year Numeric (Integer) Year to download. Should be between 1979 - 2020
#'@param path Character Target location e.g. "C:/agera5" without the ending "/"
#'@param unzip Logical Downloaded data is provided as zip files. Should the files be uncompressed in the target path?
#'@param time Character
#'
#'@import reticulate

#'@details
#'\strong{Allowed combinations of variable and statistic:}
#'\itemize{
#'   \item cloud_cover
#'   \itemize{
#'   \item 24_hour_mean}
#'   \item precipitation_flux
#'   \item solar_radiation_flux
#'   \item 2m_temperature
#'   \itemize{
#'   \item 24_hour_maximum
#'   \item 24_hour_mean
#'   \item 24_hour_minimum
#'   \item day_time_maximum
#'   \item day_time_mean
#'   \item night_time_mean
#'   \item night_time_minimum}
#'   \item 2m relative humidity
#'   \itemize{
#'   \item 06_00
#'   \item 09_00
#'   \item 12_00
#'   \item 15_00
#'   \item 18_00}
#' }
#'
#'
#'@examples
#'download_agera5(agera5_var = '2m_temperature',
#'agera5_stat = 'night_time_minimum',
#'day = NULL,
#'month = NULL,
#'year = 2015,
#'path = "C:/custom_target_folder/"
#')

#'@export
download_agera5 <- function(agera5_var,
                            agera5_stat = NULL,
                            day = NULL,
                            month = NULL,
                            year,
                            path #, unzip_files = TRUE
                            ){

  c <- cdsapi$Client()

  if(is.null(day) || day == "all")
    day <- formatC(x = seq(1:31), width = 2, flag = 0)

  if(is.null(month) || month == "all")
    month <- formatC(x = seq(1:12), width = 2, flag = 0)


  # if(lenght(year) > 1){
  #
  #
  # }


  results <- c$retrieve('sis-agrometeorological-indicators',
                        list(
                          "variable" = agera5_var,
                          "statistic" = agera5_stat,
                          "year" = as.integer(year),
                          "month" = month,
                          "day" = day#,
                          #CA countries bounding box - Disabled for the moment as it will increase the number of
                          #requests to the server - TODO: make optional later with a warning message.
                          # "area": [5.499027 ,-90.12486,  17.41847, -81.99986],
                        )
  )

  #expand.grid(year, month, day)

  # output_date <- paste0(year,
  #                      month,
  #                      day)
  #
  # ifelse(output_date > 1,
  #        output_date <- paste(output_date[1], output_date[length(output_date)], sep = "-"),
  #                             output_date <- output_date)

#
#   if(is.null(agera5_stat))
#     file_name <-paste("agera5",
#                       agera5_var,
#                       output_date,
#                       sep = "_")
#
#   if(!is.null(agera5_stat))
#     file_name <-paste("agera5",
#                       agera5_var,
#                       agera5_stat,
#                       output_date,
#                       sep = "_")

  #add base path
  # file_name_path <- paste(path,
  #                         file_name,
  #                         sep = "/")
  file_name_path <- paste(path,
                          "agera5_download",
                          sep = "/")


  #add zip extension
  file_name_path <- paste0(file_name_path, ".zip")

  if(!dir.exists(path)){
    dir.create(path)
  }

  results$download(file_name_path)

  #if(unzip_files == TRUE){
    print(paste("unzipping: ", file_name_path, " to: ", path))
    unzip(zipfile = file_name_path, exdir = path)
    file.remove(file_name_path)
  #}




  print("Download process completed")
  #return()


}


