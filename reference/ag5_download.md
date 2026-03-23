# Downloads AgERA5 data from the Copernicus Climate Change Service - Copernicus Climate Data Store

The data is downloaded from Copernicus Climate Change Service (C3S)
using the Copernicus Climate Data Store (CDSAPI) Python library
<https://github.com/ecmwf/cdsapi>

This function provides programmatic access to the AgERA5 dataset. For
more information about the data license, please visit:
<https://cds.climate.copernicus.eu/api/v2/terms/static/licence-to-use-copernicus-products.pdf>

To download the data you should have a valid CDS account, an CDS API
key. Please follow the instructions at:
<https://cds.climate.copernicus.eu/api-how-to> to create a file to store
your API key. You do not need to install Python or the cdsapi, Ag5Tools
will do it if required.

## Usage

``` r
ag5_download(
  variable,
  statistic = NULL,
  year,
  month,
  day,
  time = NULL,
  version = "1_1",
  path,
  area = NULL
)
```

## Arguments

- variable:

  character The variable to be downloaded. See details

- statistic:

  character Only required for some variables. See details for options.

- year:

  numeric (Integer) Year to download. Should be between 1979 - 2022

- month:

  numeric Month to be requested. Use `month = "all"` download all the
  months for the requested year.

- day:

  numeric Days of the month for the requested data. Use `day = "all"` to
  download all days from requested month

- time:

  Character Only required for "2m_relative_humidity".

- version:

  Character Version 1_1 is currently the default and recommended See
  details for available options.

- path:

  Character Target folder in an local hardrive e.g. "C:/agera5". The
  folder should exist and the user should have write permission.

- area:

  A numeric vector of length = 4 Values represent geographic coordinates
  for the area of interest in this order (north, west, south, east). If
  NULL it will download the whole available region.

## Value

No return value, called for side effects.

## AgERA5 variables available for download:

- cloud_cover

- liquid_precipitation_duration_fraction

- snow_thickness_lwe

- solar_radiation_flux

- 2m_temperature

- 2m_dewpoint_temperature

- precipitation_flux

- solid_precipitation_duration_fraction

- snow_thickness

- vapour_pressure

- 10m_wind_speed

- 2m_relative_humidity

## Statistics for variable "2m_temperature"

Variable "2m_temperature" requires to indicate at least one of the
following options in `statistic`:

- 24_hour_maximum

- 24_hour_mean

- 24_hour_minimum

- day_time_maximum

- day_time_mean

- night_time_mean

- night_time_minimum

## Parameter "time" for Variable "2m_relative_humidity"

Variable "2m_relative_humidity" requires to indicate one of the
following options in `time`:

- 06_00

- 09_00

- 12_00

- 15_00

- 18_00

## Variables that require statistic

For the following variables, only "24_hour_mean" statistic is available,
but should be explicitly indicated.

- cloud_cover

- snow_thickness_lwe

- 2m_dewpoint_temperature

- snow_thickness

- vapour_pressure

- 10m_wind_speed

## Examples

``` r
if (FALSE) { # \dontrun{
ag5_download(variable = "2m_temperature",
            statistic = "night_time_minimum",
            day = "all",
            month = "all",
            year = 2015,
            path = "C:/custom_target_folder"
            )
            } # }
```
