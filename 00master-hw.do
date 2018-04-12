/*==============================================================================
File name:    00master-hw.do
Task:         Setup and execution of scripts for homework assignments
Project:      Research seminar pt. 1
Author:       YOUR NAME                                                                                   
==============================================================================*/


/*------------------------------------------------------------------------------ 
About this do-file:

#1 Installs user-written ado-files
#2 Basic Stata specifications
#3 Sets up globals for folder directories
#4 Order and execution of project do-files
------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------
Notes:

This do-file needs to be executed before any of the homework-specific do-files
are used for the first time!

 - More space for notes/remarks/questions/todos -
------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------
#1 Install user-written ado-files

This section installs several useful Stata commands that are not part of the
original Stata version but are contributed by different Stata users.

Once they have been installed you can deactivate renewed installation by putting
a * in front of each line.
------------------------------------------------------------------------------*/

ssc install blindschemes, replace // Color scheme for plots
ssc install estout, replace       // Formatting and exporting tables
ssc install coefplot, replace     // Formatting and exporting output as plot

net from http://digital.cgdev.org/doc/stata/MO/Misc
net install grc1leg2, replace     // Combining multiple plots


/*------------------------------------------------------------------------------
#2 Basic Stata specifications
------------------------------------------------------------------------------*/

version 12.0         // Stata version control
clear all            // clear memory
macro drop _all      // delete all macros
set linesize 82      // result window has room for 82 characters in one line
set more off         // prevents pause in results window
set scheme plotplain // sets color scheme for graphs


/*------------------------------------------------------------------------------
#3 Define globals for folder directories

These globals will be used throughout the class as shortcuts to your different
project folders. This aides script-based loading and saving of data, running of
do-files, and export of output.

You only need to adapt the path for the working directory (wdir). Globals to the
folders within the working directory will be adapted automatically
------------------------------------------------------------------------------*/

* working directory (paste the path to your own wdir between the " " below)
global wdir "/Users/wmb222/Dropbox/Arbeit/Lehre/child_development/2018S/wdir"


global odata "$wdir/01source/origdata"  // path to original data
global pdata "$wdir/02process/procdata" // path to processed data
global code  "$wdir/02process/code"     // path to do-files
global cbook "$wdir/03docu/codebooks"   // path to codebooks
global plots "$wdir/03docu/figures"     // path to figures
global texts "$wdir/03docu/tables"      // path to logfiles and tables


/*------------------------------------------------------------------------------
#4 Execute task-specific do-files in the correct order

Once these do-files are completed you can remove the * in the front. Running
this master do-file will then also execute the do-files below in the order
they are listed. Try it for the first one, when you're finished with Homework 2!
------------------------------------------------------------------------------*/

*do "${code}/hw02.do"           // Homework 2
*do "${code}/hw03.do"           // Homework 3
*do "${code}/hw04.do"           // Homework 4
*do "${code}/hw05.do"           // Homework 5
*do "${code}/hw06.do"           // Homework 6
*do "${code}/hw07.do"           // Homework 7


*==============================================================================*
