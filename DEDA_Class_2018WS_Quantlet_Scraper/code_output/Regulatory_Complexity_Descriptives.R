################################################################################

# Compute descriptives

# input: - regressiondata.csv: sample data and yearly aggregates of complexity
#        - descriptivedata.csv: complexity and descriptive data
# output: 1. Summary statistics complexity measures
#         2. Correlation table
#         3. Summary statistics bank variables

################################################################################

# imports

library(dplyr)
library(stargazer)

################################################################################

# main

# load data
inputPath = file.path(getwd(), 'Regulatory_Complexity_Regressiondata', 'data')
regData   = read.csv(file.path(inputPath, 'regressiondata.csv'))
descData  = read.csv(file.path(inputPath, 'descriptivedata.csv'))

regData$index = factor(regData$index)


### 1. Summary statistics complexity measures

for (method in c('average', 'tfidf', 'wmd', 'doc2vec')){
  data           = descData[grep(pattern = method, colnames(descData))]
  colnames(data) = c('Interquartile Range', 'Mean', 'Standard Deviation')
  data           = data[ , c('Mean', 'Standard Deviation', 'Interquartile Range')]
  
  print(method)
  stargazer(data,
            type         = 'latex',
            median       = TRUE,
            iqr          = TRUE,
            digits       = 3,
            digits.extra = 0,
            align        = TRUE)
}

### 2. Correlation table
data = descData[ , 3:ncol(descData)]
data = data[ , c('average_means', 'average_stds', 'average_iqrs',
                  'tfidf_means', 'tfidf_stds', 'tfidf_iqrs',
                  'wmd_means', 'wmd_stds', 'wmd_iqrs',
                  'doc2vec_means', 'doc2vec_stds', 'doc2vec_iqrs',
                  'nWords', 'nSents')]
stargazer(cor(data),
          type         = 'latex',
          digits       = 3,
          digits.extra = 0,
          align        = TRUE)

### 3. Summary statistics bank variables
data = data.frame(regData$ROA, regData$Size,
                       regData$EquityRatio, regData$Liquidity, 
                       regData$Funding, regData$Risk, regData$BusinessModel, 
                       regData$LoansToCustomersLT, regData$LoansToCustomersST,
                       regData$LoansToBanksLT, regData$LoansToBanksST)
colnames(data) = c('ROA', 'Size', 
                        'Equity Ratio', 'Liquidity', 
                        'Funding', 'Risk', 'Business Model',
                        'Loans to Customers LT', 'Loans to Customers ST',
                        'Loans to Banks LT', 'Loans to Banks ST')
stargazer(data,
          type         = 'latex',
          median       = TRUE,
          iqr          = TRUE,
          digits       = 3,
          digits.extra = 0,
          align        = TRUE)
