install.packages("ggplot2")
library(ggplot2)

## Graph 1 - comple vs contam 

# load the data
quality_report <- read.csv("quality_report.csv", row.names = 1)

# find out the indices of very high values of conatmination so we can exclude them
non_outlier_indices <- which(quality_report[, 2] < 10)

# storing the df columns to be plotted in valiables
df <- data.frame(quality_report[non_outlier_indices, ])
contamination <- quality_report[non_outlier_indices, 2]
completeness <- quality_report[non_outlier_indices, 1]


# doing a regression plot
model <- lm(completeness ~ contamination, data=df)
summary(model)


# plotting it on a graph
ggplot(df, aes(x=completeness, y=contamination)) + 
  geom_point() +
  xlab('Completeness (%)') +
  ylab('Contamination (%)') +
  geom_smooth(method = 'lm') +
  ggtitle("The correlation between completeness and contamination of the bins")



## graph 2 - bar graph of bin size vs quality

# assign quality ranges for each bin
quality_report$bin_category <- as.factor(ifelse(quality_report$Quality <= 0, '<= 0',
                  ifelse(quality_report$Quality <= 10, '1-10',
                  ifelse(quality_report$Quality <= 20, '11-20',
                  ifelse(quality_report$Quality <= 30, '21-30', 
                  ifelse(quality_report$Quality <= 40, '31-40', 
                  ifelse(quality_report$Quality <= 50, '41-50', 
                  ifelse(quality_report$Quality <= 60, '51-60', 
                  ifelse(quality_report$Quality <= 70, '61-70', 
                  ifelse(quality_report$Quality <= 80, '71-80', 
                  ifelse(quality_report$Quality <= 90, '81-90', '90-100')))))))))))


# make a data frame to show the number of bins falling into each quality category
quality_counts <- table(quality_report$bin_category)
quality_df <- as.data.frame(quality_counts)
quality_df 

# add a new column to df, showing the quality proportions 
quality_df$proportion <- (quality_df$Freq/(dim(quality_report))[1]) * 100
colnames(quality_df) <- c('Bin_Quality_Range', 'Quality_Score', 'Quality_Proportion') 
quality_df

# plot it with ggplot
ggplot(quality_df, aes(x=Bin_Quality_Range, y=Quality_Proportion, fill=Bin_Quality_Range)) + 
  geom_bar(stat='identity') +
  xlab('Bin Quality Range') +
  ylab('Proportion of Bins (%)') +
  ggtitle("The proportion of bins vs bin quality") +
  theme(legend.position = 'none')
