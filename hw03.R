# ==============================================================================
# File name:    hw03.do
# Task:         Homework 3
# Project:      Research seminar pt. 1
# Author:       YOUR NAME HERE                                                                                   
# ==============================================================================
#   
#   
# ------------------------------------------------------------------------------ 
# About this do-file:
#   
#   1) Data and labels
#   2) Values review
#   3) Substantive review and consistency checks
#   4) Missing values review
# ------------------------------------------------------------------------------
#   
#   
# ------------------------------------------------------------------------------
# Notes:
#   
# This do-file is based on the suggestions by Long(2008: 210-241).
# 
# It discusses several aspects of how data can be explored and checked. 
# Verifying data in this way is important at every step of data processing. 
# 
# Make sure to conduct a final and all-encompassing verification with your final 
# data before you start data analysis.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# 1) Data and labels
#   
# The following commands look for problems in a dataset. They're ideal for 
# overall data verification immediately after opening a dataset or before saving 
# a new dataset after data processing.
# 
# Additional tasks:
# a. List the variables which include the string "math"!
# b. Check if the mother ID variable and year uniquely identify observations!
# ------------------------------------------------------------------------------
clean2 <- read.dta13(file.path(pdata, "clean2.dta"))  # load data 
View(clean2)
warnings()          # list warnings


# get label names, does not work correctly 
# labname <- get.label.name(clean2)
# get.label(clean2, labname)

#dublicates 
duplicated(clean2$cpubid)         # logical value if a observation has duplicates
table(duplicated(clean2$cpubid))  # table how many duplicates
clean2[which(!duplicated(clean2$cpubid)),]  # give dataset without dublicates 

table(duplicated(clean2$caseid)) # lists all entries which have dublicates 
table(duplicated(clean2[,c("cpubid","year")])) 

# unique(clean2[c(cpubid)])                   # extract unique elements variable is uniquely identified

# describe data 
str(clean2)       # data structure

list(colnames(clean2[,which(str_detect(colnames(clean2), "bpi"))])) # list coloumn names of dataset containing the string "bpi"

head(clean2)      # lists variables with value labels for the first 6 observations

# Additional tasks:
# a. List the variables which include the string "math"!
list(colnames(clean2[,which(str_detect(colnames(clean2), "math"))]))

# b. Check if the mother ID variable and year uniquely identify observations!
table(duplicated(clean2[,c("caseid","year")])) 

# ------------------------------------------------------------------------------
# #2 Values review
#   
# - Are the variable values appropriate?
# - Are the values complete?
#   
# Additional tasks:
#   a. Check the values for the variable that reports alcohol use during pregnancy!
#   b. What's the name of the value label of cmale and what are it's values?
#   c. Check the values of asex! Why is it a constant?
#   d. Check the birth year of children that were 5 at their first math test in 2000
#      (math_n counts the number of math tests)
#   d. Capture the output from "codebook, compact" and export it to the folder 
#      codebooks!
#   e. Make histograms for the assessments math, recog, comp, bpi, combine them as a
#      2x2 figure and export them to the folder figures!
# ------------------------------------------------------------------------------
# 
# shows number of missing obs, number of values, mean, median, min, max, range, number of zeros, SE of mean, CI of mean, variance and standard deviation 
stat.desc(clean2)
 
# distribution of all values (for multiple categorical variables)
result1 <- lapply(list(clean2$crace, clean2$ayrb, clean2$fstbrn, clean2$mdrug, clean2$cint), table) # applies the same function table to every object of list and stores it in result1
result1

# distribution of metric variables 
result2 <- lapply(list(clean2$math, clean2$recog, clean2$comp, clean2$bpi), describe)
result2

# log-files to export output in text-form (to folder tables)
sink(file=file.path(texts, "logile.txt"))
result3 <- lapply(clean2, describe)
result3
sink()


# distribution of metric variables (graphical display)
as.factor(clean2$math)      #converting in factor variable
barplot <- ggplot(clean2, aes(x = math)) + geom_bar() + xlim(0,max(clean2$math)) + coord_flip()
barplot

# histogram
hist <- ggplot(clean2, aes(x = math)) +  geom_histogram(binwidth=2, aes(y=..density..)) # histogram (with fraction on y-axis)
hist

# combine multiple
hist1 <- ggplot(clean2, aes(x = csage_yr)) +  geom_histogram(binwidth=0.5, aes(y=..density..), fill=I("blue"), alpha=0.6, main="Histogram for Child's age")
hist2 <- ggplot(clean2, aes(x = msage_yr)) +  geom_histogram(binwidth=0.5, aes(y=..density..), fill=I("blue"), alpha=0.6, main="Histogram for Child's age, mother supply")
hist3 <- ggplot(clean2, aes(x = agech_yr)) +  geom_histogram(binwidth=0.5, aes(y=..density..), fill=I("blue"), alpha=0.6, main="Histogram for Child's age in month")

ggarrange(hist1, hist2, hist3, 
          labels = c("A", "B", "C"),
          ncol = 3, nrow = 1)

#  ...and then be exported to the folder figures
ggsave("hist_cage_hw03.png", plot = last_plot(), device =  "png", path = plots)

# Additional tasks 
# a. Check the values for the variable that reports alcohol use during pregnancy!
levels(clean2$malcu)

# b. What's the name of the value label of cmale and what are it's values?
label(clean2$cmale) 
levels(clean2$cmale)

# c. Check the values of asex! Why is it a constant?
levels(clean2$asex)

# d. Capture the output from "codebook, compact" and export it to the folder 
#    codebooks!
sink(file=file.path(texts, "logile2.txt"))
result3 <- lapply(clean2, describe)
result3
sink()

# e. Make histograms for the assessments math, recog, comp, bpi, combine them as a
#    2x2 figure and export them to the folder figures!
hist4 <- ggplot(clean2, aes(x = math)) +  geom_histogram(binwidth=0.5, aes(y=..density..), fill=I("blue"), alpha=0.6)
hist5 <- ggplot(clean2, aes(x = recog)) +  geom_histogram(binwidth=0.5, aes(y=..density..), fill=I("blue"), alpha=0.6)
hist6 <- ggplot(clean2, aes(x = comp)) +  geom_histogram(binwidth=0.5, aes(y=..density..), fill=I("blue"), alpha=0.6)
hist7 <- ggplot(clean2, aes(x = bpi)) +  geom_histogram(binwidth=0.5, aes(y=..density..), fill=I("blue"), alpha=0.6)

ggarrange(hist4, hist5, hist5, hist7,  
          labels = c("A", "B", "C", "D"),
          ncol = 2, nrow = 2)
ggsave("hist_cage_hw03_2.png", plot = last_plot(), device =  "png", path = plots)


# ------------------------------------------------------------------------------
# Substantive review and consistency checks
#   
# - Is the distribution of the variable values substantively reasonable?
# - Are there too many or too few cases for some values?
# - Is the variable appropriabtely related to other variables?
#   
# Additional tasks:
#   a. Check whether the mother's race and the child's race are always identical!
#   b. Check whether the data conform to the expectation that the math score 
# increases with the age at assessment (csage_yr)!
#   c. Check whether every child with low birthweight really weighted less than 88
# ounces!
#   d. For how many children in the data did the mother report daily alcohol use
# during pregnancy? Use codebook to check for unique values of Child ID!
#   e. Look at all children by mother 2 in the data editor! 
#   f. Check whether the child's sex changes during the observation period!
# ------------------------------------------------------------------------------*/


# How early or late were children born?
table(clean2$btime)     
# Relation between reading recognition and comprehension
ggplot(clean2, aes(x=clean2$recog, y=clean2$comp)) +  geom_point(shape=1)   

# using jitter option to disperse data points
jitter(clean2$recog, factor = 5, amount = NULL)
jitter(clean2$comp, factor = 5, amount = NULL)
ggplot(clean2, aes(x=clean2$recog, y=clean2$comp)) +  geom_point(shape=1)  

# Matrix of scatter plots to relate multiple variables
jitter(clean2$csex, factor = 3, amount = NULL)
jitter(clean2$math, factor = 3, amount = NULL)
jitter(clean2$comp, factor = 3, amount = NULL)
jitter(clean2$recog, factor = 3, amount = NULL)
jitter(clean2$bpi, factor = 3, amount = NULL)

pairs(~ csex + math + recog + comp + bpi, clean2)
# alternative matrix: 
ggpairs(clean2[, c("csex", "math", "recog", "comp", "bpi")], binwidth = 0.5) 
ggcorr(clean2[, c("csex", "math", "recog", "comp", "bpi")]) # correlation matrix

# check distribution of assessment scores by child's sex
by(clean2[,c("math", "recog", "comp", "bpi")], clean2[, "csex"], describe)

# Are there children who become younger over time (one the msage variable)?		   
# sort data
clean2[order(clean2$cpubid, clean2$year),] 

# create lags 
clean2$cpubid01 <- Lag(clean2$cpubid) 
clean2$msage01 <- Lag(clean2$msage)
# create subset
subset1 <- subset(clean2,clean2$cpubid == clean2$cpubid01 & clean2$msage <= clean2$msage01 & !is.na(clean2$msage01) )
View(subset1)

# Detailed look at these cases using subset function
subset2 <- subset(clean2, cpubid==46702 | cpubid==305702 | cpubid==377201 | cpubid==460202, 
                  select=c(cpubid, year, msage, csage, agech, cyrb))
View(subset2)

# Additional tasks:

# a. Check whether the mother's race and the child's race are always identical!
length(which(clean2$crace!=clean2$arace))

# b. Check whether the data conform to the expectation that the math score 
# increases with the age at assessment (csage_yr)!
isTRUE(cor(clean2$math, clean2$csage_yr, use="pairwise.complete.obs")>0)

# c. Check whether every child with low birthweight really weighted less than 88
# ounces!
length(which(clean2$lbweight==1 & clean2$cbwght >= 88))

# d. For how many children in the data did the mother report daily alcohol use
# during pregnancy? Use codebook to check for unique values of Child ID!
length(which(clean2$malc==1))

# e. Look at all children by mother 2 in the data editor! 
subset3 <- subset(clean2, clean2$caseid==2)
View(subset3)

# f. Check whether the child's sex changes during the observation period!
csex01 <- Lag(clean2$csex)
length(which(clean2$csex!=clean2$csex01 & clean2$cpubid==clean2$cpubid01))


# Could not find anything to produce notes in R
# * We can make a note about these cases for later
# note: For the following children, the age variable msage runs backwards ///
#   at least once: 46702, 305702, 377201, 460202
# 
# * We can also make notes about specific variables
# note msage: This variable provides the age at which BPI was assessed.
# 
# notes // This displays all the notes in the dataset

# ------------------------------------------------------------------------------
# 4 Missing values review
#   
# - What types of and how many missing values?
# - Are skip patterns of the questionnaire reflected in the missing values?
#   
# Additional tasks:
#   a. Check if frequency of alcohol use during pregnancy is really missing if 
#   Mother drank alcohol during 12 months before birth says "No"
#   b. Check if education of spouse at birth of child is really missing if
#   family structure at birth says "No partner"!
#   ------------------------------------------------------------------------------*/
#   
# Is frequency of smoking during pregn. missing for no smoking 12m bef. birth?
length(which(clean2$msmou==0 & is.na(clean2$msmou)==TRUE))


# a. Check if frequency of alcohol use during pregnancy is really missing if 
#    Mother drank alcohol during 12 months before birth says "No"
length(which(clean2$malcu==0 & is.na(clean2$malcf)==TRUE))


# b. Check if education of spouse at birth of child is really missing if
#    family structure at birth says "No partner"!
length(which(clean2$famstr_b ==0 & is.na(clean2$spousgrade_b_cat)==TRUE))

