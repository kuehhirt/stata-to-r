/*==============================================================================
File name:    hw05sol.do
Task:         Homework 5 solution
Project:      Research seminar pt. 1
Author:       Michael Kuehhirt                                                                            
==============================================================================*/


/*------------------------------------------------------------------------------ 
About this dofile:

#1 Dropping observations
#2 Egen and sample variables
#3 Keeping observations
------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------
Notes:
------------------------------------------------------------------------------*/

version 12.0      // Stata version control


/*------------------------------------------------------------------------------
#1 Dropping observations

Tasks:
a. Load the dataset clean1.dta
b. Drop all observations from before the child was born
------------------------------------------------------------------------------*/

use "${pdata}/clean1.dta", clear


drop if year<=cyrb // delete lines before birth of child


/*------------------------------------------------------------------------------
#2 Egen and sample variables

Additional tasks:
a. Repeat the commands below for the other child assessments (recog, comp, bpi).
   Note that the correct age variable for bpi is msage_yr and that children
   are aged 4-13 for this assessment. 
b. Check how many children there are in each sample.
------------------------------------------------------------------------------*/

*** math
* year of first nonmissing assessment
bysort cpubid: egen auxmath=min(year) if math<. & csage_yr>=5
bysort cpubid: egen math_yf=max(auxmath)
drop auxmath
	
* total number of assessments
bysort cpubid: egen auxmath=count(year) if math<. & csage_yr>=5   ///
                                                  & csage_yr<=14
bysort cpubid: egen math_N=max(auxmath)
drop auxmath
	
* number of nonmissing assessment
sort cpubid year
bysort cpubid: gen auxmath_n=_n if math<. & csage_yr>=5  ///
                                          & csage_yr<=14
sort cpubid auxmath
bysort cpubid: gen math_n=_n if auxmath<.
drop auxmath

* age at first nonmissing assessment 
gen auxmath = csage_yr if math_n==1
bysort cpubid: egen math_af=max(auxmath)
drop auxmath
	
* age eligible for first assessment
bysort cpubid: egen math_ae = min(csage_yr) if csage_yr>=5 & csage_yr<=14

* number of missing values on assessment and covariates
egen miss_math=rowmiss(math csex cyrb crace hgcrev_b famstr_b) 
	
* first year with missing after age eligibility
bysort cpubid: egen auxmath=min(year) if miss_math>0 & miss_math<. & year>=math_yf
bysort cpubid: egen yrfmiss_math=min(auxmath)
drop auxmath
gen cens_math=0 if year<yrfmiss_math-2 | year==yrfmiss_math-2 & csage_yr==14
replace cens_math=1 if year==yrfmiss_math-2 & csage_yr<14                 


* sample for population of interest (= children w/ 5 potential assessments)
gen sampleA_math=1 if cyrb>=1981 & cyrb<=2000        /// born 1981-2000
                  & csage_yr>=5 & csage_yr<=14       //  age at assessment
					       
* subsample that was first assessed at age elligible
gen sampleB_math=1 if sampleA_math==1 & math_ae==math_af 
	
* subsample of child-years before attrition
gen sample1_math=1 if sampleB_math==1 & year<=yrfmiss_math-2 & math_n<6

* subsample of children with 5 assessments
gen sample2_math=1 if sample1_math==1 & math_N>=5 & math_N<.


*** recog
* year of first nonmissing assessment
bysort cpubid: egen auxrecog=min(year) if recog<. & csage_yr>=5
bysort cpubid: egen recog_yf=max(auxrecog)
drop auxrecog
	
* total number of assessments
bysort cpubid: egen auxrecog=count(year) if recog<. & csage_yr>=5   ///
                                                  & csage_yr<=14
bysort cpubid: egen recog_N=max(auxrecog)
drop auxrecog
	
* number of nonmissing assessment
sort cpubid year
bysort cpubid: gen auxrecog_n=_n if recog<. & csage_yr>=5  ///
                                          & csage_yr<=14
sort cpubid auxrecog
bysort cpubid: gen recog_n=_n if auxrecog<.
drop auxrecog

* age at first nonmissing assessment 
gen auxrecog = csage_yr if recog_n==1
bysort cpubid: egen recog_af=max(auxrecog)
drop auxrecog
	
* age eligible for first assessment
bysort cpubid: egen recog_ae = min(csage_yr) if csage_yr>=5 & csage_yr<=14

* number of missing values on assessment and covariates
egen miss_recog=rowmiss(recog csex cyrb crace hgcrev_b famstr_b) 
	
* first year with missing after age eligibility
bysort cpubid: egen auxrecog=min(year) if miss_recog>0 & miss_recog<. & year>=recog_yf
bysort cpubid: egen yrfmiss_recog=min(auxrecog)
drop auxrecog
gen cens_recog=0 if year<yrfmiss_recog-2 | year==yrfmiss_recog-2 & csage_yr==14
replace cens_recog=1 if year==yrfmiss_recog-2 & csage_yr<14                 


* sample for population of interest (= children w/ 5 potential assessments)
gen sampleA_recog=1 if cyrb>=1981 & cyrb<=2000        /// born 1981-2000
                  & csage_yr>=5 & csage_yr<=14       //  age at assessment
					       
* subsample that was first assessed at age elligible
gen sampleB_recog=1 if sampleA_recog==1 & recog_ae==recog_af 
	
* subsample of child-years before attrition
gen sample1_recog=1 if sampleB_recog==1 & year<=yrfmiss_recog-2 & recog_n<6

* subsample of children with 5 assessments
gen sample2_recog=1 if sample1_recog==1 & recog_N>=5 & math_N<.


*** comp
* year of first nonmissing assessment
bysort cpubid: egen auxcomp=min(year) if comp<. & csage_yr>=5
bysort cpubid: egen comp_yf=max(auxcomp)
drop auxcomp
	
* total number of assessments
bysort cpubid: egen auxcomp=count(year) if comp<. & csage_yr>=5   ///
                                                  & csage_yr<=14
bysort cpubid: egen comp_N=max(auxcomp)
drop auxcomp
	
* number of nonmissing assessment
sort cpubid year
bysort cpubid: gen auxcomp_n=_n if comp<. & csage_yr>=5  ///
                                          & csage_yr<=14
sort cpubid auxcomp
bysort cpubid: gen comp_n=_n if auxcomp<.
drop auxcomp

* age at first nonmissing assessment 
gen auxcomp = csage_yr if comp_n==1
bysort cpubid: egen comp_af=max(auxcomp)
drop auxcomp
	
* age eligible for first assessment
bysort cpubid: egen comp_ae = min(csage_yr) if csage_yr>=5 & csage_yr<=14

* number of missing values on assessment and covariates
egen miss_comp=rowmiss(comp csex cyrb crace hgcrev_b famstr_b) 
	
* first year with missing after age eligibility
bysort cpubid: egen auxcomp=min(year) if miss_comp>0 & miss_comp<. & year>=comp_yf
bysort cpubid: egen yrfmiss_comp=min(auxcomp)
drop auxcomp
gen cens_comp=0 if year<yrfmiss_comp-2 | year==yrfmiss_comp-2 & csage_yr==14
replace cens_comp=1 if year==yrfmiss_comp-2 & csage_yr<14                 


* sample for population of interest (= children w/ 5 potential assessments)
gen sampleA_comp=1 if cyrb>=1981 & cyrb<=2000        /// born 1981-2000
                  & csage_yr>=5 & csage_yr<=14       //  age at assessment
					       
* subsample that was first assessed at age elligible
gen sampleB_comp=1 if sampleA_comp==1 & comp_ae==comp_af 
	
* subsample of child-years before attrition
gen sample1_comp=1 if sampleB_comp==1 & year<=yrfmiss_comp-2 & comp_n<6

* subsample of children with 5 assessments
gen sample2_comp=1 if sample1_comp==1 & comp_N>=5 & comp_N<.


***BPI
* year of first nonmissing assessment
bysort cpubid: egen auxbpi=min(year) if bpi<. & msage_yr>=4
bysort cpubid: egen bpi_yf=max(auxbpi)
drop auxbpi
	
* total number of assessments
bysort cpubid: egen auxbpi=count(year) if bpi<. & msage_yr>=4   ///
                                                & msage_yr<=13
bysort cpubid: egen bpi_N=max(auxbpi)
drop auxbpi
	
* number of nonmissing assessment
sort cpubid year
bysort cpubid: gen auxbpi_n=_n if bpi<. & msage_yr>=4  ///
                                        & msage_yr<=13
sort cpubid auxbpi
bysort cpubid: gen bpi_n=_n if auxbpi<.
drop auxbpi

* age at first nonmissing assessment 
gen auxbpi = msage_yr if bpi_n==1
bysort cpubid: egen bpi_af=max(auxbpi)
drop auxbpi
	
* age eligible for first assessment
bysort cpubid: egen bpi_ae = min(msage_yr) if msage_yr>=4 & msage_yr<=13

* number of missing values on assessment and covariates
egen miss_bpi=rowmiss(bpi csex cyrb crace hgcrev_b famstr_b) 
	
* first year with missing after age eligibility
bysort cpubid: egen auxbpi=min(year) if miss_bpi>0 & miss_bpi<. & year>=bpi_yf
bysort cpubid: egen yrfmiss_bpi=min(auxbpi)
drop auxbpi
gen cens_bpi=0 if year<yrfmiss_bpi-2 | year==yrfmiss_bpi-2 & msage_yr==13
replace cens_bpi=1 if year==yrfmiss_bpi-2 & msage_yr<13                 


* sample for population of interest (= children w/ 5 potential assessments)
gen sampleA_bpi=1 if cyrb>=1981 & cyrb<=2000        /// born 1981-2000
                  & msage_yr>=4 & msage_yr<=13       //  age at assessment
					       
* subsample that was first assessed at age elligible
gen sampleB_bpi=1 if sampleA_bpi==1 & bpi_ae==bpi_af 
	
* subsample of child-years before attrition
gen sample1_bpi=1 if sampleB_bpi==1 & year<=yrfmiss_bpi-2 & bpi_n<6

* subsample of children with 5 assessments
gen sample2_bpi=1 if sample1_bpi==1 & bpi_N>=5 & bpi_N<.


/*------------------------------------------------------------------------------
#3 Keeping observations

Additional tasks:
a. Keep the observations that are at least in one of the samples A
b. Sort the data by child ID and year
c. Save the data as clean2.dta in your procdata folder. To use the data in 
   Stata 12 use the saveold command with the option v(12).
------------------------------------------------------------------------------*/

keep cpubid year caseid *math* *comp* *recog* *bpi* csage* msage* agech*    ///
     btime mdrug lbweight malc* msm* famstr_t partgrade_t_cat cbwght        ///
	 spousgrade_t_cat hgcrev_t_cat partgrade_b_cat spousgrade_b_cat         ///
	 hgcrev_b_cat cmale fstbrn arace ayrb cbrstfd famstr_b crace csex cyrb  ///
	 ayrb hgcrev_b_cat* asex
	 
drop *_yf *_af *_ae	*miss_* mathp mathz recogz recogp compp compz bpintr comply

	 
keep if sampleA_math==1 | sampleA_comp==1 | sampleA_recog==1 | sampleA_bpi==1



sort cpubid year


saveold "${pdata}/clean2.dta", replace v(12)


*==============================================================================*
