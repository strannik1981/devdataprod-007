library(shiny)
library(markdown)

shinyUI(navbarPage(
    title = 'mtcars - transmission type vs fuel economy',
    tabPanel('Data', 
        mainPanel(
            absolutePanel(
                top = 50, left = 10, right = 0,
                h3("mtcars - a linear models playground"),
                p("Review the data below, if desired add new entries to the dataset by using the panel on the right. If you would like or to download the (augmented) dataset and continue experimenting with it in your local R environment, please use the button at the bottom of the page."),
                p("To view predictor vs mpg plots, please follow the Exploration link above. To build a linear model of fuel efficiency based on the (augmented) dataset below, please use the Data link above. To review diagnostic plots associated with a linear model, please visit the Diagnostics page."),
                dataTableOutput('table')
            ),
            absolutePanel(
                bottom = 20, left = 20,
                draggable = TRUE,
                wellPanel(
                    downloadButton('downloadData', 'Download the dataset')
                )
            ),   
            absolutePanel(
                top = 20, right = 20, width = 300,
                draggable = TRUE,
                wellPanel(
                    h3("Add new model"),
                    p("If you wish to add a new car model to the dataset, please enter the values below. Drag the input panel to see all available input options."),
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
    tabPanel('Exploration', 
             mainPanel(
                 absolutePanel(
                     top = 50, left = 10, right = 0,
                     h2("Exploration plots"),
                     plotOutput("vsAm",width=600,height=600),
                     plotOutput("vsCyl",width=600,height=600),
                     plotOutput("vsDisp",width=600,height=600),
                     plotOutput("vsHp",width=600,height=600),
                     plotOutput("vsDrat",width=600,height=600),
                     plotOutput("vsWt",width=600,height=600),
                     plotOutput("vsQsec",width=600,height=600),
                     plotOutput("vsVs",width=600,height=600),
                     plotOutput("vsGear",width=600,height=600),
                     plotOutput("vsCarb",width=600,height=600)
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
                        h3("Linear model variables"),
                        p("Select variables to use as predictors, with mpg as response."),
                        checkboxGroupInput("modelVariables", label=NULL, selected = "factor(am)",
                            choices = list("Transmission type - am" = "factor(am)", "Number of cylinders - cyl" = "factor(cyl)", "cyl interaction with am" = "factor(cyl)*factor(am)",
                                           "Displacement - disp" = "disp", "disp interaction with am" = "disp*factor(am)",
                                           "Gross horsepower - hp" = "hp", "hp interaction with am" = "hp*factor(am)",
                                           "Rear axle ratio - drat" = "drat", "drat interaction with am" = "drat*factor(am)",
                                           "Weight - wt" = "wt", "wt interaction with am" = "wt*factor(am)",
                                           "1/4 mile time - qsec" = "qsec", "qsec interaction with am" = "qsec*factor(am)",
                                           "Engine shape - vs" = "vs", "vs interaction with am" = "vs*factor(am)",
                                           "Number of forward gears - gear" = "gear", "gear interaction with am" = "gear*factor(am)",
                                           "Number of carburators - carb" = "carb", "carb interaction with am" = "hp*factor(am)"
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
            ),
            absolutePanel(
                top = 20, right = 20, width = 300,
                draggable = TRUE,
                wellPanel(
                    p("To the left you can see the four major diagnostic plots associated with the linear model you built on the Model page based on the dataset presented on Data page."),
                    p("The plots are: residuals versus fitted values, a Q-Q plot of standardized residuals, a scale-location plot (square roots of standardized residuals versus fitted values), and a plot of residuals versus leverage that adds bands corresponding to Cook's distances of 0.5 and 1."),
                    p("These plots are among the many tools that allow one to evaluate how well one's linear model fits the data, may suggest possible further avenues of exploration, and indicate \"interesting\" points. If you would like to know more about linear models, consider attending the Linear Regression class in the Data Science specialization.")
                )
            )
        )
    )
))