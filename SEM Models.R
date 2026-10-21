# library(lavaan)
library(semPlot)
data=read.csv('SEM.csv',header = T,row.names = 1)
data_standardized <- scale(data)
model = 'C_aviliable =~ EEAC.N + Vlength + C5
 DIN ~N
 VMM ~ N +W+DIN
 C_aviliable ~ VMM +N+W
 Respiration_MBC ~ C_aviliable+W+Growth_MBC
 Growth_MBC~N+C_aviliable
 CUE ~ Growth_MBC +Respiration_MBC
 BA_neu_TC~ CUE+Growth_MBC+DIN+C_aviliable
 
 EEAC.N ~~ DIN+C5+Vlength

 VMM~~CUE

  C_aviliable ~~ 0.1*C_aviliable
  Growth_MBC ~~ DIN
  
 '        
summary(fit,standardized=TRUE,rsq=TRUE)
fitMeasures(fit,c("chisq","df","pvalue","gfi","cfi","rmr","srmr","rmsea",'AIC'))
mod_indices = modindices(fit)
mod_indices[mod_indices$mi >2, ]
