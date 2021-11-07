library(shiny)

ui <- fluidPage(

    fileInput("selFile", "Select file", buttonLabel = "Select file"),
    tableOutput("tbl")
)

options (shiny.maxRequestSize = 30 * 1024 ^ 2)
server <- function(input, output, session) {

    output$tbl <- renderTable({
        req(input$selFile)
        read.csv(input$selFile$datapath)
            })
}

# Run the application 
shinyApp(ui = ui, server = server)
