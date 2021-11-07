options(scipen = 999)
library(dplyr)
if(!require(writexl)){install.packages("writexl");library(writexl)}

## 변수 입력 - Significant.Risk, Reliance.on.Controls, Planned Level of Assurance from Substantive Analytical Procedures

SR = "Yes"         ## "No"
RC = "Yes"         ## "No"
PL = "Analytical.Procedures.Not.Performed"     ## "High", "Low", "Moderate"

## 수행중요성 금액 및 허용오류율(5% 등) 입력

PM <- 740000000 * 0.8   ## Tolerable misstatement (generally performance materiality)
EA <- PM * 0.05    ## Expected misstatement


je <- read_csv("population.csv")

## rename Data variable
pop <- pop %>% rename(amount = CR)   # CR 자리에 현재 data 변수명 입력


## sampling 함수 생성

mus_sampling <- \(SR, RC, PL, PM, EA){
    
    ## Assurance Factor 산정
    
    assurance_factor_raw <- tibble::tribble(
        ~Significant.Risk, ~Reliance.on.Controls, ~High, ~Moderate, ~Low, ~Analytical.Procedures.Not.Performed,
                    "Yes",                  "No",   1.1,       1.6,  2.8,                                    3,
                     "No",                  "No",     0,       0.5,  1.7,                                  1.9,
                    "Yes",                 "Yes",     0,       0.2,  1.4,                                  1.6,
                     "No",                 "Yes",     0,         0,  0.3,                                  0.5
        )
    
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
    
    ## High Value
    sum_High_value_items <- 0
        
    ## Sampling Interval = (Tolerable Misstatement – Expected Misstatement) / Assurance Factor
    sampling_interval = (PM - EA) / AF
    
    ## Expected Sample Size = (Population Subject to Sampling X Assurance Factor) / (Tolerable Misstatement – Expected Misstatement)
    pop_amount <- pop$amount %>% sum()
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
    sampling <<- pop %>% 
        select(-cum) %>% 
        slice(sampling_row)
}
    


## 함수 실행
  
mus_sampling(SR, RC, PL, PM, EA)

## 샘플링 내역 확인
print(sampling, n = Inf)


## 추출된 샘플 엑셀 파일 생성
sampling %>% write_xlsx("sampling.xlsx")
