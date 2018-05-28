/*==============================================================================
File name:    hw05.do
Task:         Homework 5
Project:      Research seminar pt. 1
Author:       YOURNAMEHERE                                                                            
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



/*------------------------------------------------------------------------------
#2 Egen and sample variables

Additional tasks:
a. Repeat the commands below for the other child assessments (recog, comp, bpi).
   Note that the correct age variable for bpi is msage_yr and that children
   are aged 4-13 for this assessment. 
b. Check how many children there are in each sample.
------------------------------------------------------------------------------*/

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

	 
*==============================================================================*
