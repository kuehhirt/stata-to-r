# ==============================================================================
#   File name:    hw04.do
# Task:         Homework
# Project:      Research seminar pt. 1
# Author:       YOUR NAME HERE                                                                                 
# ==============================================================================
#   
#   
# ------------------------------------------------------------------------------ 
#   About this dofile:
# 0) Load and check data
# 1) Editing missing values
# 2) Recode
# 3) Generate and replace
# 4) Labels
# 5) Sort and save data
# ------------------------------------------------------------------------------
#   
#   
# ------------------------------------------------------------------------------
#   Notes:
# ------------------------------------------------------------------------------
#   
# ------------------------------------------------------------------------------
# 0) Load and check data
# Tasks:
# a. Load the data combi.dta
# b. Perform some data checks to find out how missing values are coded.
# ------------------------------------------------------------------------------*/

# a. Load the data combi.dta
combi <- read.dta13(file.path(pdata, "combi.dta")) 

# b. Perform some data checks to find out how missing values are coded.

View(combi)
stat.desc(combi) 
table(combi$math) # values smaller than 0 are missings, but R only reports those coded as NA (in Stata file -999) as missings

# ------------------------------------------------------------------------------
# 1) Missing values
# Task:
# Recode all numerical missing values (except NA) to NA. 
# ------------------------------------------------------------------------------
for (val in names(combi)){
  combi[[val]][combi[[val]]<0] <- NA # [[]] used instead of $ to call variable
}

View(combi)

# ------------------------------------------------------------------------------
# #2 Recode
# Besides simple recoding, also new variables and new variable labels can be 
# created.
# 
# Additional tasks:
# a. Recode the variables hgcrev_b, spousgrade_b, partgrade_b, hgcrev_b, 
# spousgrade_b, and partgrade_b so that 0/11 become 1 (No degree), 12 becomes
# 2 (Highschool degree), 13/15 become 3 (Some college), and 16/20 become 4
# (4-year college degree), generating new variables with the suffic _cat.
# b. Recode the variables respptr_b and relspptr_t so that -999/0 become 1
# (No partner), 1 becomes 2 (Spouse), 33 becomes 3 (Partner), and 36 becomes .
# generating the variables famstr_b and famstr_t.
# ------------------------------------------------------------------------------*/
#   
# Simple recode with generating new variable

combi$fstbrn <- ifelse(combi$bthordr==1, 1, ifelse(combi$bthordr>=1, 0, NA))
 
# Recode variable with new value labels
combi$cmale <- ifelse(combi$csex==2,0, ifelse(combi$csex==1,1,NA))
levels(combi$cmale) <- c("Female", "Male", "missed") 

# a. Recode the variables  so that 0/11 become 1 (No degree), 12 becomes
# 2 (Highschool degree), 13/15 become 3 (Some college), and 16/20 become 4
# (4-year college degree), generating new variables with the suffic _cat.

list=c("hgcrev_b","spousgrade_b","partgrade_b","hgcrev_t","spousgrade_t","partgrade_t")

for (i in list){
  combi[[paste0(i,"_cat")]][combi[[i]]>=0 & combi[[i]]<=11]<- 1 # second brackets call the rows with these conditions 
  combi[[paste0(i,"_cat")]][combi[[i]]==12]<- 2
  combi[[paste0(i,"_cat")]][combi[[i]]>=13 & combi[[i]]<=15]<- 3
  combi[[paste0(i,"_cat")]][combi[[i]]>=16]<- 4
  levels(combi[[paste0(i,"_cat")]]) <- c("No Degree", "Highschool Degree", "Some College", "4-year college degree")
}

# b. Recode the variables respptr_b and relspptr_t so that -999/0 become 1
# (No partner), 1 becomes 2 (Spouse), 33 becomes 3 (Partner), and 36 becomes .
# generating the variables famstr_b and famstr_t.

combi$famstr_b <- ifelse(combi$relspptr_b<0, 1, ifelse(combi$relspptr_b==1,2,ifelse(combi$relspptr_b==33,3,ifelse(combi$relspptr_b==36,NA,NA))))
levels(combi$famstr_b) <- c("No partner","Spouse","Partner", "Missed")
combi$famstr_t <- ifelse(combi$relspptr_t<0, 1, ifelse(combi$relspptr_t==1,2,ifelse(combi$relspptr_t==33,3,ifelse(combi$relspptr_t==36,NA,NA))))
levels(combi$famstr_t) <- c("No partner","Spouse","Partner", "Missed")


# ------------------------------------------------------------------------------
# 3) Generate and replace
# Additional tasks:
# a. Generate the new variables msage_dyr, msage_yr, agech_dyr, and agech_yr
# following the example for csage.
# b. Generate the variable malc so that it containes the information from malcf
# but is 0 if malcu is 0.
# c. Generate the variable lbweight so that it is 0 if birth weight is 88 to 768
# ounces and 1 if it is below 88 ounces.
# d. Generate the variable mdrug so that is 0 if the mother didn't use THC and
# cocain during 12 months before birth and is one if the mother used either in
# that period.
# e. Generate the variable btime so that it is 0 if the child was born around 
# the due data (cborndue) and takes the value of nwearlat if it was born 
# after the due data (cearlat=2) and the negative value of nwearlat if it was
# born before the due data (cearlat=1).
# ------------------------------------------------------------------------------*/
# 
# * generate new variable 
combi$csage_dyr <- combi$csage/12           #decimal years
combi$csage_yr <- as.integer(combi$csage_dyr, length=0)  #integer cuts of values behind the point

# a. Generate the new variables msage_dyr, msage_yr, agech_dyr, and agech_yr
# following the example for csage.
list2 <- c("msage","agech")
for (i in list2){
  combi[[paste0(i,"_dyr")]] <- combi[[i]]/12 #decimal years
  combi[[paste0(i,"_yr")]] <- as.integer(combi[[paste0(i,"_dyr")]], length=0) #integer cuts of values behind the point
}

# * genrate and replace (combining information from different variables)
# gen msmoke=msmof
# replace msmoke=0 if msmou==0
combi$msmoke <- combi$msmof
combi$msmoke <- ifelse(combi$msmou==0,0,combi$msmoke)

# b. Generate the variable malc so that it containes the information from malcf
# but is 0 if malcu is 0.
combi$malc <- combi$malcf
combi$msmoke[combi$msmoke==0] <- 0

# c. Generate the variable lbweight so that it is 0 if birth weight is 88 to 768
# ounces and 1 if it is below 88 ounces.
combi$lbweight <- ifelse(combi$cbwght>88 & combi$cbwght<768,0,ifelse(combi$cbwght<88,1,NA))

# d. Generate the variable mdrug so that is 0 if the mother didn't use THC and
# cocain during 12 months before birth and is one if the mother used either in
# that period.
combi$mdrug <- ifelse(combi$mcocu==0 & combi$mthcu==0, 0, ifelse(combi$mcocu==1 & combi$mthcu==1, 1, NA))

# e. Generate the variable btime so that it is 0 if the child was born around 
# the due data (cborndue) and takes the value of nwearlat if it was born 
# after the due data (cearlat=2) and the negative value of nwearlat if it was
# born before the due data (cearlat=1).
combi$btime <- ifelse(combi$cborndue==1, 0, ifelse(combi$cearlat==2, combi$nwearlat, ifelse(combi$cearlat==1, combi$nwearlat<0, NA))) 

# ------------------------------------------------------------------------------
# #4 Lables
# a. Label the following variables:
# caseid "Mother ID"
# year "Survey year"
# fstbrn "Child is firstborn"
# cmale "Child is male"
# hgcrev_t_cat "Mother's education at t"
# spousgrade_t_cat "Spouses's education at t"
# partgrade_t_cat "Partner's education at t"
# famstr_t "Family structure at t"
# hgcrev_b_cat "Mother's education at birth"
# spousgrade_b_cat "Spouses's education at birth"
# partgrade_b_cat "Partner's education at birth"
# famstr_b "Family structure at birth"
# csage_dyr "Age of child at assessment (dec. yrs)"
# msage_dyr "Age of child at mother suppl. (dec. yrs)"
# agech_dyr "Age of child at mother int. (dec. yrs)"
# csage_yr "Age of child at assessment (yrs)"
# msage_yr "Age of child at mother suppl. (yrs)"
# agech_yr "Age of child at mother int. (yrs)"
# msmoke "No. of cigatettes smoked during pregnancy"
# malc "Alcohol use during pregnancy"
# mdrug "Drug use during 12 months before birth"
# lbweight "Child was low birth weight"
# btime "Timing of birth (0=at due date)"
# b. Define the value label msmoke with value 0 (None), 1 (Less than 1 pack/day),
# 2 (1 or more but less than 2), 3 (2 or more packs/day)
# c. Assign the value label yesno to the variables cbrstfd, lbweight, and mdrug 
# d. Assign the value label msmoke to the variable msmoke and the value label
# vlC0320300 to the variable malc
# ------------------------------------------------------------------------------
# 
# 
# * Labelling variables
label(combi$cpubid) <- "Child ID" 

# * Defining value labels
yesno <- c("0 No", "1 Yes")

# # label val fstbrn yesno
levels(combi$fstbrn) <- yesno

# Assigning value labels 

label(combi$caseid) <-  "Mother ID"
label(combi$year) <-  "Survey year"
label(combi$fstbrn) <-  "Child is firstborn"        
label(combi$cmale) <-  "Child is male"
label(combi$hgcrev_t_cat) <-  "Mother's education at t"    
label(combi$spousgrade_t_cat) <-  "Spouses's education at t"
label(combi$partgrade_t_cat) <-  "Partner's education at t"
label(combi$famstr_t) <- "Family structure at t"
label(combi$hgcrev_b_cat) <- "Mother's education at birth"
label(combi$spousgrade_b_cat) <- "Spouses's education at birth"
label(combi$partgrade_b_cat) <- "Partner's education at birth"
label(combi$famstr_b) <- "Family structure at birth"
label(combi$csage_dyr) <- "Age of child at assessment (dec. yrs)"
label(combi$msage_dyr) <- "Age of child at mother suppl. (dec. yrs)"
label(combi$agech_dyr) <- "Age of child at mother int. (dec. yrs)"
label(combi$csage_yr) <- "Age of child at assessment (yrs)"
label(combi$msage_yr) <- "Age of child at mother suppl. (yrs)"
label(combi$agech_yr) <- "Age of child at mother int. (yrs)"
label(combi$msmoke) <- "No. of cigatettes smoked during pregnancy"
label(combi$malc) <- "Alcohol use during pregnancy"
label(combi$mdrug) <- "Drug use during 12 months before birth"
label(combi$lbweight) <- "Child was low birth weight"
label(combi$btime) <- "Timing of birth (0=at due date)"

#------------------------------------------------------------------------------
# #5 Sort and save the data
# Tasks:
# a. Sort the data by child ID and year
# b. Save the data as clean1.dta in your folder procdata.
# ------------------------------------------------------------------------------
combi[order(combi$cpubid, combi$year),] 
save.image(file=file.path(pdata,"clean1.RData"))