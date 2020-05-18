function(input, output, session) {
  

  
  mean = reactive({  
    df = as.numeric(input$mean) 
    return(df)  
  
  
  })
  
  
  sd = reactive({  
    df = as.numeric(input$sd) 
    return(df)  
    
    
  })
  
  
  room1 = reactive({  
    df = as.numeric(input$room1) 
    return(df)  
    
    
  })
  
  
  room2 = reactive({  
    df = as.numeric(input$room2) 
    return(df)  
    
    
  })
  
  
  room3 = reactive({  
    df = as.numeric(input$room3) 
    return(df)  
    
    
  })
  
  room4 = reactive({  
    df = as.numeric(input$room4) 
    return(df)  
    
    
  })
  
  room5 = reactive({  
    df = as.numeric(input$room5) 
    return(df)  
    
    
  })
  
  
  
  data = reactive({
    
    
    
    data = c(1:3)
    
    data = as.data.frame(data)
    
    colnames(data)[1] = "Hour"
  
  
       data$Emergency = round(rnorm(nrow(data), mean(), sd() ),0)
  
  
  
  
       data$PatientRoom1 = round(pmin((1/3) * data$Emergency, room1()),0)
  
  
       data$PatientRoom2 = round(pmin((1/3) * data$Emergency, room2()),0)
  
       data$PatientRoom3 = round(pmin((1/3) * data$Emergency, room3()),0)
  
  
       data$waitingPatientRoom1 = round(pmax(pmin(data$Emergency - data$PatientRoom1 - data$PatientRoom2 - data$PatientRoom3, 10),0),0)
  
       data$PatientRoom4 = round(pmax(pmin(data$Emergency - data$PatientRoom1 - data$PatientRoom2 - data$PatientRoom3-data$waitingPatientRoom1, 
                                      room4()),0),0)
  
       data$PatientRoom5 = round(pmax(pmin(data$Emergency - data$PatientRoom1 - data$PatientRoom2 - data$PatientRoom3-data$waitingPatientRoom1 -
                                        data$PatientRoom4, room5()),0),0)
  
  
  
  
  
  
  
  
  
  #data$WaitingRoom2 = round(pmax(pmin(data$Emergency - data$waitingPatientRoom1 - data$PatientRoom1 - data$PatientRoom2 - data$PatientRoom3, 30),0),0)
  
       data$Excess = round(pmax(data$Emergency - data$PatientRoom1 - data$PatientRoom2 - data$PatientRoom3-data$PatientRoom4 - 
                             data$PatientRoom5-data$waitingPatientRoom1,0),0)
  
  
  
  data[2, 9] = pmax(data[1,9] + data[2,2] - data[2,3] - data[2,4] - data[2,5] - data[2,6] - data[2,7],0)
  
  data[3, 9] = pmax(data[2,9] + data[3,2] - data[3,3] - data[3,4] - data[3,5] - data[3,6] - data[3,7],0)
  
  return(data)
  
  
  
  })
  
  
  
  

  
  #############
  # Combine the selected variables into a new data frame
  output$plot1 <- renderPlotly({
    
 
    ####
    
    
   
    
    
    df = data() %>% gather("WaitingPatientRooms", "Occupancy", - c("PatientRoom1", "PatientRoom2", "PatientRoom3",
                                                                 "PatientRoom4", "PatientRoom5",
                                                                 "Emergency", "Hour", "Excess")) %>%
      
                    gather("PatientRooms", "Occupancy2", - c("Emergency" ,"Hour", "Excess", "WaitingPatientRooms", "Occupancy"))
    
    
    
    
    df$Dummy = round(runif(nrow(df), 0, 100),0)
    
    
    df$Intake = "Intake1"
    
    df$Intake = ifelse(df$Dummy<50, "Intake2", "Intake1" )
    
    df2 = df
    
    df2$Intake = "Intake3"
    
    df2$Dummy = round(runif(nrow(df), 0, 100),0)
    
    df2$Intake = ifelse(df$Dummy<50, "Intake3", "Intake4" )
    
    df2$PatientRooms = "WaitingRoom2"
    
    df3 = df
    
    
    df4 = df
    
    
    df5 = df
    
    
    df3$Occupancy2 = 1
    
    df3$Intake = "Intake1"
    
    
    df4$Occupancy2 = 1
    
    df4$Intake = "Intake2"
    
    
    df = rbind(df2, df)
    
    df$Occupancy2 = ifelse(df$PatientRooms == "WaitingRoom2", df$Excess, df$Occupancy2)
    
    
    
    df = rbind(df, df3)
    
    df = rbind(df, df4)
    
    
    
    #####################3
    
    
    
    nodes = data.frame("name" = 
                         c("Hour1",
                           "Hour2",
                           "Hour3",
                           #"Hour4",
                           #"Hour5",
                           #"Hour6",
                           #"Hour7",
                           #"Hour8",
                           #"Hour9",
                           #"Hour10",
                           #"Hour11",
                           #"Hour12",
                           "Intake1", # Node 0
                           "Intake2", # Node 1
                           "Intake3", # Node 2
                           "PatientRoom1", # Node 1
                           "PatientRoom2",
                           "PatientRoom3",
                           "PatientRoom4",
                           "PatientRoom5",
                           "WaitingRoom2",
                           "Records",
                           "WaitingRoom1"
                         ))# Node 3
    
    
    nodelookup = nodes
    
    nodelookup$Column1 = c(0:13)
    
    colnames(nodelookup)[1]="Intake"
    
    
    dfNodes = right_join(nodelookup, df, by = "Intake")
    
    nodelookup2 = nodelookup
    
    
    colnames(nodelookup2)[1]="PatientRooms"
    colnames(nodelookup2)[2]="Column2"
    
    
    dfNodes = right_join(nodelookup2, dfNodes, by = "PatientRooms")
    
    nodelookup3 = nodelookup
    
    colnames(nodelookup3)[1]="Hour"
    colnames(nodelookup3)[2]="Column0"
    
    nodelookup3$Hour=c(1:14)
    
    dfNodes = right_join(nodelookup3, dfNodes, by = "Hour")
    
    dfSankey1 = dfNodes %>% dplyr::select(Column1, Column2, Occupancy2)
    
    dfSankey2 = dfNodes %>% dplyr::select(Column0, Column1, Occupancy2)
    
    colnames(dfSankey2)[1]="Column1"
    
    colnames(dfSankey2)[2]="Column2"
    
    
    dfSankey2a = dfSankey2
    
    dfSankey2a$Column1 = 13
    
    dfSankey2$Column2 = 13
    
    
    dfSankey = rbind(dfSankey1, dfSankey2)
    
    dfSankey = rbind(dfSankey, dfSankey2a)
    
    
    dfSankeyWait = dfSankey %>% filter(Column1 != 13) %>% filter(Column2 !=13)
    
    dfSankeyWait$Column2 = 13
    
    dfSankey = rbind(dfSankey, dfSankeyWait)
    
    
    
    dfSankey3 = dfNodes %>% filter(PatientRooms == "WaitingRoom2") %>%
      dplyr::select(Column2, Occupancy2)
    
    colnames(dfSankey3)[1] = "Column1"
    
    dfSankey3$Column2 = c(6,7,8,9,10, 6,7,8,9,10, 6,7,8,9,10)
    
    dfSankey = rbind(dfSankey, dfSankey3)
    
    
    dfSankey4 = rbind(dfSankey1, dfSankey2)
    
    dfSankey4$Column1 = NULL
    
    colnames(dfSankey4)[1] = "Column1" 
    
    dfSankey4$Column2 = 12
    
    dfSankey4 = dfSankey4 %>% filter(Column1 !=13) %>% filter(Column1 !=11)
    
    dfSankey = rbind(dfSankey, dfSankey4)
    
    

    
    fig <- plot_ly(
      type = "sankey",
      orientation = "h",
      
      node = list(
        label = nodes$name,
        #color = c("blue", "blue", "blue", "blue", "blue", "blue"),
        pad = 15,
        thickness = 20,
        line = list(
          color = "white",
          width = 0.5
        )
      ),
      
      link = list(
        
        source = dfSankey$Column1,
        target = dfSankey$Column2,
        value =  dfSankey$Occupancy2
        
      )
    )
    
    t <- list(
      #family = "sans serif",
      size = 24,
      color = 'blue')
    
    
    fig <- fig %>% layout(
                          paper_bgcolor = '#AEB6BF', width = 1200, height = 450,
    
      font = t
     # )
    )
    
    
    fig
    
    
  
      
  })
  
 
  output$patientbox <- renderValueBox({
    
    
   
    
    dataBox1 = data() %>% filter(Hour ==1)
    
    
    valueBox(paste0("Excess Capacity: ", dataBox1$Excess  ), 
             "Hour One", icon = icon(""), color = "black")
  }) 
  
  
  
  output$patientbox2 <- renderValueBox({
    
    
    
    dataBox2 = data() %>% filter(Hour ==2)
    
    
    valueBox(paste0("Excess Capacity: ", dataBox2$Excess  ), 
             "Hour Two", icon = icon(""), color = "black")
  }) 
  
 
  output$patientbox3 <- renderValueBox({
    
    
    
    dataBox3 = data() %>% filter(Hour ==3)
    
    
    valueBox(paste0("Excess Capacity: ", dataBox3$Excess), 
             "Hour Three", icon = icon(""), color = "black")
  })  
  
  
  

    
    
    
    
    
    
    
 
    
    
    
    
    
    
    

  
  
  
    
 
  
  
  
}
