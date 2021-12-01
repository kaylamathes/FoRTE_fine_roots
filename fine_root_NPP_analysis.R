###########################################################
####FoRTE Fine root Data Analysis
####2019-2020
####Kayla C. Mathes  
###########################################################

#Load Libraries
library(googledrive)
library(dplyr)
library(rstatix)
library(car)



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


######Adjust root mass for ash free weight 

###Create percent root column (measured as percent decrease from burn samples). Calculated as percent decrease, that decrease is the all roots that burned in muffle furnace, what is left is inorganic material. Then create a Rep column 
burn_mass_2020 <- burn_mass_2020%>%
  mutate(percent_root = (pre_burn_g_12hr - post_burn_g_12hr)/pre_burn_g_12hr*100)%>%
  mutate(Rep = case_when(Subplot_ID == "A01W" | Subplot_ID == "A02W" | Subplot_ID == "A04W" ~ "A", 
                        Subplot_ID == "B01W" |  Subplot_ID == "B03E" | Subplot_ID == "B03W" ~ "B", 
                         Subplot_ID == "C01W" | Subplot_ID == "C04E" | Subplot_ID == "C04W" ~ "C", 
                        Subplot_ID == "D01W" | Subplot_ID == "D02E" | Subplot_ID == "D02W" ~ "D"))

####Test whether or not there is a replicate difference in amount of inorganic material 

##Test Model assumptions 

##Test for outliers test: no outliers 
burn_mass_2020 %>% 
  group_by(Rep) %>%
  identify_outliers(percent_root)

##Equality of variance test for replicates: variances are equal 
leveneTest(percent_root ~ Rep, data = burn_mass_2020)

##Normality (Data are normal)
# Build the linear model
normality_test  <- lm(percent_root ~ Rep,
                      data = burn_mass_2020)

# Shapiro test of normality: normal with alpha of 0.01
shapiro_test(residuals(normality_test))

##No statistical difference between percent root material across replicates 
burn_anova <- aov(percent_root ~ Rep, data = burn_mass_2020)
summary(burn_anova)




  
  
