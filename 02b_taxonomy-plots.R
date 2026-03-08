#STEP 4: Visualising Bracken reports using R.
#Input: combined, genus-level Bracken abundance.
#Output: stacked bar plot of relative abundance, PCoA plot, PERMANOVA.
#Please note: The code as detailed below was ran inside the Linux terminal (using bash).

R
install.packages("dplyr")
install.packages("tidyverse")
install.packages("ggplot2")
install.packages("vegan")

#The genus-level combined Bracken abundance table was imported and its dimensions/columns/column names checked.
genus <- read.table("all_genus_num.bracken", header = TRUE, sep = "\t", check.names = FALSE)
dim(genus)
head(genus[,1:5])
colnames(genus)

#The ending "_genus\\.bracken_num$" was removed from all column names to make downstream analyses easier.
#To achieve this, the function gsub was used (https://www.geeksforgeeks.org/r-language/replace-all-the-matches-of-a-pattern-from-a-string-in-r-programming-gsub-function/).
sample_cols <- setdiff(colnames(genus), "name")
clean_names <- gsub("_genus\\.bracken_num$", "", sample_cols)
colnames(genus)[colnames(genus) %in% sample_cols] <- clean_names

#Raw abundances were then converted to relative abundances (so that they are expressed as relative proportions of the whole sample).
genus_rel <- genus
genus_rel[, sample_cols] <- genus_rel[, sample_cols] / colSums(genus_rel[, sample_cols])

#The top 15 most abundant genera were identified by calculating the mean relative abundance across all the samples. All remaining genera (that did not fall in the 'top 15') were classified as "Other".
genus_rel$mean_abund <- rowMeans(genus_rel[, sample_cols])

topN <- 15
top_taxa <- genus_rel[order(genus_rel$mean_abund, decreasing = TRUE), "name"][1:topN]
genus_rel$taxon_group <- ifelse(genus_rel$name %in% top_taxa, genus_rel$name, "Other")

genus_sub <- genus_rel[, c("taxon_group", sample_cols)]
genus_rel2 <- aggregate(. ~ taxon_group, data = genus_sub, FUN = sum)

#To make plotting with ggplot2 easier/possible, the data was converted from wide format to long format (https://stackoverflow.com/questions/64390747/ggplot-why-do-i-have-to-transform-the-data-into-the-long-format).
#For this purpose, the function pivot_longer was used (https://library.virginia.edu/data/articles/reshaping-data-from-wide-to-long).
plot_df <- pivot_longer(genus_rel2, cols = -taxon_group, names_to = "sample", values_to = "rel_abund")

#Samples were then grouped by time-point (samples collected before exposure to diet - "pre", samples collected 3 months on the diet - "post") and by weight loss ("high" or "low").
#Here, grepl was used (https://www.geeksforgeeks.org/r-language/difference-between-grep-vs-grepl-in-r/).
plot_df$time <-ifelse(grepl("_pre_", plot_df$sample), "pre", "post")
plot_df$wl <- ifelse(grepl("_high$", plot_df$sample), "high", "low")

library(ggplot2)
ggplot(plot_df, aes(x = sample, y = rel_abund, fill = taxon_group)) + geom_col() + facet_grid(wl ~ time, scales = "free_x", space = "free_x") + theme_bw() + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) + labs(x = "Sample", y = "Relative abundance", fill = "Genus")

library(vegan)
genus_bca2 <- read.table("all_genus_num.bracken", header = TRUE, sep = "\t", check.names = FALSE)
rownames(genus_bca2) <- genus_bca2$name
genus_mat <- as.matrix(genus_bca2[, -1])

dim(genus_mat)

genus_rel2 <- genus_mat / colSums(genus_mat)

bray_curtis <- vegdist(t(genus_rel2), method = "bray")

pcoa <- cmdscale(bray_curtis, k = 2, eig = TRUE)

points <- as.data.frame(pcoa$points)
colnames(points) <- c("PCoA1", "PCoA2")
points$sample <- rownames(points)

points$time <- ifelse(grepl("_pre_", points$sample), "pre", "post")
points$wl <- ifelse(grepl("_high$", points$sample), "high", "low")

variance_explanation <- 100 * pcoa$eig / sum(pcoa$eig)

library(ggplot2)
ggplot(points, aes(x = PCoA1, y = PCoA2, colour = wl, shape = time)) + geom_point(size = 3) + geom_text(aes(label = sample), vjust = -0.8, size = 5) + labs(x = "PCoA1", y = "PCoA2") + theme_classic()

data <- data.frame(sample = rownames(points), time = points$time, wl = points$wl)
rownames(data) <- data$sample
adonis2(bray_curtis ~ time * wl, data = data)
