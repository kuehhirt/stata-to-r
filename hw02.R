# =============================================================================
#   File name:    hw02sol.do
# Task:         Homework 2 solution
# Project:      Research seminar pt. 1
# Author:       Michael Kuehhirt
# =============================================================================

   
# ----------------------------------------------------------------------------- 
#   About this do-file:
#   #1 Demonstrates how to define global variables 
#   #2 Demonstrates how to check global variables
#   #3 Demonstrates how to use global variables
#   #4 TASKS
# -----------------------------------------------------------------------------
 
 
# -----------------------------------------------------------------------------
# Notes:
# - Space for notes/remarks/questions/todos -
# -----------------------------------------------------------------------------
   
  
# -----------------------------------------------------------------------------
# 1) Define global variables
# Global variables are defined by
# - giving the variable a name you choose   
# - and assigning content to this variable
# use <- followed by numbers to assign values to a variable
# use <- followed by "content" to assign strings to variable 
# - example: exp <- 10, exp <-  "example" 

# Anything from path names to other variable names or values can be put into a 
# global variables. This makes them very useful if specific phrases (like path 
# names) are repeatedly used in your scripts, because you only have to write the 
# full phrase once (when defining the global variable).
# 
# In the following, we will define 3 different globals.
# -----------------------------------------------------------------------------
#   
iamaglobal <- "This"              
iamanotherglobal <- "is"
iamaglobaltoo <- "a sentence."

sentenceglobal <- paste(iamaglobal, iamanotherglobal, iamaglobaltoo, sep = " ") 
# converts arguments to character strings and concantenates them by the string 
# given by sep 

# -----------------------------------------------------------------------------
# #2 Check globals
# You can check all globals at once or single globals using the display command.
# For the latter, you write disp followed by $globalname in " marks.
# -----------------------------------------------------------------------------

ls()                      # lists all variables in the global environment
print(iamaglobal)         # displays content of first global
print(iamanotherglobal)   # displays content of second global
print(iamaglobaltoo)      # displays content of third global
print(sentenceglobal)     # displays complete sentence 

# -----------------------------------------------------------------------------
# #3 Use variables
# Globals can be activated by typing variable's name. 
# 
# In this way, globals can be used in combination with Stata commands, like 
# above, with print. R also returns the content of the variables by just typing 
# the name of the variable.
# Variables can even be used in combination with the command that defines 
# variables.
# -----------------------------------------------------------------------------
# 
# Define new variable with content "I am a sentence." using 3 globals above.
iamanewglobal <- paste(iamaglobal, iamanotherglobal, iamaglobaltoo, sep = " ") 
# paste() converts arguments to character strings and concantenates them by the string 
# given by sep(" ")

# Display the content of this global
print(iamanewglobal)

# Note that this is how we defined the path globals in the master do-file
print(wdir)
print(code)

# We can also combine globals with non-globals in commands
print(paste(iamaglobal, iamanotherglobal, "another sentence."))
# 
# 
# -----------------------------------------------------------------------------
# #4 TASKS
# 0. Insert your name in line 5 above.
# a. Define a global containing your first name!
# b. Define a global containing your last name!
# c. Define a global containing your first and last name using the 2 globals 
# above!
# d. Display the global containing your first name!
# e. Display the global containing your full name!
# f. Display "I am YOURFIRSTNAMEHERE YOURLASTNAMEHERE." using the third global!
# g. Display "I am YOURFIRSTNAMEHERE YOURLASTNAMEHERE." using the first and 
# second globals!
# h. Display the path for your working directory!
# i. Display the path to your figures folder!
# -----------------------------------------------------------------------------
# 
fname <- "Michael"                                     # a.
lname <- "Kuehhirt"                                    # b.
name <- paste(fname ,lname )                           # c.
fname                                                  # d.
name                                                   # e.
print(paste("I am",name))                              # f.
print(paste("I am",fname, lname, ".") )                # g.
wdir                                                   # h.
plots                                                  # i.