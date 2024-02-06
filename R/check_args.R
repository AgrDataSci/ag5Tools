
check_var <- function(x){
  valid_variables <- c("Cloud-Cover",
                       "Precipitation-Rain-Duration-Fraction",
                       "Snow-Thickness-LWE",
                       "Solar-Radiation-Flux",
                       "Temperature-Air-2m",
                       "Dew-Point_Temperature-2m",
                       "Precipitation-Flux",
                       "Precipitation-Solid-Duration-Fraction",
                       "Snow-Thickness",
                       "Vapour-Pressure",
                       "Wind-Speed-10m",
                       "Relative-Humidity-2m")

  if(x %in% valid_variables){
    return(TRUE)
  }
  return(FALSE)



}

check_temp_stat <- function(x){
  valid_temp_stats <- c("Max-24h",
                        "Mean-24h",
                        "24_hour_minimum",
                        "Max-Day-Time",
                        "Mean-Day-Time",
                        "Mean-Night-Time",
                        "Min-Night-Time")

  if(x %in% valid_temp_stats){
    return(TRUE)
  }
  return(FALSE)

}

check_time <- function(x){
  valid_times <- c("06h",
                   "09h",
                   "12h",
                   "15h",
                   "18h")

  if(x %in% valid_times){
    return(TRUE)
  }
  return(FALSE)


}

check_temp_vars <- function(x){

  temperature_vars <- c("Temperature-Air-2m",
                        "2m_dewpoint_temperature")

  if(x %in% temperature_vars){
    return(TRUE)
  }
    return(FALSE)

}


check_vars_with_stat <- function(x){

  vars_with_stat <- c("Temperature-Air-2m",
                      "Cloud_Cover",
                      "Snow-Thickness-LWE",
                      "Dew-Point_Temperature-2m",
                      "Snow-Thickness",
                      "Vapour-Pressure",
                      "Wind-Speed-10m")

  if(x %in% vars_with_stat){
    return(TRUE)
  }
  return(FALSE)

}










