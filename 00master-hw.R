# ============================================================================
# File name:    00master-hw.R
# Task:         Setup and execution of scripts for homework assignments
# Project:      Research seminar pt. 1
# Author:       YOUR NAME
# =============================================================================

#https://dss.princeton.edu/training/RStata.pdf
# -----------------------------------------------------------------------------
# About this script:
#   1) Installs user-written ado-files
#   2) Basic R specifications
#   3) Sets up globals for folder directories
#   4) Order and execution of project do-files
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Notes:

# This script needs to be executed before any of the homework-specific scripts
# are used for the first time!
# 
# - More space for notes/remarks/questions/todos -
# to set line width: Tools -> Global Options -> Code -> Display
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# 1) Install user-written packages

# This section installs several useful R commands that are not part of the
# original R version but are contributed by different R users.

# Once they have been installed you can deactivate renewed installation by 
# putting a '#' in front of each line.
# -----------------------------------------------------------------------------

# install (Gibt es eine Option, die die Install. ausführt, ohne dass man bestätigen muss?)
 install.packages("readstata13")   # read Stata 13 or newer into R
 install.packages("foreign")     # read Stata 12 or older

# load   
 library(readstata13)
 library(foreign)

#------------------------------------------------------------------------------
# 2) Basic R specifications 
# -----------------------------------------------------------------------------
R.Version()                       # check version 
rm(list=ls(all=TRUE))             # remove all defined variables 

# -----------------------------------------------------------------------------
# 3) Define global variables for folder directories
# 
# When starting R, the gloabl environment is created. In this environment we can 
# define variables call global variables. They can always be assessed by just 
# typing their name. In contrast, local variables can only be asseessed in a 
# certain part of the program, for example a function. 
# Our global variables will be used throughout the class as shortcuts to your 
# different project folders. This aides script-based loading and saving of data,
# running of scripts, and export of output.
# 
# You only need to adapt the path for the working directory (wdir). Global 
# variables to the folders within the working directory will be adapted 
# automatically.
# -----------------------------------------------------------------------------

# working directory (paste the path to your own wdir between the " " below)
# wdir <- file.path("H:","R","wdir") # Maike's path
wdir <- file.path("/Users","wmb222","Documents","stata-to-r") # Michael's path

# file.path contructs the path by concantenating the elements in brackets.
# (will be correct no matter which operating system you are using) 

odata <- file.path(wdir, "01source", "origdata")  # path to original data 
pdata <- file.path(wdir,"02process", "procdata")  # path to processed data
code <- file.path(wdir, "02process", "code")      # path to R scripts
cbook <- file.path(wdir, "03docu", "codebooks")   # path to codebooks 
plots <- file.path(wdir, "03docu", "figures")     # path to figures
texts <- file.path(wdir, "03docu", "tables")      # path to logfiles and tables

# -----------------------------------------------------------------------------
# 4) Execute task-specific scripts in the correct order
# Once these scripts are completed you can remove the  in the front. Running
# this master script will then also execute the scripts below in the order
# they are listed. Try it for the first one, when you're finished with 
# Homework 2!
# -----------------------------------------------------------------------------

source(file.path(code, "hw02.R"))      # homework 2
# source(file.path(code, "hw03.R"))      # homework 3
# source(file.path(code, "hw04.R"))     # homework 4
# source(file.path(code, "hw05.R"))    # homework 5
# source(file.path(code, "hw06.R"))      # homework 6
# source(file.path(code, "hw07.R"))     # homework 7

