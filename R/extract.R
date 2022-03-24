#'Extract AgERA5 data stored in a local hardrive
#'
#'@description Extract data from AgERA5 data files previously downloaded from the Copernicus Climate Data Store.
#' These functions use package 'terra' to read *.nc files and extract the requested data for a given location
#' and dates. If dates is one value it extracts a single observation for the specified variable and location.
#' If dates is a character vector of \code{length == 2}, it will extract a time series of the specified variable
#' and location, where the first dates value is the start date and the second the end date.

#'@name ag5_extract
#'@param coords numeric vector of length = 2 of the form (lon, lat), or a \code{data.frame} with required columns
#'@param variable \code{character} The AgERA5 variable to extract, see details for available options
#'@param statistic \code{character} Only for some variables, see details for valid options
#'@param dates \code{character} The dates for extracting the specified variable, a vector of length 1 extracts a single date, while
#'a vector of length 2 indicates the start and end dates.
#'or the column name in the case of \code{data.frame}
#'@param lon \code{character} Column name of longitude values in the case of \code{data.frame}
#'@param lat \code{character} Column name of latitude values in the case of \code{data.frame}
#'@param start_date \code{character} Column name of start_date values in the case that coords is a \code{data.frame}
#'@param end_date \code{character} Column name of end_date values in the case that coords is a \code{data.frame}
#'@param time Only for variable Relative-Humidity-2m, see details for valid options
#'@param path \code{character} The path for the folder containing the AgERA5 files
#'@param celsius logical Only for variables "Temperature-Air-2m" and "2m_dewpoint_temperature".
#'If \code{TRUE} the values are converted from Kelvin to Celsius. Default is \code{FALSE}
#'@param ... Other parameters
#'
#'@details
#'# Valid variable values
#'\itemize{
#'\item "cloud_cover"
#'\item "liquid_precipitation_duration_fraction"
#'\item "snow_thickness_lwe"
#'\item "Solar-Radiation-Flux"
#'\item "Temperature-Air-2m"
#'\item "2m_dewpoint_temperature"
#'\item "Precipitation-Flux"
#'\item "solid_precipitation_duration_fraction"
#'\item "snow_thickness"
#'\item "vapour_pressure"
#'\item "10m_wind_speed"
#'\item "Relative-Humidity-2m"
#'}
#'
#'# Valid statistics for variable "Temperature-Air-2m"
#'\itemize{
#'\item Max-24h
#'\item Mean-24h
#'\item 24_hour_minimum
#'\item Max-Day-Time
#'\item Mean-Day-Time
#'\item Mean-Night-Time
#'\item Min-Night-Time}
#'
#'# Variables that require statistic
#'For the following variables, only "24_hour_mean" statistic is available,
#'but should be explicitly indicated.
#'\itemize{
#'\item cloud_cover
#'\item snow_thickness_lwe
#'\item 2m_dewpoint_temperature
#'\item snow_thickness
#'\item vapour_pressure
#'\item 10m_wind_speed

#'}
#'
#'#  Valid time values for variable "Relative-Humidity-2m"
#'\itemize{
#' \item 06h
#' \item 09h
#' \item 12h
#' \item 15h
#' \item 18h
#'}
#'
#'@return  \code{numeric} vector with length equal to the number of dates between first and
#'second date. The returned vecter is a named vector, with requested dates as names.
#'If only one date is provided the function returns a \code{numeric} vector
#'with \code{length = 1}.
#' If \code{coords} is a \code{data.frame}, the function returns a \code{list} of
#'  \code{numeric} vectors, each one corresponding to the rows in the input \code{data.frame}
#'
#'
#'@examples
#'\dontrun{
#'temp <- ag5_extract(coords = c(lon = 35.72636, lat = -2.197162),
#'                       dates = "1991-04-22",
#'                       variable = "Temperature-Air-2m",
#'                       statistic = "Max-Day-Time",
#'                       path = "C:/temperature_data/")
#'}
#'
#'@references
#'Temperature conversion is made accordingly to:
#'Preston-Thomas, H. (1990). The International Temperature Scale of 1990 (ITS-90).
#' Metrologia, 27(1), 3-10. doi:10.1088/0026-1394/27/1/002




#'@importFrom terra extract
#'@importFrom utils txtProgressBar setTxtProgressBar
#'@export
#'
ag5_extract <- function(coords, ..., path){

  UseMethod("ag5_extract")

}


#'@rdname ag5_extract
#'@export

ag5_extract.numeric <- function(coords,
                                dates,
                                variable,
                                statistic = NULL,
                                time = NULL,
                                celsius = FALSE,
                                ...,
                                path){






  if(isFALSE(check_var(variable)))
    stop("not valid variable, please check")

  if(check_vars_with_stat(variable) && is.null(statistic)){

    stop("statistic is requried and not provided for requested variable")

  }

  if(variable == "Relative-Humidity-2m" && is.null(time)){
    stop("time is required for variable Relative-Humidity-2m")
  }

  if(length(dates) == 2){

    time_span <- seq.Date(from = as.Date(dates[1]),
                          to = as.Date(dates[2]),
                          by = "days")

    data_out_period <- vector(mode = "numeric",
                              length = length(time_span))

    nc_files_list <- vapply(X = time_span,
                            FUN.VALUE = vector(mode = "character", length = 1),
                            function(X) get_file_path(date_to_search = X,
                                                      variable,
                                                      statistic,
                                                      time,
                                                      path))

    nc_stack <- terra::rast(nc_files_list)

    ag5_data <- terra::extract(nc_stack, cbind(coords[1], coords[2]))

    names(ag5_data) <- time_span

  }

  if(length(dates) == 1){

    nc_files_list <-  get_file_path(date_to_search = dates,
                                    variable,
                                    statistic,
                                    time,
                                    path)

    nc_stack <- terra::rast(nc_files_list)

    ag5_data <- terra::extract(nc_stack, cbind(coords[1], coords[2]))

    names(ag5_data) <- dates

  }

  if(variable == "Temperature-Air-2m" && isTRUE(celsius)){
    ag5_data <- ag5_data - 273.15
  }

   return(ag5_data)
}


#'@rdname ag5_extract
#'@method ag5_extract data.frame
#'@export

ag5_extract.data.frame <- function(coords,
                                   lon = "lon",
                                   lat = "lat",
                                   start_date = "start_date",
                                   end_date = "end_date",
                                   variable,
                                   statistic = NULL,
                                   time = NULL,
                                   celsius = FALSE,
                                   ...,
                                   path){



  if(isFALSE(check_var(variable)))
    stop("not valid variable, please check")

  if(variable == "Temperature-Air-2m" && is.null(statistic)){

    stop("statistic not provided for variable Temperature-Air-2m")

  }

  if(variable == "Relative-Humidity-2m" && is.null(time)){
    stop("time is required for variable Relative-Humidity-2m")
  }

  ag5_data_list <- vector(mode = "list", length = nrow(coords))

  #set progress bar
  progress_bar <- txtProgressBar(min = 0,
                                 max = length(ag5_data_list),
                                 style = 3)

  for(i in seq_along(ag5_data_list)){

    ag5_data_list [[i]] <- ag5_extract(coords = c(coords[i, lon],
                                                  coords[i, lat]),
                                       dates = c(coords[i, start_date],
                                                 coords[i, end_date]),
                                       variable = variable,
                                       statistic = statistic,
                                       time = time,
                                       celsius = celsius,
                                       path = path)
    Sys.sleep(0.1)

    setTxtProgressBar(progress_bar, i)
  }

close(progress_bar)

return(ag5_data_list)

}



