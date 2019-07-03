# Project3
codebook, script, tidy_data and readme file for project 3
For the Week 4 Project Assignment, I downloaded the data found at the referenced website (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zipfollowing) on  6/28/19.

I initially examined the data using a text editor - but several were gibberish.  

Reading the files into R allowed me to examine them all.

Based on the names of the files and their dimensions as well as the data contained in them I was able to deduce their contents.  

Specifically to do this assignment I used the data in:

The "subject_test.txt" and subject_train" files to get the identity (as an integer) of the subject for each of the lines in the text and train databases

  The actual data for test and train subjects was found in the X_test.txt and X_train.txt files

  The filenames were found in the features.txt file

  The activity "code" for each row in the test and train databases was found in the Y-test.txt and Y-train files

  The translation of activity code to activity name was found in the activity_labels.txt file.
  
  Note since the assignment was to look at means and stds of the data, it was not necessary to use the "raw" data in the Inertial Signals subdirectories
  
  The program run.analysis.R does the following
    
    loads the required libraries
    
    downloads the zip file from the internet (I believe the instructions call for the program to read the files from a directory, I chose to go to the internet instead.  To elimiante this step, you could comment out lines 17 and 18.
    
    Uses unzip to develop a list of the files that were downloaded (I did this just to make the read.table commands a little easier to type)
    
    Uses unzip and read.table to read each of the required files.
    
    The data, that is read from X_test.txt and X_train.txt) was then combined (using rbind) to create all_data.  An implicit assumption is that the variables are in the same order in both datasets - I tihnk this is reasonable since the variable names were given in a file that was contained in the master directory.
    
    I then added the column names from features.txt (using colnames) - again assuming that they are in the same order as in the two data sets.  I added the column names at this point since I next column bind the information for activities and subjects and thought it would be more straighforward to bind the data with the column names already added rather than having to add the names after the binding.
    
    I then used grep to selected the column names that have either the word "M/mean" or "S/std" in them.  I then used this vector so subset all_data to selected_ data.  Note it was a bit unclear to em from the instructions which variables we shoudl focus on - so given the fact that we had just learned grep, it seemed like this was a reasoanble way to go.
    
    I then row binded the subject and activity data for the two databases and added column names and bound them (using column bind) to the selected_data.
   
   I then used a for loop to change the activty integer codes to the actual activty names using the equivalencies from the activity_labels.txt file
   
   I then tried to make some of the variables names a little more "user friendly" by using gsub to expand on some of the abbreviaitons in the titles.  Frankly, the variable names are still confusing to me - but I was unable to find additional information to allow me to further clarify.
   
   To calculate the average for each combination of activity and subject, I melted the data along activity and subject, and used ddply calling summarize and mean.
   
   I used spread to reassemble the results into a 2-D database (I have a commenbted out line of code that uses acast to generate a 3-D version - not sure if 2D or 3D is "tidier")
   
   Finally I write the results to the directory where I originally saved the zipped files using write.table.
  
