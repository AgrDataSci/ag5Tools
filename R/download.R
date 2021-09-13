#' Downloads "Agrometeorological indicators from 1979 to present derived from reanalysis" data using the cdsapi
#' Data is downloaded from Copernicus Climate Change Service (C3) under de license terms
#' stated in the license terms documentation:
#' https://cds.climate.copernicus.eu/api/v2/terms/static/licence-to-use-copernicus-products.pdf
#' We only provide a programmatic bridge between R code and the cdsapi to facilitate R users the access to
#' AgeERA5 data.
#' This code is open source without the kind of warranty.

#' @name download_agera5
#' @param variable Requested variable, e.g. 2m Land Surface Temperature
#' @param statistic Requested statistic for the requested variable, e.g.
#' @param day Day of the week for the requested data. NULL will download all days from requested month
#' @param month Month to be requested. NULL will dowload all the months for the requested year.
#' @param year Year to download. Should be between 1979 - 2020
#'
#' @import reticulate


#' @export

download_agera5 <- function(agera5_var, agera5_stat = NULL, day = NULL, month = NULL, year, path){

  c <- cdsapi$Client()

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

  output_date <- paste0(year,
                       month,
                       day)

  file_name <-paste("agera5",
                    agera5_var,
                    agera5_stat,
                    output_date,
                    sep = "_")

  #add base path
  file_name_path <- paste0(path,
                          file_name)

  #add zip extension
  file_name_path <- paste0(file_name_path, ".zip")

  return(results$download(file_name_path))

}


