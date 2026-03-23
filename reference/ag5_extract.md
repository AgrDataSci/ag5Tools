# Extract AgERA5 data stored in a local hard drive

Extract data from AgERA5 data files previously downloaded from the
Copernicus Climate Data Store. These functions use package 'terra' to
read \*.nc files and extract the requested data for a given location and
dates. If dates is one value it extracts a single observation for the
specified variable and location. If dates is a character vector of
`length == 2`, it will extract a time series of the specified variable
and location, where the first dates value is the start date and the
second the end date.

## Usage

``` r
ag5_extract(coords, ..., path)

# S3 method for class 'numeric'
ag5_extract(
  coords,
  dates,
  variable,
  statistic = NULL,
  time = NULL,
  celsius = FALSE,
  parallel = TRUE,
  ...,
  path
)

# S3 method for class 'data.frame'
ag5_extract(
  coords,
  lon = "lon",
  lat = "lat",
  start_date = "start_date",
  end_date = "end_date",
  variable,
  statistic = NULL,
  time = NULL,
  celsius = FALSE,
  ncores = NULL,
  ...,
  path
)
```

## Arguments

- coords:

  numeric vector of length = 2 of the form (lon, lat), or a `data.frame`
  with required columns

- ...:

  Other parameters

- path:

  `character` The path for the folder containing the AgERA5 files

- dates:

  `character` The dates for extracting the specified variable, a vector
  of length 1 extracts a single date, while a vector of length 2
  indicates the start and end dates. or the column name in the case of
  `data.frame`

- variable:

  `character` The AgERA5 variable to extract, see details for available
  options

- statistic:

  `character` Only for some variables, see details for valid options

- time:

  Only for variable Relative-Humidity-2m, see details for valid options

- celsius:

  logical Only for variables "Temperature-Air-2m" and
  "2m_dewpoint_temperature".

- parallel:

  logical Use parallel computation to speed-up data processing

- lon:

  `character` Column name of longitude values in the case of
  `data.frame`

- lat:

  `character` Column name of latitude values in the case of `data.frame`

- start_date:

  `character` Column name of start_date values in the case that coords
  is a `data.frame`

- end_date:

  `character` Column name of end_date values in the case that coords is
  a `data.frame`

- ncores:

  Number of cores to use with parallel. If NULL and parallel is ON, half
  the available cores will be used. If `TRUE` the values are converted
  from Kelvin to Celsius. Default is `FALSE`

## Value

`numeric` vector with length equal to the number of dates between first
and second date. The returned vecter is a named vector, with requested
dates as names. If only one date is provided the function returns a
`numeric` vector with `length = 1`. If `coords` is a `data.frame`, the
function returns a `list` of `numeric` vectors, each one corresponding
to the rows in the input `data.frame`

## Valid variable values

- "Cloud-Cover"

- "Precipitation-Rain-Duration-Fraction"

- "Snow-Thickness-LWE"

- "Solar-Radiation-Flux"

- "Temperature-Air-2m"

- "Dew-Point_Temperature-2m"

- "Precipitation-Flux"

- "Precipitation-Solid-Duration-Fraction"

- "Snow-Thickness"

- "Vapour-Pressure"

- "Wind-Speed-10m"

- "Relative-Humidity-2m"

## Valid statistics for variable "Temperature-Air-2m"

- "Max-24h"

- "Mean-24h"

- "Min-24h"

- "Max-Day-Time"

- "Mean-Day-Time"

- "Mean-Night-Time"

- "Min-Night-Time"

## Variables that require statistic

For the following variables, only 24 hour mean statistic is available,
but should be explicitly indicated as "Mean".

- "Cloud-Cover"

- "Snow-Thickness-LWE"

- "Dew-Point_Temperature-2m"

- "Snow-Thickness"

- "Vapour-Pressure"

- "Wind-Speed-10m"

## Valid time values for variable "Relative-Humidity-2m"

- "06h"

- "09h"

- "12h"

- "15h"

- "18h"

## References

Temperature conversion is made accordingly to: Preston-Thomas, H.
(1990). The International Temperature Scale of 1990 (ITS-90).
Metrologia, 27(1), 3-10. doi:10.1088/0026-1394/27/1/002

## Examples

``` r
if (FALSE) { # \dontrun{
temp <- ag5_extract(coords = c(lon = 35.72636, lat = -2.197162),
                      dates = "1991-04-22",
                      variable = "Temperature-Air-2m",
                      statistic = "Max-Day-Time",
                      path = "C:/temperature_data/")
} # }
```
