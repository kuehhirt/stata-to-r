/*==============================================================================
File name:    hw03sol.do
Task:         Homework 3 solution
Project:      Research seminar pt. 1
Author:       Michael Kuehhirt                                                                                   
==============================================================================*/


/*------------------------------------------------------------------------------ 
About this do-file:

#1 Data and labels
#2 Values review
#3 Substantive review and consistency checks
#4 Missing values review
------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------
Notes:

!!! THE SOLUTIONS HAVE TO BE INSERTED STILL !!!

This do-file is based on the suggestions by Long(2008: 210-241).

It discusses several aspects of how data can be explored and checked. 
Verifying data in this way is important at every step of data processing. 

Make sure to conduct a final and all-encompassing verification with your final 
data before you start data analysis.
------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------
#1 Data and labels

The following commands look for problems in a dataset. They're ideal for overall
data verification immediately after opening a dataset or before saving a new
dataset after data processing.

Additional tasks:
a. List the variables which include the string "math"!
b. Check if the mother ID variable and year uniquely identify observations!
------------------------------------------------------------------------------*/

use "${pdata}/clean2.dta", clear // opens the cleaned data set


codebook, problems // indicates constants, nonexisting & incomplete value labels

isid cpubid year   // checks for unique ID variable(s) (and stops do-file if no)

duplicates report cpubid       // does sth similar but w/out stopping do-file
duplicates report caseid
duplicates report cpubid year

describe // lists all variables, type, format, value label name, variable label 

lookfor bpi // lookfor return all variables that contain the string entered

label list // lists all value labels in the data


* Tasks:
lookfor math                  // a.
duplicates report caseid year // b.


/*------------------------------------------------------------------------------
#2 Values review

- Are the variable values appropriate?
- Are the values complete?

Additional tasks:
a. Check the values for the variable that reports alcohol use during pregnancy!
b. What's the name of the value label of cmale and what are it's values?
c. Check the values of asex! Why is it a constant?
d. Check the birth year of children that were 5 at their first math test in 2000
   (math_n counts the number of math tests)
e. Capture the output from "codebook, compact" and export it to the folder 
   codebooks!
f. Make histograms for the assessments math, recog, comp, bpi, combine them as a
   2x2 figure and export them to the folder figures!
------------------------------------------------------------------------------*/

* shows number of nomissing obs, unique values, mean, min, max, variable label
codebook, compact 

* small histogram, number of negative, zero, positive values, (non)integers ...
inspect

* distribution of all values (for multiple categorical variables)
tab1 crace ayrb fstbrn mdrug cint, m 

* distribution of metric variables 
sum math recog comp bpi

* log-files to export output in text-form (to folder tables)
capture log close   // closes and log that may be opened
log using "${texts}/sumall-hw03.txt", text replace // opens new log
sum _all
log close  // closes log

* distribution of metric variables (graphical display)
dotplot math // dot plot

hist math, frac // histogram (with fraction on y-axis)

* Histograms (or any plot) for multiple vars can be combined into one graph...
hist csage_yr, frac name(his_csage, replace)  // gives plot a unique name
hist msage_yr, frac name(his_msage, replace)
hist agech_yr, frac name(his_agech, replace)

graph combine his_csage his_msage his_agech, col(3)

* ...and then be exported to the folder figures
graph export "${plots}/hist-cage-hw03.png", replace


* Tasks:
tab malc  // a.

codebook cmale // b.

tab asex // c. asex constant because adult info from mothers only

ta cyrb if csage_yr==5 & math_n==1 & year==2000 // d. no children w/ value combi.

capture log close   // e.
log using "${cbook}/codebook-hw03.txt", text replace
codebook, compact
log close  

hist math, frac name(math, replace)  // f.
hist recog, frac name(recog, replace)
hist comp, frac name(comp, replace)
hist bpi, frac name(bpi, replace)

graph combine math recog comp bpi, col(2)
graph export "${plots}/hist-assess-hw03.png", replace



/*------------------------------------------------------------------------------
#3 Substantive review and consistency checks

- Is the distribution of the variable values substantively reasonable?
- Are there too many or too few cases for some values?
- Is the variable appropriabtely related to other variables?

Additional tasks:
a. Check whether the mother's race and the child's race are always identical!
b. Check whether the data conform to the expectation that the math score 
   increases with the age at assessment (csage_yr)!
c. Check whether every child with low birthweight really weighted less than 88
   ounces!
d. For how many children in the data did the mother report daily alcohol use
   during pregnancy? Use codebook to check for unique values of Child ID!
e. Look at all children by mother 2 in the data editor! 
f. Check whether the child's sex changes during the observation period!
------------------------------------------------------------------------------*/

tab btime // How early or late were children born?

scatter recog comp // Relation between reading recognition and comprehension
scatter recog comp, jitter(5)  // using jitter option to disperse data points

* Matrix of scatter plots to relate multiple variables
graph matrix csex math recog comp bpi                       ///
           , half msym(circle_hollow) msiz(tiny) jitter(3)

* check distribution of assessment scores by child's sex
bysort csex: sum math recog comp bpi
		   
* Are there children who become younger over time (one the msage variable)?		   
sort cpubid year
list cpubid if cpubid==cpubid[_n-1] & msage<=msage[_n-1] & msage[_n-1]<.

* Detailed look at these cases in the data editor
edit cpubid year msage csage agech  cyrb if cpubid==46702    ///
                                          | cpubid==305702   ///
                                          | cpubid==377201   ///
                                          | cpubid==460202   	

* We can make a note about these cases for later
note: For the following children, the age variable msage runs backwards ///
      at least once: 46702, 305702, 377201, 460202

* We can also make notes about specific variables
note msage: This variable provides the age at which BPI was assessed.

notes // This displays all the notes in the dataset


* Tasks:
tab arace crace // a.

scatter math csage_yr, jitter(5) // b.

tab cbwght if lbweight==1 // c.

codebook cpubid if malc==7 // d.

edit if caseid==2 // e.

sort cpubid year // f.
list cpubid if cpubid==cpubid[_n-1] & csex!=csex[_n-1]



/*------------------------------------------------------------------------------
#4 Missing values review

- What types of and how many missing values?
- Are skip patterns of the questionnaire reflected in the missing values?

Additional tasks:
a. Check if frequency of alcohol use during pregnancy is really missing if 
   Mother drank alcohol during 12 months before birth says "No"
b. Check if education of spouse at birth of child is really missing if
   family structure at birth says "No partner"!
------------------------------------------------------------------------------*/

* Is frequency of smoking during pregn. missing for no smoking 12m bef. birth?
ta msmou msmof, m 


* Tasks:
ta malcf if malcu==0, m  // a.
ta malcf malcu, m        // alternative

ta spousgrade_b_cat famstr_b, m  // b.


*==============================================================================*
