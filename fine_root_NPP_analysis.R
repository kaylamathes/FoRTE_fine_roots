###########################################################
####FoRTE Fine root Data Analysis
####2019-2020
####Kayla C. Mathes  
###########################################################

#Load Libraries
library(googledrive)
library(dplyr)



######Download fine root data for 2019 and 2020 from Google Drive####

# Direct Google Drive link to "FoRTE/data/soil_respiration/2021"
as_id("https://drive.google.com/drive/folders/1371-N8yQh0XsMOHWKEdTjEazYB4Syn2V") %>% 
  drive_ls ->
  gdfiles

# Create a new data directory for files, if necessary
data_dir <- "googledrive_data/"
if(!dir.exists(data_dir)) dir.create(data_dir)

#Download date
for(f in seq_len(nrow(gdfiles))) {
  cat(f, "/", nrow(gdfiles), " Downloading ", gdfiles$name[f], "...\n", sep = "")
  drive_download(gdfiles[f,], overwrite = TRUE, path = file.path(data_dir, gdfiles$name[f]))
}

## Import downloaded date from new data directory "googledrive_data"
root_mass_2020 <- read.csv("googledrive_data/in_growth_soil_core_2020.csv", na.strings = c("NA", "na"))
burn_mass_2020 <- read.csv("googledrive_data/Burn_mass_2020.csv", na.strings = c("NA","na"))
