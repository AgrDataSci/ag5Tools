## agera5 package

R toolbox to download and extract data from the "Agrometeorological indicators from 1979 to present derived from reanalysis" dataset (aka AgERA5).

https://cds.climate.copernicus.eu/cdsapp#!/dataset/10.24381/cds.6c68c9bb?tab=overview

We only provide a programatic access to the dataset. For specific details about the license agreenment on downloading and using the data please check the dataset license at: 
https://cds.climate.copernicus.eu/api/v2/terms/static/licence-to-use-copernicus-products.pdf

Download functionality is made using the Python cdsapi. Please also consider using it directly.

### Installation  
``` r
devtools::install_github("agrdatasci/agera5", build_vignettes = TRUE)
```

### Disclaimer
Please be aware that is a development version package only intended for internal use in our projects. You are free to use it for
your own purposes with no warranty.

