library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)


cdc_df2 <- read.csv('https://raw.githubusercontent.com/charleyferrari/CUNY_DATA_608/master/module3/data/cleaned-cdc-mortality-1999-2010-2.csv')




cdc_df2 <- cdc_df2 %>% group_by(ICD.Chapter, Year) %>% mutate(Nat.Avg = sum(Deaths)/sum(Population) * 10^5)


ui <- fluidPage(
    headerPanel('National Average vs State Mortality Rate per Selected ICD'),
    
    
    sidebarPanel(
        selectInput('icd', 'ICD Chapter', unique(cdc_df2$ICD.Chapter), selected = 'Neoplasms'),
        selectInput('state', 'State', unique(cdc_df2$State),selected = 'CT')
    ),
    
    
    mainPanel(
        plotlyOutput('plot1')
    )
)


server <- function(input, output) {
    
    output$plot1 <- renderPlotly({
        
        
        dfSlice <- cdc_df2 %>% filter(ICD.Chapter == input$icd, State == input$state)
        
        
        plot_ly(dfSlice, x = ~Year, y = ~Crude.Rate, type = "scatter",  name = input$state, mode = "markers", source = "subset") %>%
            layout(
                xaxis = list(title = 'Year'),
                yaxis = list(title = 'Deaths'),
                plot_bgcolor = "white")%>%
            add_trace(y = ~dfSlice$Nat.Avg, name = 'National Average',mode = 'markers')
    })
    
    
}

shinyApp(ui = ui, server = server)
