
# Code usage

## File preprocessing

1) Run cut_script.sh in the terminal: 
This will generate a file for the tags, title and body
called tags.csv, title.csv and body.csv. It will also output the tail of the body, 
in a file called body_tail.csv.

2) Run read_cut.R in order to find the relevant tags for modelling, and keep the
titles and body that match those tags.
- At line 41 and 52, the script reads a 10 GB chunk of the body.csv file in memory. 
I've done it this way in order to meet the deadline. An iterative script was taking too long.
This is done just to output a dataset with the common tags and it's respective body.
There is an alternative script (slower) called 1_preproc_body_line.py that should do the job if you
have memory constraints. There is an R version for a similar task: 1_read_large.R

## Model preprocessing
Run 2_preproc.R
- The script reads the model.csv file and creates bag of words with the corpus

## Modelling
Run 3_model.R
1) Runs a Multinomial lasso logistic regression
2) Generates the metrics: precision, recall and f1 score for each lambda
3) Generates predictions using the lambda that outputs the best f1 score in average for all tags