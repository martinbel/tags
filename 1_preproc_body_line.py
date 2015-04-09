import pandas as pd
import csv

tags = pd.read_csv('keep_tags.csv', sep='|')

# Convert from R to Python Index (starting from 1 to starting from 0)
keep_tags_index = list(tags.keep_tags.values - 1)

ifile  = open('bd.csv', "rb")
reader = csv.reader(ifile)

ofile  = open('bd_out.csv', "wb")
writer = csv.writer(ofile)

rownum = 0
for row in reader:
    if rownum in keep_tags_index:
        print row, rownum
        writer.writerow([row])
    else:
        pass
    rownum += 1

ifile.close()
ofile.close()


