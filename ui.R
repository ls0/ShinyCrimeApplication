library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Crime in US State Per 100,000 Individuals"),
  
  # Sidebar that selects state1 and state2
  sidebarLayout(
    sidebarPanel(
      selectInput('state', 'Select State 1', 
                  c(Choose='Maryland', state.name), 
                  selectize=FALSE),
      selectInput('state2', 'Select State 2', 
                  c(Choose='Colorado', state.name), 
                  selectize=FALSE),
      p("The Shiny Application allows user to choose any two of the fifty United States and returns crime statistics.
        Additionally, user can access the most current (2012) crime data sorted from low to high crime rates in tabs.")
    ),
    
    # Show crime plot of selected State and total crimes
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", 
               plotOutput("crimePlot"),
               plotOutput("crimePlot2")),
        tabPanel("State 1 Total",
               dataTableOutput("crimeTable")),
        tabPanel("State 2 Total",
                dataTableOutput("crimeTable2")),
        tabPanel("Property Crime",
                 dataTableOutput("propertyCrime")),
        tabPanel("Violent Crime",
                 dataTableOutput("violentCrime")),
        tabPanel("Total Crime",
                 dataTableOutput("Total"))
        )
      )
    )
  )
  )

