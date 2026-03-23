# Extracing AgERA5 data with ag5Tools

### Why a extracting function for agERA5 data?

The agERA5 data is downloaded from the Copernicus Climate Data Store as
NetCDF files format, with a file extension `.nc`.

The data is provided as daily observations and each file correspond to a
day. For instance, if you want precipitation data for year 2010, you
will have 365 files (or 366 in the case of a leap year).

In case you want to use the precipitation data as model covariates, you
have to seek for the specific dates and extract the data corresponding
to the locations where the trial was established. Instead, you can use
the ag5_extract function as demostrated in the next section.

Let’s say you have observations from field trials of a trait of interest
(e.g., yield) and want to link that with rainfall data to explore the
effect of rainfall on that trait. You know the the plating and harvest
dates for each trial plot. Then you can extract the time series of daily
rainfall starting at plating date and finishing at harvest date.

Our synthetic example data shows the dates for random locations in
Arusha, Tanzania.

``` r

data("arusha_df", package = "ag5Tools")

head(arusha_df)
#>        lon       lat start_date   end_date
#> 1 35.72636 -2.197162 1991-04-22 1991-08-20
#> 2 36.10249 -2.850983 1990-01-24 1990-05-24
#> 3 35.46292 -3.602582 1991-03-06 1991-07-04
#> 4 36.29166 -3.855945 1990-10-10 1991-02-07
#> 5 35.45254 -3.616361 1990-01-22 1990-05-22
#> 6 35.40131 -3.216106 1990-10-19 1991-02-16
```

With
[`ag5_extract()`](https://agrdatasci.github.io/ag5Tools/reference/ag5_extract.md)
function you can extract the required data, as long as you have
downloaded it already.

``` r

library(ag5Tools)

arusha_rainfall <- ag5_extract(coords = arusha_df,
                               variable = "Precipitation-Flux",
                               path = "D:/agera5_data/")
```

Notice that the `data.frame arusha_df` already has column names that
match the default arguments in the function. If they do not match, you
should indicate the column names as arguments of the function
[`ag5_download()`](https://agrdatasci.github.io/ag5Tools/reference/ag5_download.md).

For example, if your `data.frame` has location columns named `x` and `y`
and dates named as `planting_date` and `harvest_date`, the call to
function
[`ag5_extract()`](https://agrdatasci.github.io/ag5Tools/reference/ag5_extract.md)
will look like:

``` r
arusha_rainfall <- ag5_extract(coords = example_df,
                               lon = "x",
                               lat = "y",
                               start_date = "planting_date",
                               end_date = "harvest_date",
                               variable = "Precipitation-Flux",
                               path = "D:/agera5_data/")
```

Notice that you do not need to worry about providing the specific folder
where the files are located, but only the root folder where you know the
files are. For instance, if you stored all the AgERA5 data files in
folder `D:/agera5_data/`, but you also have sub-folders for
precipitation and temperature data, it is not required to specify that
in the `path` argument. In this case, only providing the path
`D:/agera5_data/` will suffice.
