/*==============================================================================
File name:    hw04sol.do
Task:         Homework 4 solution
Project:      Research seminar pt. 1
Author:       Michael Kuehhirt                                                                             
==============================================================================*/


/*------------------------------------------------------------------------------ 
About this dofile:

#0 Load and check data
#1 Editing missing values
#2 Recode
#3 Generate and replace
#4 Labels
#5 Sort and save data
------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------
Notes:
------------------------------------------------------------------------------*/

version 12.0      // Stata version control


/*------------------------------------------------------------------------------
#0 Load and check data

Tasks:
a. Load the data combi.dta
b. Perform some data checks to find out how missing values are coded.
------------------------------------------------------------------------------*/

use "${pdata}/combi.dta", clear   // a.


codebook, compact                 // b.
codebook relspptr*


/*------------------------------------------------------------------------------
#1 Missing values

Task:
Recode all numerical missing values (except -999) to . Use the mvdecode command 
(in combination with _all) to edit all variables at once.
------------------------------------------------------------------------------*/

mvdecode _all, mv(-7/-1)  // turn all values between -7 and -1 into .


/*------------------------------------------------------------------------------
#2 Recode

Additional tasks:
a. Recode the variables hgcrev_b, spousgrade_b, partgrade_b, hgcrev_t, 
   spousgrade_t, and partgrade_t so that 0/11 become 1 (No degree), 12 becomes
   2 (Highschool degree), 13/15 become 3 (Some college), and 16/20 become 4
   (4-year college degree), generating new variables with the suffic _cat.
b. Recode the variables relspptr_b and relspptr_t so that -999/0 become 1
   (No partner), 1 becomes 2 (Spouse), 33 becomes 3 (Partner), and 36 becomes .
   generating the variables famstr_b and famstr_t.
------------------------------------------------------------------------------*/

* Recode
recode bthordr 1=1 2/11=0, gen(fstbrn)

recode csex (2=0 "Female") (1=1 "Male"), gen(cmale)


* a.
tab1 hgcrev_* *grade*
recode hgcrev_b                            /// 
       (0/11  = 1 "No degree")             ///
       (12    = 2 "Highschool degree")     ///
       (13/15 = 3 "Some college")          ///
       (16/20 = 4 "4-year college degree") ///
	  , gen(hgcrev_b_cat) 

	  
recode hgcrev_t                            /// 
       (0/11  = 1 "No degree")             ///
       (12    = 2 "Highschool degree")     ///
       (13/15 = 3 "Some college")          ///
       (16/20 = 4 "4-year college degree") ///
	  , gen(hgcrev_t_cat) 	 
	  
recode spousgrade_b                        /// 
       (0/11  = 1 "No degree")             ///
       (12    = 2 "Highschool degree")     ///
       (13/15 = 3 "Some college")          ///
       (16/35 = 4 "4-year college degree") ///
	  , gen(spousgrade_b_cat)	  
		  
recode spousgrade_t                        /// 
       (0/11  = 1 "No degree")             ///
       (12    = 2 "Highschool degree")     ///
       (13/15 = 3 "Some college")          ///
       (16/20 = 4 "4-year college degree") ///
	  , gen(spousgrade_t_cat)	  

recode partgrade_b                        /// 
       (0/11  = 1 "No degree")             ///
       (12    = 2 "Highschool degree")     ///
       (13/15 = 3 "Some college")          ///
       (16/35 = 4 "4-year college degree") ///
	  , gen(partgrade_b_cat)	  
		  
recode partgrade_t                        /// 
       (0/11  = 1 "No degree")             ///
       (12    = 2 "Highschool degree")     ///
       (13/15 = 3 "Some college")          ///
       (16/20 = 4 "4-year college degree") ///
	  , gen(partgrade_t_cat)	  

	  
* b.	  
tab1 relsp*	  
recode relspptr_b               /// 
	  (-999/0 = 1 "No partner") ///
	  (1      = 2 "Spouse")     ///
	  (33     = 3 "Partner")    ///
	  (36     = .)              ///
	 , gen(famstr_b)
	 
recode relspptr_t               /// 
	  (-999/0 = 1 "No partner") ///
	  (1      = 2 "Spouse")     ///
	  (33     = 3 "Partner")    ///
	  (36     = .)              ///
	 , gen(famstr_t)	 


/*------------------------------------------------------------------------------
#3 Generate and replace

Additional tasks:
a. Generate the new variables msage_dyr, msage_yr, agech_dyr, and agech_yr
   following the example for csage.
b. Generate the variable malc so that it containes the information from malcf
   but is 0 if malcu is 0.
c. Generate the variable lbweight so that it is 0 if birth weight is 88 to 768
   ounces and 1 if it is below 88 ounces.
d. Generate the variable mdrug so that is 0 if the mother didn't use THC and
   cocain during 12 months before birth and is one if the mother used either in
   that period.
e. Generate the variable btime so that it is 0 if the child was born around 
   the due data (cborndue) and takes the value of nwearlat if it was born 
   after the due data (cearlat=2) and the negative value of nwearlat if it was
   born before the due data (cearlat=1).
------------------------------------------------------------------------------*/
 
gen csage_dyr=csage/12           // decimal years
gen csage_yr=int(csage_dyr)      // integer cuts of values behind the point

gen msage_dyr=msage/12           // decimal years
gen msage_yr=int(msage_dyr)      // integer cuts of values behind the point

gen agech_dyr=agech/12           // decimal years
gen agech_yr=int(agech_dyr)      // integer cuts of values behind the point
 

* replace (combining information from different variables)
gen msmoke=msmof
replace msmoke=0 if msmou==0

gen malc=malcf
replace malc=0 if malcu==0

gen lbweight=0 if cbwght>=88 & cbwght<768
replace lbweight=1 if cbwght<88

gen mdrug=0 if mthcu==0 & mcocu==0
replace mdrug=1 if mthcu==1 | mcocu==1

gen btime=0 if cborndue==1
replace btime=nwearlat if cearlat==2
replace btime=-nwearlat if cearlat==1	 


/*------------------------------------------------------------------------------
#4 Lables

a. Label the following variables:
   caseid "Mother ID"
   year "Survey year"
   fstbrn "Child is firstborn"
   cmale "Child is male"
   hgcrev_t_cat "Mother's education at t"
   spousgrade_t_cat "Spouses's education at t"
   partgrade_t_cat "Partner's education at t"
   famstr_t "Family structure at t"
   hgcrev_b_cat "Mother's education at birth"
   spousgrade_b_cat "Spouses's education at birth"
   partgrade_b_cat "Partner's education at birth"
   famstr_b "Family structure at birth"
   csage_dyr "Age of child at assessment (dec. yrs)"
   msage_dyr "Age of child at mother suppl. (dec. yrs)"
   agech_dyr "Age of child at mother int. (dec. yrs)"
   csage_yr "Age of child at assessment (yrs)"
   msage_yr "Age of child at mother suppl. (yrs)"
   agech_yr "Age of child at mother int. (yrs)"
   msmoke "No. of cigatettes smoked during pregnancy"
   malc "Alcohol use during pregnancy"
   mdrug "Drug use during 12 months before birth"
   lbweight "Child was low birth weight"
   btime "Timing of birth (0=at due date)"
b. Define the value label msmoke with value 0 (None), 1 (Less than 1 pack/day),
   2 (1 or more but less than 2), 3 (2 or more packs/day)
c. Assign the value label yesno to the variables cbrstfd, lbweight, and mdrug 
d. Assign the value label msmoke to the variable msmoke and the value label
   vlC0320300 to the variable malc
------------------------------------------------------------------------------*/


* Label variables and values	 
label var cpubid "Child ID"
label var caseid "Mother ID"
label var year "Survey year"

label var fstbrn "Child is firstborn"
label var cmale "Child is male"

label var hgcrev_t_cat "Mother's education at t"
label var spousgrade_t_cat "Spouses's education at t"
label var partgrade_t_cat "Partner's education at t"
label var famstr_t "Family structure at t"

label var hgcrev_b_cat "Mother's education at birth"
label var spousgrade_b_cat "Spouses's education at birth"
label var partgrade_b_cat "Partner's education at birth"
label var famstr_b "Family structure at birth"

label var csage_dyr "Age of child at assessment (dec. yrs)"
label var msage_dyr "Age of child at mother suppl. (dec. yrs)"
label var agech_dyr "Age of child at mother int. (dec. yrs)"

label var csage_yr "Age of child at assessment (yrs)"
label var msage_yr "Age of child at mother suppl. (yrs)"
label var agech_yr "Age of child at mother int. (yrs)"

label var msmoke "No. of cigatettes smoked during pregnancy"
label var malc "Alcohol use during pregnancy"
label var mdrug "Drug use during 12 months before birth"

label var lbweight "Child was low birth weight"
label var btime "Timing of birth (0=at due date)"

label def yesno 0"No" 1"Yes"
label val fstbrn yesno
label val cbrstfd yesno
label val lbweight yesno
label val mdrug yesno


label def msmoke 0"None" 1"Less than 1 pack/day" ///
                 2"1 or more but less than 2"    ///
				 3"2 or more packs/day"
label val msmoke msmoke

label val malc vlC0320300


/*------------------------------------------------------------------------------
#5 Sort and save the data

Tasks:
a. Sort the data by child ID and year
b. Save the data as clean1.dta in your folder procdata.
------------------------------------------------------------------------------*/

sort cpubid year

* Use this command if you're working with Stata13+
saveold "${pdata}/clean1.dta", replace v(12)

* Use this command if you're working with Stata12
*save "${pdata}/clean1.dta", replace



*==============================================================================*
