
# import required packages
library(shiny)
library(tidyverse)
library(ggforce)
library(hexbin)


# Define UI for application (inputs and outputs)
ui <- fluidPage(
    
    fluidRow(column(3),
             column(6, h1("NHL Shot Location Data"), h3("an ongoing endeavor...")),
        column(3)),
    
    sidebarPanel(
        p('This app visualizes the shot locations from all 82 games of the 2018-19 NHL season, for all 31 teams.'),
        selectInput(inputId = "team", label = "Select a team",
                    choices = list("ANA", "ARI", "BOS", "BUF", "CAR", "CBJ", 
                                   "CGY", "CHI", "COL", "DAL", "DET", "EDM", "FLA", 
                                   "LAK", "MIN", "MTL", "NJD", "NSH", "NYI", "NYR", 
                                   "OTT", "PHI", "PIT", "SJS", "STL", "TBL", "TOR", 
                                   "VAN", "VGK", "WPG", "WSH"), selected = 'PIT'),
        # result
        selectInput(inputId = "result", label = "Select a result",
                    choices = list("All", "Goal", "Save"), selected = 'Goal')    
    ),
    
    # output plots
    mainPanel(
        plotOutput(outputId = "shotMap")    
    )

    
)


# Define server logic required to draw the plot
server <- function(input, output) {
    
    
    output$shotMap <- renderPlot({
    
        goals <- read.csv(paste('Datasets/', input$team, 'goal.csv', sep = ''))
        
        if(input$result != 'Goal'){ # will need this either way
            saves <- read.csv(paste('Datasets/', input$team, 'save.csv', sep = ''))
        }
       
        
        baseplot <- ggplot(goals, aes(x = x_coord, y = y_coord_flip)) + theme_no_axes() +

            # Draw a hockey rink:
            geom_vline(colour = 'black', xintercept = 100) +
            geom_hline(colour = 'black', yintercept = -43)+
            geom_hline(colour = 'black', yintercept = 43) +
            geom_vline(colour = 'red', xintercept = 89) +
            geom_vline(colour = 'red', xintercept = 0, size = 1) +
            geom_vline(colour = 'blue', xintercept = 25) +

            # dots and circles
            geom_point(x = 69, y = 22, size = 2, colour = 'red', alpha = .5) +
            geom_ellipse(aes(x0 = 69, y0 = 22, a = 15, b = 15, angle = 0), colour = 'red', alpha = .5) +

            geom_point(x = 69, y = -22, size = 2, colour = 'red', alpha = .5) +
            geom_ellipse(aes(x0 = 69, y0 = -22, a = 15, b = 15, angle = 0), colour = 'red', alpha = .5) +

            geom_point(x = 0, y = 0, size = 2, colour = 'blue', alpha = .5) +
            geom_ellipse(aes(x0 = 0, y0 = 0, a = 15, b = 15, angle = 0), colour = 'red', alpha = .5) +

            geom_point(x = 20, y = 22, size = 2, colour = 'blue', alpha = .5) +
            geom_point(x = 20, y = -22, size = 2, colour = 'blue', alpha = .5) +

            # goal
            geom_rect(xmin = 89, xmax = 92.5, ymin = -3, ymax = 3) +

            coord_fixed(ylim = c(-42.5, 42.5), xlim = c(0, 100)) +
            labs(title = paste('Team: ', input$team, sep = ''))+
            theme(legend.position = "none")

            # actual data
            # two different datasets, so we only have to handle the data we're visualizing
            if(input$result == 'Goal'){
                p <- baseplot + geom_jitter(alpha = .5, height = 1, width = .1, colour = 'red') +
                labs(subtitle = 'Goals')
            }else if(input$result == 'Save'){
                p <- baseplot + geom_hex(data = saves, alpha = .5)+
                    scale_fill_gradient(low = "light grey", high = "black") +
                    labs(subtitle = 'Shots Saved')
            }else if(input$result == 'All'){
                p <- baseplot + geom_hex(data = saves, alpha = .5)+
                    scale_fill_gradient(low = "light grey", high = "black") +
                    
                    geom_jitter(alpha = .5, height = 1, width = .1, colour = 'red') +
                    labs(subtitle = 'All Shots (Goals in Red)')
                    
            }
        

        print(p)
    })

    
    
        
}


# Run the application 
shinyApp(ui = ui, server = server)



