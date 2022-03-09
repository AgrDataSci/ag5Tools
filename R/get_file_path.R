#internal function to get the file path

# variable = "Relative-Humidity-2m"
# statistic = NULL
# path = "F:/env/AgERA5/"
# date_to_search <- arusha_df$start_date[1]
# prefix<- NULL
# time = NULL

#get file path
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

  date_pattern <- gsub("-", "", date_to_search)

  file_pattern <- paste0(prefix, date_pattern)

  target_file_path <- fs::dir_ls(path = path,
                                 regexp = file_pattern,
                                 recurse = TRUE)




    # as.character(sapply(file_pattern,
    #                                       function(X){
    #                                         fs::dir_ls(path = path,
    #                                                    regexp = X,
    #                                                    recurse = TRUE)
    #                                       }))


  if(target_file_path == "character(0)")
    message("File not found")



  return(target_file_path)

}




























#get file path for precipitation data
get_file_path.prec <- function(.date_to_search, .agera5_folder){

  date_pattern <- gsub("-", "", .date_to_search)

  file_prefix <- "Precipitation-Flux_C3S-glob-agric_AgERA5_"

  agera5_file_pattern <- paste0(file_prefix, date_pattern)

  target_file_path <- vector(mode = "character", length = length(.date_to_search))

  target_file_path <- as.character(sapply(agera5_file_pattern,
                                          function(X){
                                            fs::dir_ls(path = .agera5_folder,
                                                       regexp = X,
                                                       recurse = TRUE)
                                          }
  ))

  return(target_file_path)

}


#get file path for relative humidity data
get_file_path.rhum <- function(.date_to_search, .time, .agera5_folder){

  # try(if(!.time %in% c("06h", "09h", "12h", "15h", "18h")){
  #   stop(".time variable is not valid")
  # })

  date_pattern <- gsub("-", "", .date_to_search)

  file_prefix <- paste0("Relative-Humidity-2m-", .time, "_C3S-glob-agric_AgERA5_")

  agera5_file_pattern <- paste0(file_prefix, date_pattern)

  target_file_path <- vector(mode = "character", length = length(.date_to_search))

  target_file_path <- as.character(sapply(agera5_file_pattern,
                                          function(X){
                                            fs::dir_ls(path = .agera5_folder,
                                                       regexp = X,
                                                       recurse = TRUE)
                                          }
  ))

  return(target_file_path)

}


#get file path for temperature data
get_file_path.temp <- function(.date_to_search, .statistic, .agera5_folder){

  #temp_prefix <- paste0("Temperature-Air-2m-", get_stat_code(.statistic), "_C3S-glob-agric_AgERA5_daily_")

  temp_prefix <- paste0("Temperature-Air-2m-", .statistic, "_C3S-glob-agric_AgERA5_")

  date_pattern <- gsub("-", "", .date_to_search)

  agera5_file_pattern <- paste0(temp_prefix, date_pattern)

  #print(paste("searching for: ", agera5_file_pattern))

  # target_file_path <- list.files(path = .agera5_folder,
  #                                pattern = agera5_file_pattern,
  #                                full.names = TRUE,
  #                                recursive = TRUE)

  target_file_path <- as.character(sapply(agera5_file_pattern,
                                          function(X){
                                            fs::dir_ls(path = .agera5_folder,
                                                       regexp = X,
                                                       recurse = TRUE)
                                          }
  ))


  if(is.null(target_file_path))
    print("File not found")

  # year_to_search <- format(.date_to_search, "%Y")
  # month_to_search <- format(.date_to_search, "%m")
  # date_pattern <- paste0(year_to_search, month_to_search)
  #
  # agera5_file_pattern <- paste0(temp_prefix, date_pattern)
  #
  # files_ <- list.files(paste(.agera5_folder, var_to_search, year_to_search, sep = "/"))
  # file_name <- files_[stringr::str_detect(files_, agera5_file_pattern)]
  # agera5_file_path <- paste(.agera5_folder, var_to_search, year_to_search, file_name, sep="/")

  #return(agera5_file_path)

  return(target_file_path)

}








