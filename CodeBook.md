# The CodeBook

All transformations of the data are described in the script, which merges a number of files to create the single tidy dataset. Please read the README.md file in this repository for the project description.

Please read the README.txt file in the downloaded content for a description of the files to be merged into the tidy dataset.

*readBaseSet*: This function reads files beginning with X, essentially to load the training and test datasets.

*rAdditionalFile*: This function reads files to be used for the subjects and labels.   

*correctFeatureName*: This function removes unwanted parentheses to create a tidier data frame. 

The remaining functions within the script merge the individual datasets to create the required tidy dataset.

