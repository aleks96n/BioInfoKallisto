library("ggplot2")

hisat <-  read.csv("<comparison_file.tsv>", sep = '\t', header = TRUE)
kallista <- read.csv("<kallisto.tsv>", sep = '\t', header = TRUE)

hisat$p_beta = p.adjust(hisat$p_beta, method = "fdr")
kallista$p_beta = p.adjust(kallista$p_beta, method = "fdr")

hisat_with_threshold <- subset(hisat, p_beta < 0.05)
kallista_with_threshold <- subset(kallista, p_beta < 0.05)

merged <- merge(x = hisat_with_threshold, y = kallista_with_threshold, by = "molecular_trait_object_id", all = FALSE)
merged <- merged[,c("molecular_trait_object_id", "p_beta.x", "p_beta.y")]
colnames(merged)[colnames(merged) == 'p_beta.x'] <- 'p_hisat'
colnames(merged)[colnames(merged) == 'p_beta.y'] <- 'p_kallista'

ggplot(merged, aes(x = -log(p_hisat, 10), y = -log(p_kallista,10))) + geom_point()
