## agera5

# *agera5*: A toolbox for downloading and extracting data from the Copernicus AgERA5 dataset


## Description 

The R package *agera5* is a toolbox to download and extract data from the "Agrometeorological indicators from 1979 to present derived from reanalysis" dataset (aka AgERA5).

https://cds.climate.copernicus.eu/cdsapp#!/dataset/10.24381/cds.6c68c9bb?tab=overview

The download function provides programatic access to Copernicus Climate Data Store where AgERA5 dataset is hosted. For specific details about the license agreenment on downloading and using the data please check the dataset license at: 
https://cds.climate.copernicus.eu/api/v2/terms/static/licence-to-use-copernicus-products.pdf

The download functionality is made using the Python cdsapi https://pypi.org/project/cdsapi/.

The extracting functions are wrappers of the R package terra.

### Installation  
``` r
devtools::install_github("agrdatasci/agera5", build_vignettes = TRUE)
```

### Disclaimer
Please be aware that is still a development version of the package. You are free to use it for your own purposes with no warranty.

