### I haven't used this script because of time constraints
# I have however tested it to work properly. 
# It outputs a body_out.csv file that should have the body that
# corresponds to the common tags that will be used in the model

import pandas as pd
import csv

# This file has the index of the tags we want to keep from the large file
tags = pd.read_csv('../tags/data/keep_tags.csv', sep='|')

# Convert from R to Python Index (starting from 1 to starting from 0)
keep_tags_index = list(tags.keep_tags.values - 1)

ifile  = open('body.csv', "rb")
reader = csv.reader(ifile)

# This should have the same length as the tags DataFrame
ofile  = open('body_out.csv', "wb") 
writer = csv.writer(ofile)

rownum = 0
for row in reader:
	# Test if the row number is equal to the index
    if rownum in keep_tags_index:
        print row, rownum
        # write it to our file
        writer.writerow([row])
    else:
        pass
    rownum += 1

ifile.close()
ofile.close()


