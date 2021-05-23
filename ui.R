# Installing and reading in the necessary libraries:
libList <- c("dplyr", "ggplot2","DT", "shiny","shinythemes","shinydashboard","shinyWidgets","markdown", "secr")

new.packages <- libList[!(libList %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, dependencies = TRUE)
lapply(libList, require, character.only = TRUE)

# library(dplyr)
# library(DT)
# library(shiny)
# library(shinythemes)
# library(shinydashboard)
# library(shinyWidgets)
# library(markdown)


## Building the ui.R -----------------------------------------------------------

## 1. Header ----------------------------------------------

header <- dashboardHeader(
  tags$li(class = "dropdown",
          tags$style(".main-header {max-height: 20px;font-size:20px;font-weight:bold;line-height:20px;"),
          tags$style(".navbar {min-height:1px !important;font-weight:bold;")), title ="Ship of Theseus",
  tags$li(a(img(src = 'nameLogo.png'),href='https://www.linkedin.com/in/ashwini-jha-009646125/',
            style = "padding-top:4px; padding-bottom:1px;"),class = "dropdown"),titleWidth = 200)


## 3. Body --------------------------------
bodyD <- dashboardBody(
  
  ## 3.0 Setting skin color, icon sizes, etc. ------------
  
  ## modify the dashboard's skin color
  tags$style(HTML('
                       /* logo */
                       .skin-blue .main-header .logo {
                       background-color: #006272;
                       }
                       /* logo when hovered */
                       .skin-blue .main-header .logo:hover {
                       background-color: #006272;
                       }
                       /* navbar (rest of the header) */
                       .skin-blue .main-header .navbar {
                       background-color: #006272;
                       }
                       /* active selected tab in the sidebarmenu */
                       .skin-blue .main-sidebar .sidebar .sidebar-menu .active a{
                       background-color: #006272;
                       }
                       .nav-tabs>li>a {
                        color: #006272; background-color: black;border: 2px solid #f6f6f6;
                       }
                       .nav-tabs>li.active>a {
                        color: white; background-color: #006272;border: 2px solid #f6f6f6;
                       }
                       .nav-tabs>li.active>a, .nav-tabs>li.active>a:focus, .nav-tabs>li.active>a:hover {
                       color: white; background-color: #006272;border: 2px solid #f6f6f6;
                       }
                       label {
                       display: inline-block; max-width: 100%; margin-top: 15px; font-weight: 700; color: white;
                       }
                  ')
  ),
  
  ## modify icon size in the sub side bar menu
  tags$style(HTML('
                       /* change size of icons in sub-menu items */
                      .sidebar .sidebar-menu .treeview-menu>li>a>.fa {
                      font-size: 15px;
                      }
                      .sidebar .sidebar-menu .treeview-menu>li>a>.glyphicon {
                      font-size: 13px;
                      }
                      /* Hide icons in sub-menu items */
                      .sidebar .sidebar-menu .treeview>a>.fa-angle-left {
                      display: none;
                      }
                      '
  )) ,
    
  ## making background black
  setBackgroundColor(
    color = "black",
    gradient = "radial",
    shinydashboard = T
  ),
  
  
  ## 3.1 Dashboard body --------------
  
  tabsetPanel(
    
    ############################## First tab "App" ##############################
    tabPanel(# Tab name
      h2("Ship of Theseus"),
      
      # Slider inputs for % change per change and % overall change
      chooseSliderSkin(skin = "Flat", color = "#006272"),
      fluidRow(
        column(
          width = 4,
          offset = 0,
          align = "center",
          sliderInput(inputId = "ipPercChange", label = "Percentage Change", min = 0.01, max = 0.99, value = 0.05, step = 0.01, round = F, ticks = F, animate = F)
          ),
        column(
          width = 4,
          offset = 0,
          align = "center",
          sliderInput(inputId = "ipOverallChange", label = "Overall Change Limit", min = 0.01, max = 1.00, value = 0.70, step = 0.01, round = F, ticks = F, animate = F)
        ),
        column(
          width = 4,
          offset = 0,
          align = "center",
          actionButton(inputId = "ipExecSim", "Run Simulation", icon = icon("dice"), width = "75%", style="color: #fff; background-color: #006272; border-color: #006272;margin-top: 36px")
        )),
      
      
      # Plots
      fluidRow(
        
        # Ship's plot
        column(
          width = 6,
          offset = 0,
          align = "center",
          # dataTableOutput("ship")
          plotOutput("ship")
        ),
        
        # Number of iterations plot
        column(
          width = 6,
          offset = 0,
          align = "center",
          plotOutput("opIterDistPlot")
        )
        )
      ),
    
    
    
    ############################## Read me note tab ############################## 
    tabPanel(
      h2("About"),
      
      fluidRow(
        column(8, align="left", offset = 2,
               h1("Namaste",style = "background-color:#000000; color:#FFFFFF;font-style: italic;")
        )
      ),
      
      column(8, align="left", offset = 2,
             htmlOutput('readMeNoteText'),
             tags$head(tags$style("#readMeNoteText{color: #FFFFFF;
                                 font-size: 15px;
                                 font-style: italic;
                                 }"
             )
             )
      )
    )
    
    
  )
  
)# dashboardBody closes here

## put UI together --------------------
ui <-  dashboardPage(header, dashboardSidebar(disable = T), bodyD)


