% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extract.R
\name{ag5_extract}
\alias{ag5_extract}
\alias{ag5_extract.default}
\alias{ag5_extract.data.frame}
\title{Extract AgERA5 data stored in a local hardrive}
\usage{
ag5_extract(lon, lat, dates, variable, ..., path)

\method{ag5_extract}{default}(lon, lat, dates, variable, ..., path)

\method{ag5_extract}{data.frame}(dataset, variable, ..., path)
}
\arguments{
\item{lon}{The longitude value for the location of interest}

\item{lat}{The latitude value for the location of interest}

\item{dates}{The dates for extracting the specified variable, either single character or a vector of length 2}

\item{variable}{The AgERA5 variable to extract, see details for available options}

\item{path}{The path for the folder containing the AgERA5 files}

\item{statistic}{character See details for variables that require to indicate the statistic}
}
\description{
ag5_extract is a family of wrapper functions to extract data from AgERA5 data files
previously downloaded from the Copernicus Climate Data Store. These functions use package \emph{terra} to
read *.nc files and extract the requested data for a given location and dates. If dates is one value
it extracts a single observation for the specified variable and location. If dates is a character vector
of \code{length == 2}, it will extract a time series of the specified variable and location, where the first
dates value is the start date and the second the end date.
}
\section{Valid variable values to be used in W4D52drhwjjYIYnOEstCkaQoyLxgUR2G-1-}{
\itemize{
\item Temperature-Air-2m
\item Precipitation-Flux
\item Solar-Radiation-Flux
\item Relative-Humidity-2m
}
}

\section{Valid statistics for variable "Temperature-Air-2m"}{
\itemize{
\item Max-24h
\item Mean-24h
\item 24_hour_minimum
\item Max-Day-Time
\item Mean-Day-Time
\item Mean-Night-Time
\item Min-Night-Time}
}

\examples{
\dontrun{
2m_temp <- ag5_extract(lon = 35.72636,
                      lat = -2.197162,
                      dates = "1991-04-22",
                      variable = "Temperature-Air-2m",
                      statistic = "Max-Day-Time",
                      path "C:/temperature_data/")
}


}