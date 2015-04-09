# ### Filter body - Taking ages...
# 
# out_df <- data.frame(text="0")
# write.table(out_df, file='keep_body.csv', append=F, col.names = T, row.names=F, sep='|')
# 
# file_name <- '../tags/data/body.csv'
# con <- file(file_name, "r")
# 
# i = 1
# while (length(row <- readLines(con, n = 1)) > 0) {
#   if(i %in% top_tags_index){
#     # write row with tag in file
#     try(write.table(row, file='keep_body.csv', append=T, row.names=F,
#                       col.names = F, sep='|'), silent=T)
#     # print progress
#     if( (i %% 100) == 0) {
#       print(sprintf("iter: %s", i))
#       print('body:')
#       print(row)
#       gc()
#     }
#   }
#   i = i + 1
# }
# close(con)
# 





# compute the number of rows in the file: 
# system('wc -l ../tags/data/body.csv')
max_n <- 24120523
inx_read_body <- c(seq(0, max_n, 5e6), max_n)

body_keep <- list()
for(i in 1:4){
	skip = inx_read_body[i]
	nrows = inx_read_body[i+1]
	body <- read.table('../tags/data/body.csv', row.names=T, sep='\t',
		nrows=nrows, skip=skip, colClasses='character')

	body_keep[[i]] <- body[]



	gc()
}


skip = inx_read_body[1]
nrows = inx_read_body[1+1]
chunk_inx <- top_tags_index[top_tags_index > skip & top_tags_index < nrows]

body <- read.table('../tags/data/body.csv', row.names=T, sep='\t',
		nrows=nrows, skip=skip, colClasses='character')

body <- fread('../tags/data/body.csv', nrows=nrows, skip=skip, colClasses='character' )


Error in scan(file, what, nmax, sep, dec, quote, skip, nlines, na.strings,  : 
  line 475132 did not have 2 elements