library(shiny)

ui <- fluidPage(

    fileInput("selFile", "Select file", buttonLabel = "Select file"),
    
    numericInput("PM",
                 "Tolerable misstatement",
                 700000000,
                 min = 1,
                 max = Inf
    ),
    
    
    
    textOutput("tbl")
    
)

options (shiny.maxRequestSize = 30 * 1024 ^ 2)
server <- function(input, output, session) {
    
    sampling <- observe(input$PM)
    
    output$tbl <- renderText({
        req(sampling)
        sampling
    })    
}

# Run the application 
shinyApp(ui = ui, server = server)
