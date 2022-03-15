
cdsapi <- NULL


.onLoad <- function(libname, pkgname) {

  reticulate::configure_environment(pkgname)

  cdsapi <<- reticulate::import("cdsapi", delay_load = TRUE)
}
