library(shiny)

# Define Variables

time <- tibble::tribble(
          ~group,   ~low,            ~high,  ~col1,  ~col2,  ~col3,  ~col4,  ~col5,  ~col6,
              1L,  0,              0,                0L,     0L,     0L,      0L,     0L,     0L,
              1L,  0,              5000000000000,    3770L,  4300L,  5280L,   2460L,  3410L,  2320L,
              1L, 5000000000000,   10000000000000,   5110L,  5820L,  7150L,   3330L,  4620L,  3150L,
              1L, 10000000000000,  20000000000000,   6930L,  7890L,  9690L,   4520L,  6260L,  4270L,
              1L, 20000000000000,  50000000000000,   10360L, 11790L, 14480L,  6750L,  9360L,  6380L,
              1L, 50000000000000,  100000000000000,  14040L, 15980L, 19630L,  9150L, 12690L,  8640L,
              1L, 100000000000000, 200000000000000,  19030L, 21660L, 26600L,  12400L, 17200L, 11720L,
              1L, 200000000000000, 300000000000000,  22730L, 25880L, 31780L,  14820L, 20540L, 14000L,
              2L,  0,              0,                0L,     0L,     0L,      0L,     0L,     0L,
              2L,  0,              1000000000000,    2560L,  2680L,  3090L,   1790L,  2700L,  2120L,
              2L, 1000000000000,   2000000000000,    3120L,  3270L,  3770L,   2180L,  3290L,  2580L,
              2L, 2000000000000,   3000000000000,    3500L,  3670L,  4230L,   2450L,  3700L,  2900L,
              2L, 2000000000000,   4000000000000,    3800L,  3980L,  4590L,   2660L,  4010L,  3140L,
              3L,  0,              0,                0L,     0L,     0L,      0L,     0L,     0L,
              3L,  0,              300000000000,     1810L,  1890L,  2180L,   1260L,  1910L,  1490L,
              3L, 300000000000,    500000000000,     1990L,  2090L,  2410L,   1390L,  2100L,  1650L,
              3L, 500000000000,    800000000000,     2180L,  2290L,  2630L,   1520L,  2300L,  1800L,
              3L, 800000000000,    1000000000000,    2280L,  2390L,  2750L,   1590L,  2400L,  1880L,
              3L, 1000000000000,   1500000000000,    2460L,  2580L,  2970L,   1720L,  2600L,  2040L,
              3L, 1500000000000,   2000000000000,    2600L,  2730L,  3140L,   1820L,  2740L,  2150L,
              3L, 2000000000000,   5000000000000,    3100L,  3250L,  3740L,   2170L,  3270L,  2560L,
              4L,  0,              0,                0L,     0L,     0L,      0L,     0L,     0L,
              4L,  0,              50000000000,      1040L,  1090L,  1250L,   730L,  1100L,   860L,
              4L, 50000000000,     100000000000,     1150L,  1200L,  1390L,   800L,  1210L,   950L,
              4L, 100000000000,    200000000000,     1270L,  1330L,  1530L,   890L,  1340L,  1050L,
              4L, 200000000000,    300000000000,     1340L,  1410L,  1620L,   940L,  1420L,  1110L,
              4L, 300000000000,    400000000000,     1400L,  1470L,  1690L,   980L,  1480L,  1160L,
              4L, 400000000000,    500000000000,     1440L,  1520L,  1750L,  1010L,  1530L,  1200L,
              4L, 500000000000,    1000000000000,    1600L,  1670L,  1930L,  1120L,  1690L,  1320L,
              5L,  0,              0,                0L,     0L,     0L,      0L,     0L,     0L,
              5L,  0,              30000000000,      910L,   950L,  1100L,   640L,   960L,   750L,
              5L, 30000000000,     50000000000,      990L,  1040L,  1200L,   690L,  1050L,   820L,
              5L, 50000000000,     80000000000,      1070L,  1120L,  1290L,   750L,  1130L,   890L,
              5L, 80000000000,     100000000000,     1110L,  1170L,  1340L,   780L,  1170L,   920L,
              5L, 100000000000,    150000000000,     1190L,  1250L,  1440L,   830L,  1260L,   980L,
              5L, 150000000000,    200000000000,     1250L,  1310L,  1510L,   870L,  1320L,  1030L,
              6L,  0,              0,                0L,     0L,     0L,      0L,     0L,     0L,
              6L,  0,              10000000000,      580L,   610L,   700L,   410L,   610L,   480L,
              6L, 10000000000,     20000000000,      740L,   770L,   890L,   510L,   780L,   610L,
              6L, 20000000000,     30000000000,      850L,   890L,  1020L,   590L,   890L,   700L,
              6L, 30000000000,     40000000000,      930L,   980L,  1130L,   650L,   980L,   770L,
              6L, 40000000000,     50000000000,      1010L,  1050L,  1210L,   700L,  1060L,   830L,
              6L, 50000000000,     100000000000,     1270L,  1330L,  1540L,   890L,  1340L,  1050L,
              7L,  0,              0,                0L,     0L,     0L,      0L,     0L,     0L,
              7L,  0,              10000000000,      520L,   470L,   580L,   570L,   450L,   350L,
              7L, 10000000000,     20000000000,      620L,   560L,   690L,   680L,   540L,   420L,
              7L, 20000000000,     50000000000,      780L,   710L,   870L,   860L,   680L,   530L,
              7L, 50000000000,     100000000000,     930L,   850L,  1040L,  1030L,   820L,   630L,
              7L, 100000000000,    500000000000,     1400L,  1270L,  1560L,  1540L,  1230L,   950L,
              7L, 500000000000,    1000000000000,    1670L,  1520L,  1870L,  1840L,  1470L,  1140L,
              7L, 1000000000000,   5000000000000,    2520L,  2290L,  2810L,  2780L,  2210L,  1710L,
              7L, 5000000000000,   10000000000000,   3000L,  2730L,  3350L,  3310L,  2640L,  2040L,
              7L, 10000000000000,  50000000000000,   4530L,  4120L,  5050L,  4990L,  3970L,  3080L,
              8L,  0,              0,                0L,     0L,     0L,      0L,     0L,     0L,
              8L,  0,              50000000000,      690L,   480L,   600L,   630L,   620L,   190L,
              8L, 50000000000,     100000000000,     750L,   530L,   660L,   690L,   680L,   210L,
              8L, 100000000000,    200000000000,     830L,   590L,   730L,   760L,   750L,   230L,
              8L, 200000000000,    500000000000,     940L,   660L,   820L,   860L,   850L,   260L,
              8L, 500000000000,    1000000000000,    1030L,   730L,   910L,   950L,   940L,   290L,
              8L, 1000000000000,   2000000000000,    1140L,   800L,  1000L,  1040L,  1030L,   320L,
              8L, 2000000000000,   5000000000000,    1290L,   910L,  1130L,  1180L,  1170L,   360L,
              8L, 5000000000000,   10000000000000,   1420L,  1000L,  1240L,  1300L,  1290L,   390L,
              8L, 10000000000000,  50000000000000,   1770L,  1250L,  1550L,  1620L,  1600L,   490L,
              9L,  0,              0,                0L,     0L,     0L,      0L,     0L,     0L,
              9L,  0,              20000000000,      450L,   350L,   380L,   390L,   400L,   380L,
              9L, 20000000000,     50000000000,      550L,   440L,   470L,   480L,   500L,   470L,
              9L, 50000000000,     60000000000,      580L,   460L,   490L,   500L,   520L,   490L,
              9L, 60000000000,     70000000000,      600L,   470L,   510L,   510L,   540L,   510L,
              9L, 70000000000,     80000000000,      620L,   490L,   530L,   530L,   560L,   530L,
              9L, 80000000000,     90000000000,      630L,   500L,   540L,   550L,   570L,   540L,
              9L, 90000000000,     100000000000,     650L,   510L,   560L,   560L,   590L,   560L,
              9L, 100000000000,    200000000000,     760L,   600L,   650L,   660L,   690L,   650L,
             10L,  0,              0,                0L,     0L,     0L,      0L,     0L,     0L,
             10L,  0,              10000000000,      420L,   340L,   340L,   350L,   390L,   310L,
             10L, 10000000000,     20000000000,      480L,   390L,   390L,   390L,   440L,   350L,
             10L, 20000000000,     30000000000,      510L,   420L,   420L,   420L,   480L,   380L,
             10L, 30000000000,     40000000000,      540L,   440L,   440L,   450L,   510L,   400L,
             10L, 40000000000,     50000000000,      570L,   460L,   460L,   470L,   530L,   420L,
             10L, 50000000000,     100000000000,     650L,   520L,   520L,   530L,   600L,   480L
          )

proficiency <- tibble::tribble(
                    ~`group`, ~`pro_rate`,
                  "1",          0.783,
                  "2",          0.777,
                  "3",          0.767,
                  "4",           0.76,
                  "5",          0.753,
                  "6",           0.76,
                  "7",          0.765,
                  "8",          0.728,
                  "9",          0.713,
                  "10",          0.703
                 )



yesno <- c( "No", "Yes")
sectors <-  c("제조업", "서비스업", "건설업", "금융업", "도소매업", "기타")

sectors_name <- c("col1", "col2" ,"col3" ,"col4" ,"col5" ,"col6")
names(sectors_name) <- sectors

year <- c("2022년", "2023년")

listed_num <- c("1" , "2" , "3" , "4" , "5" , "6")





ui <- fluidPage(

    # Application title
    titlePanel("표준감사시간 계산기 - 2022년 1월 개정 반영"),
    h5('joyhhh@outlook.kr'),
    h5('조이회계 | https://joy-accounting.netlify.com/'),
    h5('Thanks to 테크핀투자자문'),
    imageOutput('img1'),
    
    
    HTML('<hr style="border-color: black;">'),
    
    fluidRow(
        column(width = 4, style='padding-top:30px', 
            sliderInput("bins",
                        "예상 투입 인원의 가중평균 경력",
                        min = 0,
                        max = 15,
                        value = 2),
        ),
        column(width = 4, style='padding-top:30px', offset = 4,
            selectizeInput('year', '적용 연도 선택', year, multiple = FALSE),
        )       
    ),
    
    HTML('<hr style="border-color: black;">'),
    
    fluidRow(
        column(width = 4, style='padding-top:30px', 
            numericInput('num1',label = '직전 사업연도말 자산 총액', min = 0, value = 900000000000),
            numericInput('num2',label = '직전 사업연도말 매출액', min = 0, value = 500000000000),
        ),
        column(width = 4, style='padding-top:30px',
            selectizeInput('sel_listed', '유가증권, 코스닥 상장', yesno, multiple = FALSE),
            selectizeInput('sel_konex', '코넥스 상장 또는 사업보고서 제출 비상장', yesno, multiple = FALSE),
        ),
        column(width = 4, style='padding-top:30px',
            numericInput('num5',label = '직전 사업연도말 연결 자산 총액', min = 0, value = 1350000000000),
            numericInput('num6',label = '직전 사업연도말 연결 매출액', min = 0, value = 750000000000),
        )
    ),
    
    HTML('<hr style="border-color: black;">'),
    
    fluidRow(
        column(width = 4, offset = 5,
            h3('↓그룹'),
            textOutput('group'), 
        ),
    ),
    
    HTML('<hr style="border-color: black;">'),
    
    fluidRow(
        column(width = 4, style='padding-top:30px',
            numericInput('num3',label = '직전 사업연도말 매출채권', min = 0, value = 20000000000),
            numericInput('num4',label = '직전 사업연도말 재고자산', min = 0, value = 10000000000),
        ),

        column(width = 4, style='padding-top:30px',
            selectizeInput('consol', '연결재무제표 작성?', yesno, multiple = FALSE),
            numericInput('num9',label = '연결 자회사 수', min = 0, value = 0),
        ),
        
        column(width = 4, style='padding-top:30px',
            numericInput('num7',label = '직전 사업연도말 연결 매출채권', min = 0, value = 30000000000),
            numericInput('num8',label = '직전 사업연도말 연결 재고자산', min = 0, value = 15000000000),
               
        )
        
    ),
    
    fluidRow(
        column(width = 4,
        uiOutput("risk1"),
        ),
        column(width = 4,
        uiOutput("risk2"),
        ),
        column(width = 4,
        uiOutput("test"),
        ),
        

    ),

    HTML('<hr style="border-color: black;">'),
    
    
    
    # Show a plot of the generated distribution
    fluidRow(
        column(width = 4, style='padding-top:30px',
            selectizeInput('sel_secor', '업종', sectors, multiple = FALSE),
            
            selectizeInput('sel11', '금융 지주사?', yesno, multiple = FALSE),
            sliderInput("bins2",
                        "금융 지주사 차감 (1~6그룹)",
                        min = 0.25,
                        max = 0.6,
                        value = 0.6),
            
            selectizeInput('sel12', '비금융 지주사?', yesno, multiple = FALSE),
            uiOutput("bins3"),
            
            selectizeInput('sel13', '초도감사?', yesno, multiple = FALSE),
            uiOutput("bins4"),
           
        ),    
            column(width = 4, style='padding-top:30px',
            
            selectizeInput('sel14', '당기순손실?', yesno, multiple = FALSE),
            uiOutput("bins5"),
            
            selectizeInput('sel15', '비적정 의견?', yesno, multiple = FALSE),
            sliderInput("bins6",
                        "비적정 의견",
                        min = 0,
                        max = 0.45,
                        value = 0.45),
            selectizeInput('sel1', '미국 상장사', yesno, multiple = FALSE),
            selectizeInput('sel2', 'IFRS?', yesno, multiple = FALSE),
            sliderInput("bins7",
                        "IFRS 가산율",
                        min = 0.1,
                        max = 0.2,
                        value = 0.2),
        ),
        column(width = 4, style='padding-top:30px',
            selectizeInput('sel3', '임의 반기 검토 (7~10그룹)', yesno, multiple = FALSE),
            selectizeInput('sel4', '임의 분기 검토 (1~3그룹 제외)', yesno, multiple = FALSE),
            selectizeInput('sel5', '표준감사시간 당해 최초 적용', yesno, multiple = FALSE),
            numericInput('num10',label = '최초 적용 이전 감사시간', min = 0, value = 300),
        )
       
    ),

    
    
    HTML('<hr style="border-color: black;">'),
    fluidRow(
        column(width = 4, style='padding-top:40px; padding-bottom:30px', offset = 5,
               h3('↓표준감사시간'),
               textOutput('calc')
        ),
    )
    
)

# Define server logic
server <- function(input, output, session) {
    
    output$img1 = renderImage({
        list(src = "techfin.jpg")
    }, deleteFile = FALSE)
    
    
    group <- function(num1, num2, sel_listed, sel_konex, num5, num6){
        scale <- (num1 + num2) / 2
        scale2 <- (num5 + num6) / 2
        if(scale >= 2000000000000 & scale2 >= 5000000000000){
            1
        } else if(sel_listed == "Yes" & scale >= 2000000000000){
            2
        } else if(sel_listed == "Yes" & scale >= 500000000000){
            3
        } else if(sel_listed == "Yes" & scale >= 100000000000){
            4 
        } else if(sel_listed == "Yes" & scale >= 50000000000){
            5 
        } else if(sel_listed == "Yes" & scale < 50000000000){
            6 
        } else if(sel_konex == "Yes"){
            7 
        } else if(sel_listed == "No" & scale >= 100000000000){
            8 
        } else if(sel_listed == "No" & scale >= 50000000000){
            9 
        } else if(sel_listed == "No" & scale >= 20000000000){
            10 
        } else {
            NA
        } 
    }
    
    output$group <- renderText({group(input$num1, input$num2, input$sel_listed, input$sel_konex, input$num5, input$num6)})

    risk_acc <- function(consol, ar, inventory, asset, car, cinv, casset){
        if (consol == "No"){
            (ar + inventory)/ asset
        } else {
            (car + cinv)/ casset
        }
    }
    
    
    observeEvent(input$num9, { 
        updateNumericInput(session, "num9", value = ({ if(!(is.numeric(input$num9))){0}
            else if(!(is.null(input$num9) || is.na(input$num9))){
                if(input$num9 < 0){
                    0 
                } else {
                    return (isolate(input$num9))
                } 
            } 
            else{0}
        })
        )
    })
    

   output$risk1 <- renderUI({
       
       if(group(input$num1, input$num2, input$sel_listed, input$sel_konex, input$num5, input$num6) %in% listed_num){
           if ( input$num9 <= 10){
               minkaw <- 0.1
               maxkaw <- 0.4
           } else if (input$num9 > 10 & input$num9 <= 50) {
               minkaw <- 0.4
               maxkaw <- 0.7
           } else if (input$num9 > 50 & input$num9 <= 100){
               minkaw <- 0.7
               maxkaw <- 1
           } else {
               minkaw <- 1
               maxkaw <- 1.45
           }
       } else {
           if ( input$num9 <= 10){
               minkaw <- 0.15
               maxkaw <- 0.35
           } else if (input$num9 > 10 & input$num9 <= 50) {
               minkaw <- 0.35
               maxkaw <- 0.6
           } else if (input$num9 > 50 & input$num9 <= 100){
               minkaw <- 0.6
               maxkaw <- 0.8
           } else {
               minkaw <- 0.8
               maxkaw <- 1.1
           }
       }
       
       sliderInput("risk1","자회사 가산율",min=minkaw, max = maxkaw,value = maxkaw)
           
   })
   
   output$risk2 <- renderUI({
        
       risk_rate <- (input$num7 + input$num8)/ input$num5
       risk_rate_no <- (input$num3 + input$num4)/ input$num1

              
       if(group(input$num1, input$num2, input$sel_listed, input$sel_konex, input$num5, input$num6) %in% listed_num){
            if(input$consol == "Yes"){
                if ( risk_rate <= 0.55){
                    minkaw2 <- 0.05
                    maxkaw2 <- 0.1
                } else if (risk_rate > 0.55 & risk_rate <= 0.9) {
                    minkaw2 <- 0.1
                    maxkaw2 <- 0.15
                } else {
                    minkaw2 <- 0.15
                    maxkaw2 <- 0.2
                }
            } else {
                if ( risk_rate_no <= 0.55){
                    minkaw2 <- 0.05
                    maxkaw2 <- 0.1
                } else if (risk_rate_no > 0.55 & risk_rate_no <= 0.9) {
                    minkaw2 <- 0.1
                    maxkaw2 <- 0.15
                } else {
                    minkaw2 <- 0.15
                    maxkaw2 <- 0.2
                }
            }
       } else {
           if(input$consol == "Yes"){
               if ( risk_rate <= 0.55){
                   minkaw2 <- 0.02
                   maxkaw2 <- 0.15
               } else if (risk_rate > 0.55 & risk_rate <= 0.9) {
                   minkaw2 <- 0.15
                   maxkaw2 <- 0.3
               } else {
                   minkaw2 <- 0.3
                   maxkaw2 <- 0.35
               }
           } else {
               if ( risk_rate_no <= 0.55){
                   minkaw2 <- 0.02
                   maxkaw2 <- 0.15
               } else if (risk_rate_no > 0.55 & risk_rate_no <= 0.9) {
                   minkaw2 <- 0.15
                   maxkaw2 <- 0.3
               } else {
                   minkaw2 <- 0.3
                   maxkaw2 <- 0.35
               }
           }
       }
       
       sliderInput("risk2","위험계정 가산율",min=minkaw2, max = maxkaw2,value = maxkaw2)
   })
       
    
    
    
    output$bins3 <- renderUI({
        if(group(input$num1, input$num2, input$sel_listed, input$sel_konex, input$num5, input$num6) %in% listed_num){
            minbins3 <- 0.25
            maxbins3 <- 0.55
        } else {
            minbins3 <- 0.3
            maxbins3 <- 0.5
        }
            
    sliderInput("bins3",
                "비금융 지주사 차감",
                min = minbins3,
                max = maxbins3,
                value = maxbins3)
    })    
    
    output$bins4 <- renderUI({
        if(group(input$num1, input$num2, input$sel_listed, input$sel_konex, input$num5, input$num6) %in% listed_num){
            minbins4 <- 0.05
            maxbins4 <- 0.2
        } else {
            minbins4 <- 0.1
            maxbins4 <- 0.15
        }
        
        sliderInput("bins4",
                "초도감사 가산율",
                min = minbins4,
                max = maxbins4,
                value = maxbins4)
    })    
    
    output$bins5 <- renderUI({
        if(group(input$num1, input$num2, input$sel_listed, input$sel_konex, input$num5, input$num6) %in% listed_num){
            minbins5 <- 0.05
            maxbins5 <- 0.3
        } else {
            minbins5 <- 0.02
            maxbins5 <- 0.2
        }
        
        sliderInput("bins5",
                  "당기순손실 가산율",
                    min = minbins5,
                    max = maxbins5,
                    value = maxbins5)
    })    
        
    scale_num <- reactive({
        switch (input$consol,
            "Yes" = (input$num5 + input$num6) / 2,
            "No" = (input$num1 + input$num2) / 2
        )
    })    
    
    sect <- reactive({
        input$sel_secor
    })
    
    
    group_num <- reactive({
        group(input$num1, input$num2, input$sel_listed, input$sel_konex, input$num5, input$num6)
    })
    
    sel1_y <- reactive({
        ifelse(input$sel1 == "Yes", 1.4, 1)
    })
    
    sel2_y <- reactive({
        ifelse(input$sel2 == "Yes", 1+input$bins7, 1)
    })
    
    sel11_y <- reactive({
        ifelse(input$sel11 == "Yes", 1-input$bins2, 1)
    })

    sel12_y <- reactive({
        ifelse(input$sel12 == "Yes", 1-input$bins3, 1)
    })
    
    sel13_y <- reactive({
        ifelse(input$sel13 == "Yes", 1+input$bins4, 1)
    })
    
    sel14_y <- reactive({
        ifelse(input$sel14 == "Yes", 1+input$bins5, 1)
    })
    
    sel15_y <- reactive({
        ifelse(input$sel15 == "Yes", 1+input$bins6, 1)
    })
    
    
        
    sel3_y <- reactive({
        if (input$sel3 == "Yes"){
            if (group_num() == "7"){
                1.35
            } else {
                1.55
            }
        } else {
            1
        }
    })
    
    sel4_y <- reactive({
        ifelse(input$sel4 == "Yes", 1.7, 1)
    })
    
    max_bound <- reactive({
        if (input$sel5 == "Yes") {
            if (group(input$num1, input$num2, input$sel_listed, input$sel_konex, input$num5, input$num6) %in% c("1","2")){
                max_bound <- input$num10 * 1.5
            } else {
                max_bound <- input$num10 * 1.3
            }
        }
    })
    
    min_bound <- reactive({
        input$num10
    })
        
    
    add_rate <- reactive({
        if(group(input$num1, input$num2, input$sel_listed, input$sel_konex, input$num5, input$num6) %in% listed_num){
            ifelse(input$consol == "Yes", 
                   (1+input$risk1) * (1+input$risk2) * sel11_y() * sel12_y() * sel13_y() * sel14_y() * sel15_y() * sel1_y() * sel4_y(),
                   (1+input$risk2) * sel11_y() * sel12_y() * sel13_y() * sel14_y() * sel15_y() * sel1_y() * sel4_y())
        } else {
            ifelse(input$consol == "Yes", 
                   (1+input$risk1) * (1+input$risk2) * sel12_y() * sel13_y() * sel14_y() * sel15_y() * sel2_y() * sel3_y() * sel4_y(),
                   (1+input$risk2) * sel12_y() * sel13_y() * sel14_y() * sel15_y() * sel2_y() * sel3_y() * sel4_y())
        }
    })    
        
    

    
    
    
        
    
    profi <- reactive({
        
        weight <- if(input$bins == 0){
            0.4
        } else if(input$bins > 0 & input$bins < 2 ){
            0.8
        } else if(input$bins >=2 & input$bins < 6){
            1
        } else if(input$bins >=6 & input$bins < 10){
            1.1   
        } else if(input$bins >=10 & input$bins < 15){
            1.15
        } else {
            1.2
        }
        
        proficiency[proficiency["group"] == group_num(),2][[1]] / weight
    })

    
    
    calc_time <- function() {
        
        group_time <- time[time["group"] == group_num(),]
        
        if (group_time[nrow(group_time),"high"] < scale_num()){
            scale_num() /group_time[[nrow(group_time),"high"]] * group_time[[nrow(group_time),sectors_name[sect()]]]
        
        } else {
            table_time <- group_time[group_time["high"] <= scale_num() ,][nrow(group_time[group_time["high"] <= scale_num() ,]),][[sectors_name[sect()]]]
            table_time_up <- group_time[group_time["high"] > scale_num() ,][1,][[sectors_name[sect()]]]
            
            low_num <- group_time[group_time["high"]<= scale_num() ,][nrow(group_time[group_time["high"]<= scale_num() ,]),"high"][[1]]
            high_num <- group_time[group_time["high"]> scale_num() ,][1 ,"high"][[1]]
            
            table_time + (scale_num() - low_num)/(high_num - low_num) * (table_time_up - table_time)
        }
        
    }
    
    elapsed <- reactive({
        if(input$year == "2022년"){
            switch (group_num(),
                    "1" = 1,
                    "2" = 1,
                    "3" = 0.95,
                    "4" = 0.95,
                    "5" = 0.9,
                    "6" = 0.9,
                    "7" = 0.9,
                    "8" = 0.9,
                    "9" = 0.8,
                    "10" = 0.7,
            )
        } else {
            1
        }
        
    })
    
    
    result_time <- reactive({
        if(input$sel5 == "Yes"){
            if(calc_time() * add_rate() * profi() > max_bound()) {
                round(max_bound() * elapsed())
            } else if (calc_time() * add_rate() * profi() < min_bound()){
                round(min_bound() * elapsed())
            } else {
                round(calc_time() * add_rate()  * profi() * elapsed() )
            }
        } else {
            round(calc_time() * add_rate()  * profi() * elapsed())
        }
        
    })
    
    
    output$calc <- renderText({
        round(result_time())
    })
    
    
    
}
# Run the application 
shinyApp(ui = ui, server = server)
