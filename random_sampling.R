library(tidyverse)

je <- read_csv("https://raw.githubusercontent.com/joy-hhh/R_for_JE_test/main/je_utf.csv")
pop <- je %>% 
    filter(ACCTCD  == '40401')

pop_n <- nrow(pop)
sample_n <- 100
sampling_number <- sample(pop_n, sample_n)
sampling <- pop %>% slice(sampling_number)
sampling %>% write.csv("sampling.csv")
