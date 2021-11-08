library(shiny)
library(dplyr)
library(tidyr)
library(readxl)
library(writexl)
options(scipen = 999)


ui <- fluidPage(
    
    titlePanel("Sampling Tool"),
    
    radioButtons("method",
                 "MUS or Random",
                 c("MUS" = "MUS", "Random" = "Random")
    ),
    
    fileInput("selFile",
              "Select Excel File",
              buttonLabel = "Select File"
    ),
    
    textInput('amount', label = 'Enter the amount Row Name', 
              value = 'CR', 
              placeholder = 'Row Name'),
    textOutput("amount"),
    
    tags$br(),
    
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
    textOutput("Expected"),
    
    
    tags$br(),

    
    actionButton(inputId = "click", label="Sampling"),
    
    downloadLink("downloadData", "Download"),
    
    tableOutput("tbl")
    
    
    
)

options (shiny.maxRequestSize = 30 * 1024 ^ 2)
server <- function(input, output, session) {


    observe({
    PM <- as.integer(input$PM)
    EA <- 0.05
    EM <- PM * EA
    

    observeEvent(input$EM, { 
        EA <<- input$EM
        EM <<- PM * EA
    })
    
    
    observeEvent(input$EM, {
        output$Expected = renderText(paste("Expected misstatement is ", EM))
    })
    
    
    })    
    
        
    observeEvent(input$amount, {
        output$amount = renderText(paste("Rowname of amount is ", input$amount))
    })

    observeEvent(input$click, {
        req(input$selFile)
        pop <- read_excel(input$selFile$datapath)
        pop <- pop %>% rename(amount = input$amount)
        mus_sampling <- \(SR, RC, PL, PM, EM){
            
            ## Assurance Factor 
            
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
            sampling_interval = (PM - EM) / AF
            
            ## Expected Sample Size = (Population Subject to Sampling X Assurance Factor) / (Tolerable Misstatement – Expected Misstatement)
            pop_amount <- pop$amount %>% sum()
            sample_size = pop_amount * AF / (PM - sum_High_value_items - EM)
            
            
            sampling_row <- seq(sample_size)    
            sampling_n <- seq(sample_size) * sampling_interval
            
            pop <- pop %>% 
                mutate(cum = cumsum(amount))
            
            for (i in seq_along(sampling_n)) {
                sampling_row[i] <- which(pop$cum > sampling_n[i])[1]
            }
            sampling_row <- sampling_row %>% unique()

            ## sampling object creation
            sampling <<- pop %>% 
                select(-cum) %>% 
                slice(sampling_row)
        }
        
        mus_sampling(input$SR, input$RC, input$PL, PM, EM)
        
        output$tbl <- renderTable({
            req(sampling)
            sampling
        })
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
