#'Downloads AgERA5 data from the Copernicus Climate Change Service - Copernicus Climate Data Store
#'
#'The data is downloaded from Copernicus Climate Change Service (C3) using the
#'Copernicus Climate Data Store (CDSAPI) Python library
#'<https://github.com/ecmwf/cdsapi>
#'
#'This function  provides programmatic access to the dataset
#'For more information about the data license, please visit:
#'https://cds.climate.copernicus.eu/api/v2/terms/static/licence-to-use-copernicus-products.pdf
#'
#'To download the data you should have a valid CDS account and CDS API key



#'@name agera5_download
#'@param agera5_var character The variable to be downloaded. See details
#'@param agera5_stat character Requested statistic for the selected variable. See details
#'@param day character Day of the week for the requested data. \.code{day = "all"}  will download all days from requested month
#'@param month character Month to be requested. \.code{month = "all"} will download all the months for the requested year.
#'@param year numeric (Integer) Year to download. Should be between 1979 - 2020
#'@param time Character Only required for some variables. See details
#'@param path Character Target folder in an local hardrive e.g. "C:/agera5". The folder should exist beforehand and the path should be indicated without the ending "/"
#'@param unzip Logical Downloaded data is provided as zip files. Should the files be uncompressed in the target path?
#'
#'@import reticulate

#'@details
#'\strong{Allowed combinations of variable and statistic:}
#'\itemize{
#'   \item cloud_cover
#'   \itemize{24_hour_mean}
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
#'   \item 2m_relative_humidity
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
#'\dontrun{
#'agera5_download(agera5_var = "2m_temperature",
#'                agera5_stat = "night_time_minimum",
#'                'day = "all",
#'                'month = "all",
#'                'year = 2015,
#'                'path = "C:/custom_target_folder/"
#'                ')
#'                '}
#'
#for multiple years and months
#months_list <- formatC(x = seq(1:12), width = 2, flag = 0)
#
# years_list <- 1991:1994
#
# #download precipitation data
# for(i in seq_along(years_list)){
#   for(j in months_list){
#     agera5:::download_agera5(agera5_var = "precipitation_flux",
#                              day = "all",
#                              month = j,
#                              year = years_list[i],
#                              path = paste0("D:/Dropbox (Bioversity CR)/env_data/agera5/prec/new/",
#                                            years_list[i]))
#   }
# }
#'

#'@export
agera5_download <- function(agera5_var,
                            agera5_stat = NULL,
                            day,
                            month,
                            year,
                            time = NULL,
                            path #, unzip_files = TRUE
                            ){

  ifelse(length(day) > 1,
         days <- day, ifelse(day == "all",
                             days <- formatC(x = seq(1:31), width = 2, flag = 0),
                             days <- day))


  ifelse(length(month) > 1,
         months <- month, ifelse(month == "all",
                                 months <- formatC(x = seq(1:12), width = 2, flag = 0),
                                 months <- month))

  if(length(year) > 1 | length(months > 1)){
    years <- year

    for(i in seq_along(years)){
      for(j in months){
        agera5_request(agera5_var = agera5_var,
                       agera5_stat = agera5_stat,
                       day = days,
                       month = j,
                       year = years[i],
                       path = paste0(path,
                                    years[i]))
      }
    }
  }
  else{
    agera5_request(agera5_var = agera5_var,
                   agera5_stat = agera5_stat,
                   day = days,
                   month = months,
                   year = year,
                   path = paste0(path,
                                 year))

  }
}


agera5_request <- function(agera5_var,
                           agera5_stat = NULL,
                           day,
                           month,
                           year,
                           time = NULL,
                           path){

  c <- cdsapi$Client()

  results <- c$retrieve('sis-agrometeorological-indicators',
                        list("variable" = agera5_var,
                             "statistic" = agera5_stat,
                             "year" = as.integer(year),
                             "month" = month,
                             "day" = day,
                             "time" = time
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


