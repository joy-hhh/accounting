options(scipen = 999)
library(tidyverse)
if(!require(writexl)){install.packages("writexl");library(writexl)}

## 변수 입력 - Significant.Risk, Reliance.on.Controls, Planned Level of Assurance from Substantive Analytical Procedures

SR = "Yes"         ## "No"
RC = "Yes"         ## "No"
PL = "Moderate"    ## "High", "Low", "Analytical.Procedures.Not.Performed"

## 수행중요성 금액 및 허용오류율(5% 등) 입력

PM <- 740000000 * 0.8   ## Tolerable misstatement (generally performance materiality)
EA <- PM * 0.05    ## Expected misstatement


## Assurance Factor 산정

assurance_factor_raw <- tibble::tribble(
    ~Significant.Risk, ~Reliance.on.Controls, ~High, ~Moderate, ~Low, ~Analytical.Procedures.Not.Performed,
                "Yes",                  "No",   1.1,       1.6,  2.8,                                    3,
                 "No",                  "No",     0,       0.5,  1.7,                                  1.9,
                "Yes",                 "Yes",     0,       0.2,  1.4,                                  1.6,
                 "No",                 "Yes",     0,         0,  0.3,                                  0.5
    )
print(assurance_factor_raw)

assurance_factor <- assurance_factor_raw %>% 
    pivot_longer(
    cols = c(High, Moderate, Low, Analytical.Procedures.Not.Performed),
    names_to = "Planned_Level",  # Planned Level of Assurance from Substantive Analytical Procedures
    values_to = "Assurance_Factor"
    )

assurance_factor <- assurance_factor %>%
    filter(
        Significant.Risk == SR,
        Reliance.on.Controls == RC,
        Planned_Level == PL
    )
AF <- assurance_factor[[1,4]]
print(AF)


## Load Population Data

je <- read_csv("https://raw.githubusercontent.com/joy-hhh/R_for_JE_test/main/je_utf.csv")
pop <- je %>% 
    filter(ACCTCD  == '40401')

pop <- pop %>% rename(amount = CR)
pop_amount <- pop$amount %>% sum()


## High Value
sum_High_value_items <- 0
    
## Sampling Interval = (Tolerable Misstatement – Expected Misstatement) / Assurance Factor
sampling_interval = (PM - EA) / AF

## Expected Sample Size = (Population Subject to Sampling X Assurance Factor) / (Tolerable Misstatement – Expected Misstatement)
sample_size = pop_amount * AF / (PM - sum_High_value_items - EA)


sampling_row <- seq(sample_size)    
sampling_n <- seq(sample_size) * sampling_interval

pop <- pop %>% 
    mutate(cum = cumsum(amount))

for (i in seq_along(sampling_n)) {
    sampling_row[i] <- which(pop$cum > sampling_n[i])[1]
}
sampling_row <- sampling_row %>% unique()

## 추출된 샘플의 갯수
length(na.omit(sampling_row))

## 샘플링 객체 생성
sampling <- pop %>% 
    select(-cum) %>% 
    slice(sampling_row)

## 샘플링 내역
print(sampling, n = Inf)

## 추출된 샘플 엑셀 파일 생성
sampling %>% write_xlsx("sampling.xlsx")