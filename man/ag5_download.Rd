% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download.R
\name{ag5_download}
\alias{ag5_download}
\title{Downloads AgERA5 data from the Copernicus Climate Change Service - Copernicus Climate Data Store}
\usage{
ag5_download(variable, statistic = NULL, day, month, year, time = NULL, path)
}
\arguments{
\item{variable}{character The variable to be downloaded. See details}

\item{statistic}{character Requested statistic for the selected variable. See details}

\item{day}{character Day of the week for the requested data. \.code{day = "all"}  will download all days from requested month}

\item{month}{character Month to be requested. \.code{month = "all"} will download all the months for the requested year.}

\item{year}{numeric (Integer) Year to download. Should be between 1979 - 2020}

\item{time}{Character Only required for some variables. See details}

\item{path}{Character Target folder in an local hardrive e.g. "C:/agera5". The folder should exist beforehand and the path should be indicated without the ending "/"}
}
\description{
The data is downloaded from Copernicus Climate Change Service (C3) using the
Copernicus Climate Data Store (CDSAPI) Python library
\url{https://github.com/ecmwf/cdsapi}
}
\details{
This function  provides programmatic access to the dataset
For more information about the data license, please visit:
https://cds.climate.copernicus.eu/api/v2/terms/static/licence-to-use-copernicus-products.pdf

To download the data you should have a valid CDS account and CDS API key

\strong{Allowed combinations of variable and statistic:}
\itemize{
\item cloud_cover
\itemize{24_hour_mean}
\itemize{
\item 24_hour_mean}
\item precipitation_flux
\item solar_radiation_flux
\item 2m_temperature
\itemize{
\item 24_hour_maximum
\item 24_hour_mean
\item 24_hour_minimum
\item day_time_maximum
\item day_time_mean
\item night_time_mean
\item night_time_minimum}
\item 2m_relative_humidity
\itemize{
\item 06_00
\item 09_00
\item 12_00
\item 15_00
\item 18_00}
}
}
\examples{
\dontrun{
ag5_download(variable = "2m_temperature",
            statistic = "night_time_minimum",
            'day = "all",
            'month = "all",
            'year = 2015,
            'path = "C:/custom_target_folder/"
            )
            }

}