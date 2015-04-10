
# Code usage

## File preprocessing

1) Run cut_script.sh in the terminal: 
This will generate a file for the tags, title and body
called tags.csv, title.csv and body.csv. It will also output the tail of the body, 
in a file called body_tail.csv.

2) Run read_cut.R in order to find the relevant tags for modelling, and keep the
titles and body that match those tags.

## Model preprocessing
Run 2_preproc.R
- The script reads the model.csv file and creates bag of words with the corpus

## Modelling
Run 3_model.R
1) Runs a Multinomial lasso logistic regression
2) Generates the metrics: precision, recall and f1 score for each lambda
3) Generates predictions using the lambda that outputs the best f1 score in average for all tags