<!-- badges: start -->
[![R-CMD-check](https://github.com/AgrDataSci/agera5/workflows/R-CMD-check/badge.svg)](https://github.com/AgrDataSci/agera5/actions)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](code_of_conduct.md)
 <!-- badges: end -->

# agera5

## Toolbox for downloading and extracting data from the Copernicus AgERA5 dataset

## Description

The R package *agera5* is a toolbox to download and extract data from the "Agrometeorological indicators from 1979 to present derived from reanalysis" dataset (AgERA5).

<https://cds.climate.copernicus.eu/cdsapp#!/dataset/10.24381/cds.6c68c9bb?tab=overview>

The download function provides programmatic access to the Copernicus Climate Data Store to download AgERA5 data.

## Data license

The agera5 package does not distribute data, it only provides access to Climate Data Store through the python cdsapi.

For specific details about the license agreenment on downloading and using the data please check the license at: <https://cds.climate.copernicus.eu/api/v2/terms/static/licence-to-use-copernicus-products.pdf>

### Installation

``` r
devtools::install_github("agrdatasci/agera5", build_vignettes = TRUE)
```

### Downloading AgERA5 data

#### csdapi setup

To download AgERA5 data you should first install the Climate Data Store API. Please follow the instructions in: <https://cds.climate.copernicus.eu/api-how-to>

#### Examples

#### Downloading data

The following example downloads daily '2m_temperature' data for year 2015

``` r
ag5_download(variable = "2m_temperature",
             statistic = "night_time_minimum",
             day = "all",
             month = "all",
             year = 2015,
             path = "C:/custom_target_folder"
             )
```

#### Extracting data

To extract maximum day temperature ("Max-Day-Time") of "2m_temperature"

``` r
ag5_extract(coords = c(35.726364, -2.197162), 
            dates = "1995-01-23", 
            variable = "2m_temperature",
            statistic = "Max-Day-Time", 
            path = "C:/agera5_data")
```

## Acknowledgements

The *agera5* package relies on the functionality available from other open source packages.

-   The Python [*cdsapi*](https://pypi.org/project/cdsapi/)

-   The R package [*reticulate*](https://cran.r-project.org/web/packages/reticulate/index.html) is used to access the Python cdsapi functions from R.

-   The R package [*terra*](https://cran.r-project.org/web/packages/terra/index.html) is used to extract data from nc files.

-   The R package [*fs*](https://cran.r-project.org/web/packages/fs/index.html) is used for efficiently search and list files.

### Disclaimer

Please be aware that is still a development version of the package. You are free to use it for your own purposes with no warranty.


