library(shiny)
library(markdown)

shinyUI(navbarPage(
    title = 'mtcars - transmission type vs fuel economy',
    tabPanel('Data', 
        mainPanel(
            absolutePanel(
                top = 50, left = 10, right = 0,
                dataTableOutput('table')
            ),
            absolutePanel(
                top = 20, right = 20, width = 300,
                draggable = TRUE,
                wellPanel(
                    h3("Download current dataset"),
                    downloadButton('downloadData', 'Download'),
                    hr(),
                    h3("Add new model"),
                    p("Drag the input panel to see all available options."),
                    textInput("model", "Model:",""),
                    numericInput("mpg", "Miles/(US) gallon:", 0, min=0, step=0.1),
                    numericInput("cyl", "Number of cylinders:", 0, min=0, step=1),
                    numericInput("disp", "Displacement (cu. in.):", 0, min=0, step=1),
                    numericInput("hp", "Gross horsepower:", 0, min=0, step=1),
                    numericInput("drat", "Rear axle ratio:", 0, min=0, step=0.01),
                    numericInput("wt", "Weight (lb/1000):", 0, min=0, step=0.1),
                    numericInput("qsec", "1/4 mile time:", 0, min=0, step=0.1),
                    selectInput("vs", "Engine shape:", choices = c("V-type"=0, "Straight"=1)),
                    selectInput("am", "Transmission type:", choices = c("Automatic"=0, "Manual"=1)),
                    numericInput("gear", "Number of forward gears:", 0, min=0, step=1),
                    numericInput("carb", "Number of carburators:", 0, min=0, step=1),
                    br(),
                    actionButton("goButton", "Add to the dataset")
                ),
                style = "opacity: 0.92"
            )
        )
    ),
    tabPanel('Model', 
            mainPanel(
                absolutePanel(
                    top = 50, left = 10, right = 0,
                    verbatimTextOutput('model.summary')
                ),
                absolutePanel(
                    top = 20, right = 20, width = 300,
                    draggable = TRUE,
                    wellPanel(
                        h3("Model variables"),
                        p("Select variables to use as predictors, with mpg as response. Note that since we are interested in the importance of transmission type, am is included by default."),
                        checkboxGroupInput("modelVariables", label=NULL,
                            choices = list("Number of cylinders - cyl" = "factor(cyl)", "    cyl interaction with am" = "factor(cyl)*factor(am)",
                                           "Displacement - disp" = "disp", "    disp interaction with am" = "disp*factor(am)",
                                           "Gross horsepower - hp" = "hp", "    hp interaction with am" = "hp*factor(am)",
                                           "Rear axle ratio - drat" = "drat", "    drat interaction with am" = "drat*factor(am)",
                                           "Weight - wt" = "wt", "    wt interaction with am" = "wt*factor(am)",
                                           "1/4 mile time - qsec" = "qsec", "    qsec interaction with am" = "qsec*factor(am)",
                                           "Engine shape - vs" = "vs", "    vs interaction with am" = "vs*factor(am)",
                                           "Number of forward gears - gear" = "gear", "    gear interaction with am" = "gear*factor(am)",
                                           "Number of carburators - carb" = "carb", "    carb interaction with am" = "hp*factor(am)"
                            )
                        ),
                        br(),
                        actionButton("buildButton", "Build a model")
                     ),
                     style = "opacity: 0.92"
                 )
             )
    ),
    tabPanel('Diagnostics', 
        mainPanel(
            absolutePanel(
                top = 50, left = 10, right = 0,
                h2("Diagnostic plots"),
                plotOutput("residualsVsFitted",width=800,height=800),
                plotOutput("normalQQ",width=800,height=800),
                plotOutput("scaleLocation",width=800,height=800),
                plotOutput("residualsVsLeverage",width=800,height=800)
            )
        )
    )
))