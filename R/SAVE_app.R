#################
# Shiny App - NNT 
##################



library(shiny)
library(devtools)
#install_github('gilles-guillot/NNT')  #new
library(NNT)

ui <- fluidPage(
  
  fluidRow(
    column(4),
    column(5,tags$h1("NNT computation"))
          ),
  
  tags$h5("This app allows you to easily compute the number needed to treat. It was developed at", tags$a(href="https://i-pri.org/",tags$u("iPRI")),"in the context of the following article:"),
  tags$em("Patrick Mullie, Gilles Guillot, Philippe Autier, Cécile Pizot, Peter Boyle. Efforts needed for preventing breast and colorectal cancer through changes in dietary patterns."),
  tags$h5("This app used the R package NNT available", tags$a(href= "https://github.com/gilles-guillot/NNT",tags$u("here."))),

  tags$br(),
  
  tags$head(
    tags$style(HTML(
      "label {font-weight:normal;}"
    ))
  ),
  
  fluidRow(
    column(3,tags$strong("First exposure group")),
    column(4,numericInput(inputId = "cases1", 
                        label = "Enter the number of cases observed in the first exposure group",
                        value = "",
                        min=0)),
    column(4,numericInput(inputId = "py1", 
                          label = "Enter the number of PY in the first exposure group",
                          value = "",
                          min=1))
          ),
  
  fluidRow(
    column(3,tags$strong("Second exposure group")),
    column(4,numericInput(inputId = "cases2", 
                          label = "Enter the number of cases observed in the second exposure group",
                          value = "",
                          min=0)),
    column(4,numericInput(inputId = "py1", 
                          label = "Enter the number of PY in the second exposure group",
                          value = "",
                          min=1))
          ),
  
  tags$br(),
  
  fluidRow(
    column(5),
    column(2,actionButton(inputId = "button_compute", label = "Compute NNT",style="color: #fff; background-color: #337ab7; border-color: #2e6da4;font-weight:bold"))
          ),
  
  tags$br(),
  tags$br(),
  
  textOutput("Error"),
  tags$head(tags$style("#Error{color: red;
                       font-weight: bold;
                       }")),
  
  textOutput("NNT"),
  
  textOutput("ARR")
  
  # plotOutput("plot")
)

server <- function(input, output) {

  NNT_computation <- eventReactive(input$button_compute,{
      compute_NNT(c(input$cases1,input$cases2),c(input$py1,input$py2),0.05)
  })

  output$ARR <- renderText({
    ARR <- NNT_computation()[["ARR"]]
    ARR_CI <- NNT_computation()[["CI_ARR"]]
    paste("The absolute risk reduction is:",format(round(ARR,5),nsmall=5),"with 95%CI",paste("[",paste(format(round(ARR_CI,5),nsmall=5),collapse="; "),"]"),sep=" ")
  })
  
  output$NNT <- renderText({
    NNT <- NNT_computation()[["NNT"]]
    NNT_CI <- NNT_computation()[["CI_NNT"]]
    paste("The number needed to treat is:",round(NNT),"with 95%CI",paste("[",paste(round(NNT_CI),collapse="; "),"]"),sep=" ")
  })
    
  output$Error <- renderText({
    if(NNT_computation()[["ARR"]]<0){"Warning: The ARR is negative, check your data!"}
    else{""}
  })
  

 
  # output$plot <- renderPlot({
  #   title <- "NNT with CI"
  #   plot(c(input$cases1,input$cases2),c(input$py1,input$py2),main=title)
  # })
  
}

shinyApp(ui = ui, server = server)