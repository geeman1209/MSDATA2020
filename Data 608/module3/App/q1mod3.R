library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)
rsconnect::deployApp(appName = 'mod3q1')


cdc_df <- read.csv('https://raw.githubusercontent.com/charleyferrari/CUNY_DATA_608/master/module3/data/cleaned-cdc-mortality-1999-2010-2.csv')


ui <- fluidPage(
    headerPanel('States Ranked Per Crude Rate Per ICD'),
    sidebarPanel(
        selectInput('icd', 'ICD Chapter', unique(cdc_df$ICD.Chapter), selected='External causes of morbidity and mortality'),
        selectInput('Year', 'Year', unique(cdc_df$Year), selected=2010)
    ),
    mainPanel(
        plotOutput('plot1')
    )
)

server <- function(input, output) {
    
    output$plot1 <- renderPlot({
        
        dfSlice <- cdc_df %>%
            filter(ICD.Chapter == input$icd, Year == input$Year)
        
        ggplot(dfSlice, aes(x = Crude.Rate , y = reorder(State, Crude.Rate), fill= State)) +
            geom_bar(stat='identity') +
            ylab("State") + 
            theme(axis.text.y = element_text(size = 11, hjust = 1))
    })
    
    
}

shinyApp(ui = ui, server = server)
