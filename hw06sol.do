/*==============================================================================
File name:    hw06sol.do
Task:         Homework 6 solution
Project:      Research seminar pt. 1
Author:       Michael Kuehhirt                                                                              
==============================================================================*/


/*------------------------------------------------------------------------------ 
About this dofile:

#1 Merges child information
#2 Merges mother information
------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------
Notes:
------------------------------------------------------------------------------*/

version 12      // Stata version control


/*------------------------------------------------------------------------------
#1 Merge child information

Tasks below
------------------------------------------------------------------------------*/

*a. Load the dataset piat.dta
use "${pdata}/piat.dta", clear  


* merge other yearly info from bpi.dta
sort cpubid year
merge 1:1 cpubid year using "${pdata}/bpi.dta" ///
    , keep(1 3) nogen // keeps obs in master data only or in both master & using

	
*b. Merge all information from the datasets cage, temper, and resid
merge 1:1 cpubid year using "${pdata}/cage.dta" ///
    , keep(1 3) nogen 
	
merge 1:1 cpubid year using "${pdata}/temper.dta" ///
    , keep(1 3) nogen 	

merge 1:1 cpubid year using "${pdata}/resid.dta" ///
    , keep(1 3) nogen 	

	
* merge some time-constant info from basic.dta
sort cpubid
merge m:1 cpubid using "${pdata}/basic.dta" /// 
    , keepusing(c* m* fstyraft bthordr n*)  ///  
	  keep(1 3) nogen


/*------------------------------------------------------------------------------
#2 Merge mother information

Tasks below
------------------------------------------------------------------------------*/

* rename mother ID to caseid (so there is a common ID in master and using data
rename mpubid caseid


* time-constant information	  
sort caseid
merge m:1 caseid using "${pdata}/abasic.dta" /// time-constant info
    , keep(1 3) nogen 

	
* time-varying information at t
sort caseid year
merge m:1 caseid year using "${pdata}/myearly.dta", keep(1 3) nogen 


*a. Merge time-varying information at t from hhmem.dta
merge m:1 caseid year using "${pdata}/hhmem.dta", keep(1 3) nogen 


* rename the merged variables to indicate they contain info at t
for any numspptr relspptr marstat hgc hgcrev: rename X X_t
		
		
*b. Rename the variables merge from hhmem.dta to *_t		
for any spousage spousgen spousgrade partage partgen partgrade: rename X X_t


* rename original year to generate new year variable=year of child's birth (+1)
rename year year_old 
gen year=cyrb       
replace year=cyrb+1 if year==1995 | year==1997 | year==1999 | year==2001 ///
                     | year==2003 | year==2005 | year==2007 | year==2009 ///
					 | year==2011 | year==2013 // for years w/o data collection

sort caseid year
merge m:1 caseid year using "${pdata}/myearly.dta", keep(1 3) nogen 


*c. Merge time-varying information from around birth from hhmem.dta
merge m:1 caseid year using "${pdata}/hhmem.dta", keep(1 3) nogen 


* restore original year variable
drop year
rename year_old year


* rename the merged variables to indicate they contain info at/around birth
for any numspptr relspptr marstat hgc hgcrev: rename X X_b 


*d. Rename the variables merged from hhmem.dta to *_b
for any spousage spousgen spousgrade partage partgen partgrade: rename X X_b


*e. Sort data by child ID and year
sort caseid year


*f. Save data as combi.dta in your procdata folder
saveold "${pdata}/combi.dta", version(12) replace 


*==============================================================================*
