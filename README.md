<!-- badges: start -->
[![R-CMD-check](https://github.com/AgrDataSci/ag5Tools/workflows/R-CMD-check/badge.svg)](https://github.com/AgrDataSci/ag5Tools/actions)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](https://agrdatasci.github.io/ag5Tools/CODE_OF_CONDUCT.html)
 <!-- badges: end -->

# ag5Tools

## Toolbox for downloading and extracting data from the Copernicus AgERA5 dataset

## Description

The R package *ag5Tools* is a toolbox to download and extract data from the "Agrometeorological indicators from 1979 to present derived from reanalysis" dataset (AgERA5).

<https://cds.climate.copernicus.eu/cdsapp#!/dataset/10.24381/cds.6c68c9bb?tab=overview>

The download function provides programmatic access to the Copernicus Climate Data Store to download AgERA5 data.

## Data license

The ag5Tools package does not distribute data, it only provides access to Climate Data Store through the python cdsapi.

For specific details about the license agreement on downloading and using the data please check the license at: <https://cds.climate.copernicus.eu/api/v2/terms/static/licence-to-use-copernicus-products.pdf>

### Installation

``` r
devtools::install_github("agrdatasci/ag5Tools", build_vignettes = TRUE)
```

### Downloading AgERA5 data

#### Get your CDS API-Key

To download AgERA5 data you should first register at the Climate Data Store and get your API key. Please follow the instructions in: <https://cds.climate.copernicus.eu/api-how-to>

You only need to create a file to store the API key, following the instructions from: <https://cds.climate.copernicus.eu/api-how-to>. ag5Tools internally handles all the environment setup, including the Python requirements (i.e., install Python and cdsapi).

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

The ag5Tools package relies on the functionality available from other open source packages.

-   The Python [*cdsapi*](https://pypi.org/project/cdsapi/)

-   The R package [*reticulate*](https://cran.r-project.org/package=reticulate) is used to access the Python cdsapi functions from R.

-   The R package [*terra*](https://cran.r-project.org/package=terra) is used to extract data from nc files.

-   The R package [*fs*](https://cran.r-project.org/package=fs) is used for efficiently search and list files.

## License

Please be aware that ag5Tools is released under MIT license, please find details in the [MIT license document](https://agrdatasci.github.io/ag5Tools/LICENSE.html)

## Code of Conduct

Please note that the ag5Tools project is released with a [Contributor Code of Conduct](https://agrdatasci.github.io/ag5Tools/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.

