
cdsapi <- NULL


.onLoad <- function(libname, pkgname) {

  cdsapi <<- reticulate::import("cdsapi", delay_load = TRUE)
}
