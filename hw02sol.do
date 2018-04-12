/*==============================================================================
File name:    hw02sol.do
Task:         Homework 2 solution
Project:      Research seminar pt. 1
Author:       Michael Kuehhirt
==============================================================================*/


/*------------------------------------------------------------------------------ 
About this do-file:

#1 Demonstrates how to define globals
#2 Demonstrates how to check globals
#3 Demonstrates how to use globals
#4 TASKS
------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------
Notes:

- Space for notes/remarks/questions/todos -
------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------
#1 Define globals

Globals are defined 
 - using the command global 
 - followed by the name you choose for a given global
 - and finally, writing down the global content (between " ").
 
Anything from path names to variable names can be put into a globals. This makes
them very useful if specific phrases (like path names) are repeatedly used in 
your do-files, because you only have to write the full phrase once (when 
defining the global).
 
In the following, we will define 3 different globals.
------------------------------------------------------------------------------*/

global iamaglobal "This"
global iamanotherglobal "is"
global iamaglobaltoo "a sentence."


/*------------------------------------------------------------------------------
#2 Check globals

You can check all globals at once or single globals using the display command.
For the latter, you write disp followed by $globalname in " marks.
------------------------------------------------------------------------------*/

macro dir                // Lists all active globals and their content.
disp "$iamaglobal"       // displays content of first global
disp "$iamanotherglobal" // displays content of second global
disp "$iamaglobaltoo"    // displays content of third global


/*------------------------------------------------------------------------------
#3 Use globals

Globals can be activated by 
 - writing $
 - followed by the global name.
 
In this way, globals can be used in combination with Stata commands, like above,
with display.

Globals can even be used in combination with the command that define globals.
------------------------------------------------------------------------------*/

* Define new global with content "I am a sentence." using 3 globals above.
global iamanewglobal "$iamaglobal $iamanotherglobal $iamaglobaltoo"

* Display the content of this global
disp "$iamanewglobal"

* Note that this is how we defined the path globals in the master do-file
disp "$wdir"
disp "$code"

* We can also combine globals with non-globals in commands
disp "$iamaglobal $iamanotherglobal another sentence."


/*------------------------------------------------------------------------------
#4 TASKS

0. Insert your name in line 5 above.
a. Define a global containing your first name!
b. Define a global containing your last name!
c. Define a global containing your first and last name using the 2 globals 
   above!
d. Display the global containing your first name!
e. Display the global containing your full name!
f. Display "I am YOURFIRSTNAMEHERE YOURLASTNAMEHERE." using the third global!
g. Display "I am YOURFIRSTNAMEHERE YOURLASTNAMEHERE." using the first and second
   globals!
h. Display the path for your working directory!
i. Display the path to your figures folder!
------------------------------------------------------------------------------*/

global fname "Michael"       // a.
global lname "Kuehhirt"      // b.
global name "$fname $lname"  // c.
disp "$fname"                // d.
disp "$name"                 // e.
disp "I am $name."           // f.
disp "I am $fname $lname."   // g.
disp "$wdir"                 // h.
disp "$plots"                // i.


*==============================================================================*
