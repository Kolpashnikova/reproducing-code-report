#1.	Load necessary packages into R (readr, tidyverse, ggplot2) and import ‘gss_12M0025_E_2017_c_31_F1.csv’
#2.	Create table of interest from main GSS using variables: 
#decimal age (AGEDC), 
#subjective well-being (SLM_01), 
#self-rated health (SRH_110), 
#self-rated mental health (SRH_115), 
#satisfaction with time spent with children (STS_410), 
#and total personal income (TTLINCG2).
#3.	Clean this data
#a.	Drop skipped answers (values 96-99) from subjective well-being (SLM_01)
#b.	Drop skipped answers (values 6-9) from self-rated health (SRH_110)
#c.	Drop skipped answers (values 6-9) from self-rated mental health (SRH_115)
#d.	Drop skipped answers (values 6-9) from satisfaction with time spent with children (STS_410)
library(readr)
library(tidyverse)
library(ggplot2)
library(dplyr)

gss <- read.csv('data/gss-12M0025-E-2017-c-31_F1.csv') %>%
  select(c(PUMFID, AGEDC, SLM_01, SRH_110, SRH_115, 
           STS_410, TTLINCG2, WGHT_PER)) %>% 
  filter(SLM_01 < 96, SRH_110 < 6, SRH_115 < 6, STS_410 < 6)

#4.	Create a basic linear regression model estimating subjective well-being using 
#the other 5 variables and note coefficients, significant variables, and R-sq

model <- lm(SLM_01 ~ AGEDC + SRH_110 + SRH_115 + STS_410 + TTLINCG2, data = gss)
summary(model)

#5.	Check assumptions of the model (Independence can be assumed):
#  a.	Linearity assumption: isolate the first graph of the plot function
plot(model, which=1)
#  b.	Equal variance assumption: isolate the third graph of the plot function
plot(model, which=3)
#  c.	Normality assumption:
plot(model, which=2)

#  i.	Isolate the second graph of the plot function 
#  ii.	Create a basic histogram of residuals with 20 bins, 
#pink bars with black outlines, and 
#appropriate title/axis labels

ggplot(data = gss, aes(x = model$residuals)) +
  geom_histogram(bins = 20, fill = 'pink', color = 'black') +
  labs(title = 'Histogram of Residuals', x = 'Residuals', y = 'Frequency')
