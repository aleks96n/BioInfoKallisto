library(dplyr) 

getwd()
setwd("")

tsv_file <- read.table("metadata.tsv", header = TRUE)
filtered <-  filter(tsv_file, chromosome %in% 1:22)

filtered <- as.data.frame.matrix(filtered)

write.table(filtered, file = "phenotype_metadata_converted.tsv", sep = "\t", quote = FALSE, row.names = FALSE)
