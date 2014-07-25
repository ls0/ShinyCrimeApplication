library(shiny)
library(dplyr)
library(ggplot2)
library(reshape2)
# organize data for usage in shinyServer
crime.by.state <- read.csv("crime.by.state.csv", sep=",")
a <- crime.by.state %.%
  arrange(State, Year) %.%
  select(State, Year, Crime, Count) %.%
  group_by(State, Year) 
# organize data for 2012 table output
crime2012 <- crime.by.state %.%
  filter(Year==2012) %.%
  dcast(Year + State ~ Crime)
# outputs for tables in tabs of most recent crime data
typeProperty <- crime2012 %.%
  select(State, Year, propertyCrime) %.%
  arrange(propertyCrime) %.%
  mutate(Order = 1:50)
typeViolent <- crime2012 %.%
  select(State, Year, violentCrime) %.%
  arrange(violentCrime) %.%
  mutate(Order = 1:50)
typeTotal <- crime2012 %.%
  select(State, Year, Total) %.%
  arrange(Total) %.%
  mutate(Order = 1:50)
shinyServer(function(input, output) {
  
  output$crimePlot <- renderPlot({
    
    # retrieve state with input$state
    crime<-filter(a, State == input$state)
    
    # draw ggplot with the selected State
    ggplot(data=crime, aes(x=Year, y=Count, colour=Crime)) +
      geom_point(size=3) +
      geom_line(aes(linetype=Crime)) +
      stat_smooth(method="loess", aes(group=Crime), lwd=1.2) +
      scale_color_manual(values = c("cadetblue4","chartreuse4", "firebrick4")) +
      xlab("Year of Crime") +
      ylab("Number of Crimes/Year/100,000 Individuals") +
      ggtitle(paste0("Crimes Committed in ", input$state, " from 1960-2012")) +
      theme(text = element_text(size = 17, colour="black"))
    
  })
  output$crimePlot2 <- renderPlot({
    
    # retrieve state with input$state
    crime2<-filter(a, State == input$state2)
    
    # draw ggplot with the selected State
    ggplot(data=crime2, aes(x=Year, y=Count, colour=Crime)) +
      geom_point(size=3) +
      geom_line(aes(linetype=Crime)) +
      stat_smooth(method="loess", aes(group=Crime), lwd=1.2) +
      scale_color_manual(values = c("blue4", "black", "firebrick4")) +
      xlab("Year of Crime") +
      ylab("Number of Crimes/Year/100,000 Individuals") +
      ggtitle(paste0("Crimes Committed in ", input$state2, " from 1960-2012")) +
      theme(text = element_text(size = 17, colour="black")) 
  })
  output$crimeTable <- renderDataTable({
    crime<-filter(a, State == input$state)
    Total_Crimes_In_State <- filter(crime, Crime == "Total")
    Total_Crimes_In_State
  })
  output$crimeTable2 <- renderDataTable({
    crime2<-filter(a, State == input$state2)
    Total_Crimes_In_State <- filter(crime2, Crime == "Total")
    Total_Crimes_In_State
  })
  output$propertyCrime <- renderDataTable({
    typeProperty
  })
  output$violentCrime <- renderDataTable({
    typeViolent
  })  
  output$Total <- renderDataTable({
    typeTotal
  }) 
})
