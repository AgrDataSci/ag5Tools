# ag5Tools

## Get the CDS API-Key

To download AgERA5 data from the Copernicus Climate Data Store (CDS) you
should first register and get your API Key from the [CDS API
Guide](https://cds.climate.copernicus.eu/api-how-to).

Once you have your API Key, you should create a file named “.cdsapirc”.
See more details at the [CDS API
Guide](https://cds.climate.copernicus.eu/api-how-to)

You do not need to install Python or the ‘CDASPI’ client, ag5Tools will
do it if required.

## Downloading AgERA5 data

The following example downloads variable “2m_temperature”. For this
variable there are seven statistics available:

- 24_hour_maximum

- 24_hour_mean

- 24_hour_minimum

- day_time_maximum

- day_time_mean

- night_time_mean

- night_time_minimum

In this case, we will download “night_time_minimum”. You should replace
the target path to a location in your own computer where you want to
store the downloaded data.

``` r
library(ag5Tools)

ag5_download(variable = "2m_temperature",
            statistic = "night_time_minimum",
            day = "all",
            month = "all",
            year = 2015,
            path = "C:/custom_target_folder")
```
