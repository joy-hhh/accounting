library(shiny)

ui <- fluidPage(

    fileInput("selFile", "Select file", buttonLabel = "Select file"),
    
    numericInput("PM",
                 "Tolerable misstatement",
                 700000000,
                 min = 1,
                 max = Inf
    ),
    
    
    
    
    tableOutput("tbl"),
    
)

options (shiny.maxRequestSize = 30 * 1024 ^ 2)
server <- function(input, output, session) {
    
    observe(
    
    PM <- as.integer(input$PM)
    )
    
    test <- \(){
        sampling <<- PM
    }
    
    test()
    
    output$tbl <- renderTable({
        req(sampling)
        sampling
    })    
}

# Run the application 
shinyApp(ui = ui, server = server)
