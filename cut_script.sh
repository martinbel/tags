cut -f1,11 -s Posts.xml.csv > body.csv
cut -f3 -s Posts.xml.csv > title.csv
cut -f12 -s Posts.xml.csv > tags.csv

tail -10000000 body.csv > body_tail.csv


// test
// cut -f1,11 -s Posts.xml.csv | head -10000 > bd.csv


