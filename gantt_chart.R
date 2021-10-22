#간트차트 그리기
library(DiagrammeR)
mermaid("
     gantt
     dateFormat  YYYY-MM-DD
     title 업무계획
     
     section R JE test
     기초분석                      :done,          analysis_1,    2019-08-15, 2019-08-16
     모델링                        :active,        analysis_2,    after analysis_1, 3d
     
     section 교육업무
     직장인교육                    :crit,          education_1,   2019-08-14, 2019-08-15
     대학생교육                    :               education_2,   2019-08-18, 3d
     ")


#간트차트 그리기2
library(timevis)
data <- data.frame(
   id      = c(1:4),
   content = c("기초분석"  , "모델링"  ,"직장인교육", "대학생교육"),
   start   = c("2019-08-15", "2019-08-16", "2019-08-14", "2019-08-18"),
   end     = c("2019-08-16", "2019-08-19", "2019-08-15", "2019-08-19")
 )
timevis(data, showZoom = FALSE) #간트차트 그리기

data <- data.frame(
    id      = c(1:4),
    content = c("Cheat Sheets"  ,"Practical Exercise", "Q&A", "JE Tester"),
    start   = c("2021-10-22 14:00:00", "2021-10-22 14:20:00", "2021-10-22 15:00:00", "2021-10-22 15:20:00"),
    end     = c("2021-10-22 14:20:00", "2021-10-22 15:00:00", "2021-10-22 15:20:00", "2021-10-22 16:00:00")
)
timevis(data, showZoom = FALSE) #간트차트 그리기
