#'Extract data from locally stored AgERA5 data
#'@title agera5_extract
#'
#'
#'@description
#'Extracts data from locally stored AgERA5 data for a given location
#'and time period.
#'
#'@details
#'Available temperature statistics
#'Max-24h
#'Max-Day-Time
#'Mean-24h
#'Mean-Day-Time
#'Mean-Night-Time
#'Min-24h
#'Min-Night-Time
#'
#'
#'
#'@param agera5_folder a string with the path for the local data of AgERA5
#'
#'@param .date
#'Format dd-mm-YYYY
#'
#'@param .location_xy
#'Data frame with columns (lon, lat)
#'
#'@param .var
#'temp
#'prec
#'rel_hum
#'
#'
#'
#'
#'
#'@references
#'https://cds.climate.copernicus.eu/cdsapp#!/dataset/sis-agrometeorological-indicators?tab=overview
#'
#'
#'
#'
#'

#"holds the path for the local AgERA5 data folder"
#agera5_folder<-""

#'set AgERA5 data folder
#'example "F:/environmental_data/AgERA5"
set_agera5_source<-function(.folder_path){
  agera5_folder<-.folder_path
}


#'

#'extracts data for a given location and date
extract_single_date<-function(.date,.location_xy,.var,.statistic){
  file_path<-get_filepath(.var,.statistic,.date)
  agera5_brick<-raster::brick(file_path)
  data_out<-raster::extract(agera5_brick,.location_xy)
  date_to_extract<-gsub(x=.date,pattern = "-",replacement = ".")
  date_to_extract<-paste0("X",date_to_extract)
  extracted_data<-data_out[1,date_to_extract]
  return(extracted_data)
}

#'extracts data for a given location and time period
extract_period<-function(.start_date,.end_date,.location_xy,.var,.statistic){
  time_span<-seq.Date(from = .start_date,to = .end_date, by = "days")
  data_out_period<-array(dim=c(1,length(time_span)))
  for(i in 1:length(time_span)){
    data_out_period[,i]<-extract_single_date(time_span[i],.location_xy,.var,.statistic)
  }
  colnames(data_out_period)<-as.character(time_span)
#273.15 is the conversion factor for Kelvin to degree Celsius
#"Treese SA (2018) Historical Temperature. In:  History and Measurement of the Base and Derived Units.
#Springer International Publishing, Cham, pp 837-864. doi:10.1007/978-3-319-77577-7_9"
  data_out_period<-data_out_period-273.15
  return(data_out_period)
}


#get the the file path to extract data
get_filepath<-function(.var,.statistic,.date_to_search){
  # Available temperature statistics
  #Max-24h
  #Max-Day-Time
  #Mean-24h
  #Mean-Day-Time
  #Mean-Night-Time
  #Min-24h
  #Min-Night-Time
  if(.statistic==1)stat_code<-"Max-24h"
  if(.statistic==2)stat_code<-"Max-Day-Time"
  if(.statistic==3)stat_code<-"Mean-24h"
  if(.statistic==4)stat_code<-"Mean-Day-Time"
  if(.statistic==5)stat_code<-"Mean-Night-Time"
  if(.statistic==6)stat_code<-"Min-24h"
  if(.statistic==7)stat_code<-"Min-Night-Time"

  var_to_search<-.var

  temp_prefix<-paste0("Temperature-Air-2m-",stat_code,"_C3S-glob-agric_AgERA5_daily_")

  year_to_search<-format(.date_to_search, "%Y")

  month_to_search<-format(.date_to_search, "%m")

  date_pattern <- paste0(year_to_search,month_to_search)

  agera5_file_pattern<-paste0(temp_prefix,date_pattern)

  files_<-list.files(paste(agera5_folder,var_to_search,year_to_search,sep = "/"))
  print(date_pattern)
  print("__________________________")
  print(agera5_file_pattern)
  print("__________________________")
  print(files_)

 file_name<-files_[str_detect(files_,agera5_file_pattern)]
  print(file_name)
 agera5_file_path<-paste(agera5_folder,var_to_search,year_to_search,file_name,sep="/")
 print(agera5_file_path)
 return(agera5_file_path)
}

