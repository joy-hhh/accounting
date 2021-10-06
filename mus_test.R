library(tidyverse)

je <- read_csv("https://raw.githubusercontent.com/joy-hhh/R_for_JE_test/main/je_utf.csv")
pop <- je %>% 
    filter(ACCTCD  == '40401')


pop <- pop %>% 
    mutate(cum = cumsum(CR))


interval <- 300000000
nu <- pop %>% 
    select(CR) %>% 
    sum()/interval + 1 
nu <- round(nu)
    
sampling_row <- seq(nu)    
sampling_n <- seq(nu) * interval


for (i in seq_along(sampling_n)) {
    sampling_row[i] <- which(pop$cum > sampling_n[i])[1]
}
length(na.omit(sampling_row))
