
check_var <- function(x){
  valid_variables <- c("cloud_cover",
                       "liquid_precipitation_duration_fraction",
                       "snow_thickness_lwe",
                       "Solar-Radiation-Flux",
                       "Temperature-Air-2m",
                       "2m_dewpoint_temperature",
                       "Precipitation-Flux",
                       "solid_precipitation_duration_fraction",
                       "snow_thickness",
                       "vapour_pressure",
                       "10m_wind_speed",
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
                      "cloud_cover",
                      "snow_thickness_lwe",
                      "2m_dewpoint_temperature",
                      "snow_thickness",
                      "vapour_pressure",
                      "10m_wind_speed")

  if(x %in% vars_with_stat){
    return(TRUE)
  }
  return(FALSE)

}










