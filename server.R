################################ Server ################################

server <- function(input, output, session){
  
  # List of values for updating while iterations happen:
  updatedValues <-  reactiveValues(fractionRenewed = 0, iterationOutcome = 0)
  
  #Updating the slider input based on percentage change input from user:
  observe({
    updateSliderInput(session = session, "ipOverallChange", min = input$ipPercChange, max = 1.0, step = 0.01)
  })
  
  
  # Exectuing the iterations and saving the number of runs required in each iteration
  observeEvent(eventExpr = input$ipExecSim, {
    origPopulation <- 1:1000 # Ship with a thousand parts
    
    numberOfReplacements <- vector() # declaring vector to store number of replacements required for given fraction of population change
    
    sizeReplacement <- floor(input$ipPercChange*length(origPopulation)) # Number of parts of the original population to change
    
    for(j in 1:1000){ # 1000 iterations are executed for deriving the distribution
      
      newPopulation <- origPopulation # We start with original population
      
      for(i in 1:150){ # at the most 150 rounds of changes are checked for in an iteration
        
        removedPopulation <- sample(x = newPopulation, size = sizeReplacement, replace = F) # sample people out of it
        
        newPopulation[newPopulation %in% removedPopulation] <- ((i*1000+1):(i*1000+sizeReplacement)) # for the replaced ids, assigning new ids
        
        # Breaking the i loop if fraction of population to be replaced reaches its limit
        if((sum(origPopulation %in% newPopulation)/length(origPopulation)) <= (1-input$ipOverallChange)){
          # print(sum(origPopulation %in% newPopulation)/length(origPopulation))
          break
        }
      }
      numberOfReplacements <- c(numberOfReplacements,i) # creating vectors of values where each value is the number of iterations at which the population replaced completely
      if(j %% 200 == 0){
        updatedValues$iterationOutcome <- numberOfReplacements
      }
    }
    
  })
  

  # Plotting the distribution of spans
  output$opIterDistPlot <- renderPlot({
    
    req(updatedValues$iterationOutcome != 0)
    
    numberOfReplacements <- updatedValues$iterationOutcome
      
    ggplot(data = data.frame(numberOfReplacements), aes(x = numberOfReplacements)) +
      geom_density(color = "white") +
      ggtitle("Distribution of Number of Replacements")+
      theme_light()+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_rect(fill = "black"), plot.title = element_text(color = "white"), axis.title.x = element_blank(), axis.title.y = element_blank(), plot.background = element_rect((fill = "black")), plot.margin = margin(0.2, 0.5, 0.2, 0.2, "cm"), axis.text.x = element_text(colour = "white"), axis.text.y = element_text(colour = "white"))+
      geom_vline(xintercept = mean(numberOfReplacements), linetype = "dashed", color = "white")+
      geom_text(aes(y = 0, x = mean(numberOfReplacements),hjust = 0, vjust = 0), label = paste0("Mean Change Span = ", round(mean(numberOfReplacements),2)), color = "white", angle = 90)

  })
  
  
  shipPlot <- eventReactive(eventExpr = input$ipExecSim, valueExpr = {
    
    
    # Coordintates of the polygon enclosing the ship shape
    polygonXYCoord <- data.frame(x = c(30, 70, 90, 53, 53, 80, 53, 47, 47, 10, 30), y = c(10, 10, 40, 40, 60, 75, 90, 90,40,40, 10))
    
    # Parts to be replaced by new parts:
    i1 <- sample(1:10000, input$ipOverallChange*10000, replace = FALSE)
    
    # Entire canvas:
    df <- data.frame(expand.grid(xAxis = 1:100, yAxis = 1:100))
    
    # Identifying the points inside the polygon, marking a fraction of them as "new body part"
    df$insidePolygon <- pointsInPolygon(xy = df, poly = polygonXYCoord)
    df$partFlag <- ifelse(df$insidePolygon == TRUE, "Original Body Part", "Outside")
    fraction <- input$ipOverallChange
    df$partFlag[i1] <- "New Body Part"
    df$partFlag <- ifelse(df$insidePolygon == TRUE, df$partFlag, "Outside")
    
    # Plotting the ship
    ggplot(df, aes(x = xAxis, y = yAxis, color = partFlag))+
      geom_point(size = 3, alpha = 1)+
      scale_color_manual(breaks = c("Outside", "Original Body Part", "New Body Part"),
                         values=c("black", "brown", "orange"))+
      theme_void() +
      theme(panel.background = element_rect("black"), legend.position = c(.97, .97),
            legend.justification = c("right", "top"),
            legend.box.just = "right",
            legend.margin = margin(6, 6, 6, 6),
            legend.background = element_rect("#006272"),
            legend.title = element_blank())
    
    
  })


  # Building the ship:
  output$ship <- renderPlot(shipPlot())
  
  # Read me note:
  readMeNote <<- HTML("Ship of Theseus<br><br>

The ship wherein Theseus and the youth of Athens returned from Crete had thirty oars, and was preserved by the Athenians down even to the time of Demetrius Phalereus, for they took away the old planks as they decayed, putting in new and stronger timber in their places, insomuch that this ship became a standing example among the philosophers, for the logical question of things that grow; one side holding that the ship remained the same, and the other contending that it was not the same.<br>

-Plutarch, Theseus<br><br>

Ship of Theseus is philosopical question on which the jury is still out. It questions the identity of the whole in relation to its parts. A similar philosophical puzzle is also found in Sanskrit Buddhist text titled Mahāprajñāpāramitopadeśa.<br><br>

While our civilization still discusses the puzzle, I have tried to answer a more objective question: if we change a body's parts randomly (can be anything, like a ship in this app) at the rate of X% till we have changed Y% of the body, how long will the process take. I have developed a Monte Carlo to answer this question. The first slider 'Percentage Change' is the X quantity and the second slider 'Overall Change Limit' is Y quantity.<br><br>

The plot of ship shows a visual of the ship with Y% parts changed, and the density plot shows the distribution of the number of changes at X% per change that the simulation took to replace the Y% of the parts.<br><br>

Those who are interested in understanding the details of the simulation are welcome to look at the code behind the app at <a href='https://github.com/AshwiniJha01/Ship-Of-Theseus'> my GitHub page </a>.<br><br>

What's the use? One way I have imagined this information can be useful is for organizations to introspect how long does it take for their organizations to have half of their employees change? The introspection can be useful in understanding cultural changes or any change that accompanies churn of employees. So to answer this question, set the first slider to whatever is the attrition rate of your company, let's say 5% and set the second slider to 50%. Hit the simulation button, and the answer appears to be 14 years. <br><br>

So feel free to use the application's answer to your business case or, maybe, answer some curious questions. <br><br>


<a href='https://www.linkedin.com/in/ashwini-jha-009646125/'> Ashwini Jha <br>
Senior Data Scientist <br>Connect with me on LinkedIn</a>")
  output$readMeNoteText <- renderText({return(readMeNote)})
  
  
}