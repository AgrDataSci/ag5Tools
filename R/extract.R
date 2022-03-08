#'Extract AgERA5 data stored in a local hardrive
#'
#'@description ag5_extract is a family of wrapper functions to extract data from AgERA5 data files
#'previously downloaded from the Copernicus Climate Data Store. These functions use package 'terra' to
#'read *.nc files and extract the requested data for a given location and dates. If dates is one value
#'it extracts a single observation for the specified variable and location. If dates is a character vector
#'of \code{length == 2}, it will extract a time series of the specified variable and location, where the first
#'dates value is the start date and the second the end date.

#'@name ag5_extract
#'@param variable The AgERA5 variable to extract, see details for available options
#'@param statistic character Only for variable Temperature-Air-2m, see details for valid options
#'@param coords numeric Vector of length = 2 of the form (lon, lat)
#'@param dates The dates for extracting the specified variable, either single character or a vector of length 2
#'or the column name in the case of \code{data.frame}
#'@param lon character Column name of longitude values in the case of \code{data.frame}
#'@param lat character Column name of latitude values in the case of \code{data.frame}
#'@param start_date Column name of start_date values in the case of \code{data.frame}
#'@param end_date Column name of end_date values in the case of \code{data.frame}
#'@param time Only for variable Relative-Humidity-2m, see details for valid options
#'@param path The path for the folder containing the AgERA5 files
#'
#'@details # Valid variable values
#'\itemize{
#'\item Temperature-Air-2m
#'\item Precipitation-Flux
#'\item Solar-Radiation-Flux
#'\item Relative-Humidity-2m
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
#'#  Valid time values for variable "Relative-Humidity-2m"
#'\itemize{
#' \item 06h
#' \item 09h
#' \item 12h
#' \item 15h
#' \item 18h
#'}
#'
#'
#'@examples
#'\dontrun{
#'2m_temp <- ag5_extract(lon = 35.72636,
#'                       lat = -2.197162,
#'                       dates = "1991-04-22",
#'                       variable = "Temperature-Air-2m",
#'                       statistic = "Max-Day-Time",
#'                       path "C:/temperature_data/")
#'}
#'

#'
#'@importFrom terra extract
#'@export
#'
ag5_extract <- function(variable, ..., path){

  UseMethod("ag5_extract")

}


#'@rdname ag5_extract
#'@export

ag5_extract.numeric <- function(coords, dates, variable, ..., path){

  args <- list(...)

  statistic <- args[["statistic"]]

  if(!variable %in% valid_variables)
    stop("not valid variable, please check")

  if(variable == "Temperature-Air-2m"){
    if(is.null(statistic))
      stop("statistic not provided for variable Temperature-Air-2m")
      else{
        message("temperature")

      }
  }
  if(variable == "Relative-Humidity-2m"){
    if(is.null(time))
      stop("time is required for variable Relative-Humidity-2m")
    else
      message("humidity")
  }

  x <- paste0(lon, lat, variable, list(...), path)




   return(x)
}


#'@rdname ag5_extract
#'@method ag5_extract data.frame
#'@export

ag5_extract.data.frame <- function(dataset,
                                   lon = "lon",
                                   lat = "lat",
                                   start_date = "start_date",
                                   end_date = "end_date",
                                   variable,
                                   ...,
                                   path){

  x <- dataset$lon

  return(x)
}

valid_variables <- c("Temperature-Air-2m",
                     "Precipitation-Flux",
                     "Solar-Radiation-Flux",
                     "Relative-Humidity-2m")

