###############################
# processing script
#
#this script loads the raw data, processes and cleans it 
#and saves it as Rds file in the Processed_data folder
##Run this script first before you start the other two.


## ---- packages --------
#load needed packages.
require(dplyr) #for data processing/cleaning
require(tidyr) #for data processing/cleaning
require(skimr) #for nice visualization of data 

## ---- loaddata --------
#path to data

data_location <- "../../Data/Raw_data/penguins_raw_dirty.csv"
data_path <- "../../Data/Raw_data/"

#load data. 

rawdata <- read.csv(data_location, check.names=FALSE)

# look in the data dictionary for a variable explanation

dictionary <- read.csv(paste(data_path, "datadictionary.csv", sep=""))
print(dictionary)


## ---- exploredata --------


#Looking at the raw data
dplyr::glimpse(rawdata)


#this is a nice way to look at data
skimr::skim(rawdata)


## ---- cleandata1 --------
# Inspecting the data, we find that there are 9 unique names when we know
# there were only 3 species of penguins used in the experiment.

#Using 'unique' we can see how many unique hits come up under the species for
# the raw data
unique(rawdata$Species)

# Since some of the species names have typos, save rawdata as d1, and modify d1
# so we can compare versions. 

d1 <- rawdata

# Using 'grep' we grab the term and we can find the mispelled entry, and
# replace the whole thing:

ii <- grep("PengTin", d1$Species)
d1$Species[ii] <- "Adelie Penguin (Pygoscelis adeliae)"


# Then we check the data to make sure it is fixed
unique(d1$Species)

## ---- comment1 --------

# Fix all of the spelling errors. 
jj <- grep("(Pygoscelis adeliae)", d1$Species)
d1$Species[jj] <- "Adelie Penguin (Pygoscelis adeliae)"

ff <- grep("(Pygoscelis papua)", d1$Species)
d1$Species[ff] <- "Gentoo penguin (Pygoscelis papua)"

aa <- grep("(Pygoscelis antarctica)", d1$Species)
d1$Species[aa] <- "Chinstrap penguin (Pygoscelis antarctica)"

##Double check to make sure all the typos have been corrected.
unique(d1$Species)

#  Shorten Species name to the three common names "Adelie", 
#  "Gentoo", and "Chinstrap" and delete the rest of the Species character string. 

#Changing (Pygoscelis adeliae)-->Adelie
aa <- grep("(Pygoscelis adeliae)", d1$Species)
d1$Species[aa] <- "Adelie "
#Changing (Pygoscelis papua)-->Gentoo
ss <- grep("(Pygoscelis papua)", d1$Species)
d1$Species[ss] <- "Gentoo"
#Changing (Pygoscelis antarctica)-->Chinstrap
dd <- grep("(Pygoscelis antarctica)", d1$Species)
d1$Species[dd] <- "Chinstrap"
#Checking to make sure the Species names were all shortened correctly.
unique(d1$Species)


# There is an entry for `Culmen Length (mm)` which says "missing" instead of a number or NA. 
# This "missing" entry also turned all culmen length entries into characters instead of numeric.
# That conversion to character also means that our summary function isn't very meaningful.
# So let's fix that first.

## ---- cleandata2 --------

cl <- d1$`Culmen Length (mm)`  
                              # Make a temporary variable `cl` and save it 
                              # back to d1$`Culmen Length (mm)` when weʻre done. 

cl[ cl == "missing" ] <- NA  # find cl=="missing and replace "missing" with NA
cl <- as.numeric(cl)  # coerce to numeric
d1$`Culmen Length (mm)` <- cl


# look at partially fixed data again
skimr::skim(d1)
hist(d1$`Culmen Length (mm)`)

# bivariate plot with mass
plot(d1$`Body Mass (g)`, d1$`Culmen Length (mm)`)

# Notice 3 data points are not like the rest and seem like outliers. Need to look 
# into this.

## ---- cleandata3.1 --------

d2 <- d1 
cl[ cl > 300 ] #identify what the 3 points are.



## ---- cleandata3.2 --------
cl[ !is.na(cl) & cl>300 ]

# now replace with the same divided by 10:

cl[ !is.na(cl) & cl>300 ] <- cl[ !is.na(cl) & cl>300 ]/10  

d2$`Culmen Length (mm)` <- cl


#culmen length values seem ok now
skimr::skim(d2)
hist(d2$`Culmen Length (mm)`)

plot(d2$`Body Mass (g)`, d2$`Culmen Length (mm)`)


## ---- comment3 --------

# Now let's look at body mass. 
#  There are penguins with body mass of <100g when the others are over 3000. 
#  Perhaps these are new chicks? But they are supposed to be adults. Letʻs remove them.

## ---- cleandata4.1 --------
hist(d2$`Body Mass (g)`)

## ---- comment4 --------
# Mass is the main size variable, so we will probably need to remove the individuals with 
# missing masses in order to  be able to analyze the data. 

## ---- cleandata4.2 --------
d3 <- d2
mm <- d3$`Body Mass (g)`

mm[ mm < 100 ] <- NA       # replace tiny masses with NA
nas <- which( is.na(mm) )  # find which rows have NA for mass

d3 <- d3[ -nas, ]   # drop the penguins (rows) with missing masses


skimr::skim(d3)
hist(d3$`Body Mass (g)`)

plot(d3$`Body Mass (g)`, d3$`Culmen Length (mm)`)

## ---- comment5 --------

# We also want to have Species, Sex, and Island coded as a categorical/factor variable

## ---- cleandata5 --------
d3$Species <- as.factor(d3$Species)
d3$Sex <- as.factor(d3$Sex)
d3$Island <- as.factor(d3$Island)  
skimr::skim(d3)

## ---- bivariateplots --------
# Make bivariate plots for any remaining continuous data to ensure there are no further
# errors.
#Checking body mass vs culmen depth
plot(d3$`Body Mass (g)`, d3$`Culmen depth (mm)`)
#Checking body mass vs flipper length
plot(d3$`Body Mass (g)`, d3$`Flipper Length (mm)`)
#Checking Culmen length vs culmen depth
plot(d3$`Culmen Length (mm)`, d3$'Culmen depth (mm)')
#Checking Culmen length vs flipper length
plot(d3$`Culmen Length (mm)`, d3$'Flipper length (mm)')


# Make histograms or densities of at least mass by discrete category, to check for any 
# potential category errors, extra categories, etc. 

hist(d3$`Culmen Length (mm)`)
hist(d3$`Culmen Depth (mm)`)
plot(d3$Species)
plot(d3$Sex )
plot(d3$Island)


## ---- finalizedata --------
# Finalize your cleaned dataset. Drop any variables (columns) from the dataframe 
# that you wonʻt analyze. 
#saving data as d4 incase we make a mistake
d4 <- d3
#selecting all the columns we did not use and deleting them from the dataframe
d5 = select(d4, -1:-2, -6:-9, -15:-17)
#double checking that all the columns we did not use were deleted and that all the columns we did use are still here
skimr::skim(d5)




## ---- savedata --------
processeddata <- d5    

# location to save file

save_data_location <- "../../Data/Processed_data/penguins.rds"
saveRDS(processeddata, file = save_data_location)

save_data_location_csv <- "../../Data/Processed_data/penguins.csv"
write.csv(processeddata, file = save_data_location_csv, row.names=FALSE)


