library(shiny)
library(readxl)
library(writexl)
library(dplyr)


ui <- fluidPage(
    titlePanel("Sampling Tool"),
            fileInput("selFile",
                      "파일선택",
                      buttonLabel = "파일선택"),
            tableOutput("tbl"),
            
            
            numericInput("PM",
                         "Tolerable misstatement",
                         700000000,
                         min = 1,
                         max = Inf
                         ),
            selectInput("SR",
                        "Significant Risk",
                        choices = c("Yes", "No")
                        ),
            selectInput("RC",
                        "Reliance.on.Controls",
                        choices = c("Yes", "No")
                        ),
            selectInput("PL",
                        "Planned Level of Assurance from Substantive Analytical Procedures",
                        choices = c("Not.Performed", "Low", "Moderate","High" )
                        ),
            sliderInput("EM",
                        "Expected misstatement",
                        min = 0,
                        max = 0.1,
                        value = 0.05,
                        step = 0.01
                        ),
            radioButtons("method",
                         "MUS or Random",
                         c("MUS" = "MUS", "Random" = "Random")
            ),
            
            
            downloadLink("downloadData", "Download")
                        
               
       
)

options (shiny.maxRequestSize = 30 * 1024 ^ 2)
server <- function(input, output, session) {
    
    output$tbl <- renderTable({
        req(input$selFile)
        read_excel(input$selFile$datapath)
        
    })
    

    output$downloadData <- downloadHandler(
        filename = function() {
            paste0("sample-",Sys.Date(),".xlsx")    
        },
        content = function(file){
            write_xlsx(data, file)
        }
    )

}



shinyApp(ui = ui, server = server)
