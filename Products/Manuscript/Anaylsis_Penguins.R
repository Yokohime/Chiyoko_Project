###############################
# analysis script
#
#this script loads the cleaned data and generated graphs and plots to help visualize
#the data to help anwser questions and saves it as Rds file in the Analysis_Code folder



## ---- packages --------

#load needed packages.
require(dplyr) #for data processing/cleaning
require(tidyr) #for data processing/cleaning
require(skimr) #for nice visualization of data 
require(ggplot2) #for visualization of data
require(lattice) #for visualization of data
library(ggpubr) #for data anaylsis
library(tidyverse) #for visualization of data
library(broom) #for data anaylsis
library(AICcmodavg) #for data anaylsis

## ---- loaddata --------
#path to data

data_location <- "../../Data/Processed_data/penguins.csv"
data_path <- "../../Data/Processed_data/"

#load data. 

cleandata <- read.csv(data_location, check.names=FALSE)

#look at data
skimr::skim(cleandata)

summary(cleandata)

##1.Is there a difference between females and males among the three species of penguins?

s1 <- cleandata  #saving data before we edit it
s1$Sex <- as.factor(s1$Sex) #changing the sex of the penguins into categorical/factor variables
plot(s1$Sex )
plot(x = s1$Sex, y = s1$`Body Mass (g)`, main = "Comparison between penguin sex and body mass", xlab="Sex", ylab="Body mass (g)")  #Sex vs Body mass--all species
plot(x=s1$Sex,  y=s1$`Culmen Length (mm)`, main = "Comparison between penguin sex and culmen length`", xlab="Sex", ylab="Culmen Length (mm)")#Sex vs Culmen Length-- all species
plot(x=s1$Sex, y=s1$`Culmen Depth (mm)`, main = "Comparison between penguin sex and `Culmen Depth (mm)`", xlab="Sex", ylab="Culmen Depth (mm)")#sex vs Culmen Depth--all species
plot(x=s1$Sex, y=s1$`Flipper Length (mm)`, main = "Sex vs. `Flipper Length(mm)`", xlab="Sex", ylab="Flipper Length(mm)") #Sex vs Flipper Length--all species


###Looking at just Adelie Sex comparison

with(s1[s1$species=="Adelie",], plot(x = s1$Sex, y = s1$`Body Mass (g)`, main = "Adelie Body Mass comparison",  xlab= "Sex", ylab= "Body mass (g)"))   #Adelie Sex vs Body Mass
with(s1[s1$species=="Adelie",], plot(x=s1$Sex, y=s1$`Culmen Length (mm)`, main = "Adelie Culmen Length comparison`",xlab="Sex", ylab="Culmen Length (mm)")) #Adelie Sex vs Cumlen Length
with(s1[s1$species=="Adelie",], plot(x=s1$Sex, y=s1$`Culmen Depth (mm)`, main = "Adelie Culmen Depth comparison", xlab="Sex", ylab="Culmen Depth (mm)")) #Adelie Sex vs Cumlen Depth
with(s1[s1$species=="Adelie",], plot(x=s1$Sex, y=s1$`Flipper Length (mm)`, main = "Adelie Flipper Length comparison", xlab="Sex", ylab="Flipper Length(mm)")) #Adelie Sex vs Flipper Length

###Looking at just Gentoo Sex comparison

with(s1[s1$species=="Gentoo",], plot(x = s1$Sex, y = s1$`Body Mass (g)`, main = "Gentoo Body Mass comparison",  xlab= "Sex", ylab= "Body mass (g)")) #Gentoo Sex vs Body Mass
with(s1[s1$species=="Gentoo",], plot(x=s1$Sex, y=s1$`Culmen Length (mm)`, main = "Gentoo Culmen Length comparison",xlab="Sex", ylab="Culmen Length (mm)")) #Gentoo Sex vs Cumlen Length
with(s1[s1$species=="Gentoo",], plot(x=s1$Sex, y=s1$`Culmen Depth (mm)`, main = "Gentoo Culmen Depth comparison", xlab="Sex", ylab="Culmen Depth (mm)")) #Gentoo Sex vs Cumlen Depth
with(s1[s1$species=="Gentoo",], plot(x=s1$Sex, y=s1$`Flipper Length (mm)`, main = "Gentoo Flipper Length comparison", xlab="Sex", ylab="Flipper Length(mm)"))  #Gentoo Sex vs Flipper Length


     
###Looking at just Chinstrap Sex comparison
with(s1[s1$species=="Chinstrap",], plot(x = s1$Sex, y = s1$`Body Mass (g)`, main = "Chinstrap  Body Mass comparison",  xlab= "Sex", ylab= "Body mass (g)")) #Chinstrap Sex vs Body Mass
with(s1[s1$species=="Chinstrap",], plot(x=s1$Sex, y=s1$`Culmen Length (mm)`, main = "Chinstrap  Culmen Length comparison",xlab="Sex", ylab="Culmen Length (mm)")) #Chinstrap Sex vs Cumlen Length
with(s1[s1$species=="Chinstrap ",], plot(x=s1$Sex, y=s1$`Culmen Depth (mm)`, main = "Chinstrap Culmen Depth comparison", xlab="Sex", ylab="Culmen Depth (mm)")) #Chinstrap Sex vs Cumlen Depth
with(s1[s1$species=="Chinstrap",], plot(x=s1$Sex, y=s1$`Flipper Length (mm)`, main = "Chinstrap  Flipper Length comparison", xlab="Sex", ylab="Flipper Length(mm)"))  #Chinstrap Sex vs Flipper Length

     
##2. Are the 3 species of penguins different?
s2 <- s1
unique(s2$Species)

xyplot(`Body Mass (g)` ~  `Culmen Length (mm)`| Species, data = s2, layout = c(4, 1))

xyplot(`Body Mass (g)` ~  `Culmen Depth (mm)`| Species, data = s2, layout = c(4, 1))

xyplot(`Body Mass (g)` ~  `Flipper Length (mm)`| Species, data = s2, layout = c(4, 1))

xyplot(`Culmen Length (mm)` ~  `Culmen Depth (mm)`| Species, data = s2, layout = c(4, 1))

xyplot(`Culmen Length (mm)` ~  `Flipper Length (mm)`| Species, data = s2, layout = c(4, 1))

xyplot(`Culmen Depth (mm)` ~  `Flipper Length (mm)`| Species, data = s2, layout = c(4, 1))

##3. Is there a difference in penguins between the regions

s3 <- s2
unique(s3$Island)
s3$Island <- as.factor(s3$Island)

plot(x = s3$Island)
plot(x = s3$Island, y = s3$`Body Mass (g)`, main = "Island  Body Mass comparison",  xlab = "Island", ylab = "Body mass (g)") #Island  vs Body mass--all species

plot(x=s3$Island, y=s1$`Culmen Length (mm)`, main = "Island  Culmen Length comparison",xlab="Island", ylab="Culmen Length (mm)") #Island  vs Culmen Length-- all species

plot(x=s3$Island, y=s1$`Culmen Depth (mm)`, main = "Island Culmen Depth comparison", xlab="Island", ylab="Culmen Depth (mm)") #Island  vs Culmen Depth--all species

plot(x=s3$Island, y=s1$`Flipper Length (mm)`, main = "Island  Flipper Length comparison", xlab="Island", ylab="Flipper Length(mm)")  #Island vs Flipper Length--all species

xyplot(`Body Mass (g)` ~  `Culmen Length (mm)`| Island, data = s2, layout = c(4, 1))

xyplot(`Body Mass (g)` ~  `Culmen Depth (mm)`| Island, data = s2, layout = c(4, 1))

xyplot(`Body Mass (g)` ~  `Flipper Length (mm)`| Island, data = s2, layout = c(4, 1))

xyplot(`Culmen Length (mm)` ~  `Culmen Depth (mm)`| Island, data = s2, layout = c(4, 1))

xyplot(`Culmen Length (mm)` ~  `Flipper Length (mm)`| Island, data = s2, layout = c(4, 1))

xyplot(`Culmen Depth (mm)` ~  `Flipper Length (mm)`| Island, data = s2, layout = c(4, 1))


## ---- savedata --------

analyzeddate <- s3

# location to save file

save_data_location <- "../../Code/Analysis_code/penguins.rds"
saveRDS(analyzeddate, file = save_data_location)

save_data_location_csv <- "../../Code/Analysis_code/penguins.csv"
write.csv(analyzeddate, file = save_data_location_csv, row.names=FALSE)
