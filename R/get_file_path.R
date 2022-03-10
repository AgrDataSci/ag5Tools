#internal function to get the file path

get_file_path <- function(date_to_search, variable, statistic, time, path){

  vars_with_stat <- c("Temperature-Air-2m")

  if(variable %in% vars_with_stat){
    prefix <- paste(variable, statistic, sep = "-")

    prefix <- paste0(prefix, "_C3S-glob-agric_AgERA5_")
  }

  if(variable == "Relative-Humidity-2m"){
    prefix <- paste(variable, time, sep = "-")

    prefix <- paste0(prefix, "_C3S-glob-agric_AgERA5_")
  }
  else{
    prefix <- paste0(variable, "_C3S-glob-agric_AgERA5_")

  }

  date_pattern <- gsub("-", "", date_to_search)

  file_pattern <- paste0(prefix, date_pattern)

  target_file_path <- fs::dir_ls(path = path,
                                 regexp = file_pattern,
                                 recurse = TRUE)

  if(length(target_file_path) == 0)
    stop("File not found")


  return(target_file_path)

}

