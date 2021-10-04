
if(!require(openxlsx)){install.packages("openxlsx");library(openxlsx)}
library(tidyverse)

options(scipen=100)

# openXL("fs.xlsx")

bs <- read.xlsx("fs.xlsx", 1)
pl <- read.xlsx("fs.xlsx", 2)
ce <- read.xlsx("fs.xlsx", 3)
cf <- read.xlsx("fs.xlsx", 4)

bs <- bs[-nrow(bs),]
pl <- pl[-nrow(pl),]
ce <- ce[-nrow(ce),]
cf <- cf[-nrow(cf),]


bs_sum_test <- bs %>% 
    map_df(~gsub("\u00A0", "",.)) %>% 
    map_df(~gsub("<.*?>", "",.)) %>% 
    map_df(~trimws(.)) %>% 
    mutate(category = ifelse(is.na(X3), NA, `과목`))

bs_sum_test[1,"category"] <- "자산"
bs_sum_test$category <- zoo::na.locf(bs_sum_test$category)

bs_sum_test <- bs_sum_test[!is.na(bs_sum_test$`제.26(당).기`),]
bs_sum_test$`제.26(당).기` <- as.numeric(bs_sum_test$`제.26(당).기`)
    
bs_sum_test %>% select(1,2,4,6) -> bs_sum_test

bs_sum_test <- mutate_all(bs_sum_test, ~replace(.,is.na(.),0))

bs_total <- bs %>% select(1,3) %>%     
    map_df(~gsub("\u00A0", "",.)) %>% 
    map_df(~gsub("<.*?>", "",.)) %>% 
    map_df(~trimws(.)) %>% 
    mutate(X3 = as.numeric(X3))

bs_sum_test %>% group_by(category) %>% 
    summarise(g = sum(`제.26(당).기`)) %>% 
    rename("과목"= "category") %>% 
    left_join(bs_total, by = "과목") %>% 
    mutate(diff = g - X3) %>% 
    mutate(상위 = c("I. 유동자산",
                  "II. 비유동자산", 
                  "II. 비유동자산",
                  "I. 유동자산",
                  "II. 비유동자산",
                  "II. 비유동자산",
                  "부채총계",
                  "자본총계",
                  "자본총계",
                  "부채총계",
                  "자본총계")) -> bs_sum_test1


bs_total1 <- rename(bs_total1, 상위 = 과목)
bs_sum_test1 %>% group_by(상위) %>% 
    summarise(g1 = sum(g)) %>% 
    left_join(bs_total1) %>% 
    mutate(diff = g1 - X3)


pl_sum_test <- pl %>% 
    map_df(~gsub("\u00A0", "",.)) %>% 
    map_df(~gsub("<.*?>", "",.)) %>% 
    map_df(~trimws(.)) %>% 
    mutate(category = ifelse(is.na(X3), NA, `과목`))

pl_sum_test$category <- zoo::na.locf(pl_sum_test$category)

pl_sum_test <- pl_sum_test[!is.na(pl_sum_test$`제.26(당).기`),]
pl_sum_test$`제.26(당).기` <- as.numeric(pl_sum_test$`제.26(당).기`)
    
pl_sum_test %>% select(1,2,4,6) -> pl_sum_test

pl_sum_test <- mutate_all(pl_sum_test, ~replace(.,is.na(.),0))

pl_total <- pl %>% select(1,3) %>%     
    map_df(~gsub("\u00A0", "",.)) %>% 
    map_df(~gsub("<.*?>", "",.)) %>% 
    map_df(~trimws(.)) %>% 
    mutate(X3 = as.numeric(X3))


pl_category <- which(is.na(pl$`제.26(당).기`))
pl[pl_category,1]
pl[pl_category,3]

pl[pl_category[1],3] - pl[pl_category[2],3] == pl[pl_category[3],3]
pl[pl_category[3],3] - pl[pl_category[4],3] == pl[pl_category[5],3]
pl[pl_category[5],3] + pl[pl_category[6],3] - pl[pl_category[7],3] == pl[pl_category[8],3]
pl[pl_category[8],3] - pl[pl_category[9],3] == pl[pl_category[10],3]

amount <- as.vector(1:9)
for (i in 1:9) {
    amount[i] <- sum(as.numeric(pl[(pl_category[i]+1) : (pl_category[i+ 1]-1), 2]), na.rm = T)
}

pl[(pl_category[3]+1) : (pl_category[3+ 1]-1), 2]

pl[(pl_category[1]+1) : (pl_category[1+ 1]-1), 2]
pl[10 : 9, 2]

pl_cate_am <- pl[pl_category,c(1,3)]




working <- rbind(bs, pl)

working <- working %>% 
    map_df(~gsub("\u00A0", "",.)) %>% 
    map_df(~gsub("<.*?>", "",.)) %>% 
    map_df(~trimws(.))

# for (i in seq_along(working$과목)){
#     if (is.na(working[i,2])) {
#         working[i,2] <- working[i,3]
#     } 
# } 
# 
# for (i in seq_along(working$과목)){
#     if (is.na(working[i,4])) {
#         working[i,4] <- working[i,5]
#     } 
# } 

working <- working %>% select(c(1,2,4))

acctcd <- working$과목

working <- working %>% 
    mutate(계정구분 = ifelse(str_detect(과목, pattern =  "부채"), "대변",NA)) %>% 
    fill(계정구분, .direction = "down") %>% 
    mutate(계정구분 = ifelse(is.na(계정구분), "차변", 계정구분))

working[c(71:75, 77:108, 118:124, 126),계정구분] <- "차변"
working$`제.26(당).기` <- working$`제.26(당).기` %>% as.numeric()
working$`제.25(전).기` <- working$`제.25(전).기` %>% as.numeric()
working <- mutate_all(working, ~replace(., is.na(.), 0))


current_A <- c("(1) 당좌자산", "(2) 재고자산")
uncurrent_A
uncurrent_A


working[[which(working$과목 == "I. 유동자산"),2]]

which(working$과목 == "(1) 당좌자산")
which(working$과목 == "(2) 재고자산")

current_year <- as_vector(working$`제.26(당).기`)
names(current_year) <- working$과목


which(names(current_year) == current_A[1])

sum(current_year[current_A]) == current_year["I. 유동자산"] 

