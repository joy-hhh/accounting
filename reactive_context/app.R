library(shiny)

mydata <- mtcars

ui <- fluidPage(
    
    numericInput("sel", "mtcars 데이터 행의 개수 입력",
                 value = 6, min = 6, max = nrow(mydata)),
    tableOutput("carData"),
)

server <- function(input, output, session) {
    
    output$carData <- renderTable({
        head(mydata, input$sel)
    })
    
    tryCatch({
        x <- input$sel
    }, error = function(c) cat (c$message))

    # Can't access reactive value 'sel' outside of reactive consumer.
    # i Do you need to wrap inside reactive() or observe()?
    # 반응성 맥락이 없는 상태에서는 허용되지 않는 연산이며, 반응성 표현식이나 관찰자 안에서 이루어져야 할 연산을 비반응성 맥락에서 시도했다는 의미.
    
    
    output$distPlot <- renderPlot({
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
