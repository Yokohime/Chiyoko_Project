# Code Folder

## Code Location:

Place your various `.R` or `.qmd` scripts in the appropriate folders:

- Processing_code for cleaning raw data to processed data
- Analysis_code or your analyses on cleaned data. 

Depending on your specific project, you might want to have further sub-folders.

## Code Design:

You can either have fewer large scripts, or multiple scripts that do only specific actions. Those can be R scripts or qmd files. In either case, document the scripts and what goes on in them so well that someone else (including future you) can easily figure out what is happening.

The scripts should load the appropriate data (e.g. raw or processed), perform actions, and save results (e.g. processed data, figures, computed values) in the appropriate folders. 

Be sure to use **relative paths** so that each script works from the working directory set to the folder that the script is in. 

## Required Documentation:

-The processingcode.R script runs using Rstudio or R using the data from 'penguins_raw_dirty.csv' found under Data/Raw_data folder. The output for this script can be
found in Data/Processed_data/ as 'penguins.rds' and 'penguins.csv'.
-  The processingfile_v1.qmd requires Quarto or Rstudio with rmarkdown. This file uses the 'penguins_raw_dirty.csv' file again found under Data/Raw_data folder. The
output for this file can be found under Data/Processed_data/ named as 'processeddate.rds' and 'processeddata.csv'.
-The processingfile_v2.qmd requires the code chuncks from the R script found in the processingcode.R that was ran first. The input and output for this file is the same
as the processingcode.R because it uses the code in the R script.

