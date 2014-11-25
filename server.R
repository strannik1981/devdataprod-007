library(shiny)

shinyServer(
    function(input, output) 
    {
        mtcars.local <- mtcars
        mtcars.local <- cbind(model=rownames(mtcars.local), mtcars.local)
        mtcars.local$model <- as.character(mtcars.local$model)
        output$downloadData <- downloadHandler(
            filename = 'mtcars.csv',
            content = function(file) {
                write.csv(mtcars.local[,-1], file)
            }
        )
        
        output$table <- renderDataTable({
            if (input$goButton == 0)
            {
                return(mtcars.local)
            }
            
            isolate({
                mtcars.local <<- rbind(mtcars.local, 
                    c(model=input$model, mpg=input$mpg,
                        cyl=input$cyl, disp=input$disp,
                        hp=input$hp, drat=input$drat,
                        wt=input$wt, qsec=input$qsec,
                        vs=input$vs, am=input$am,
                        gear=input$gear, carb=input$carb))
                row.names(mtcars.local)[dim(mtcars.local)[1]] <<- input$model
                mtcars.local
            })
        }, options = list(searching = FALSE))
        
        mtcars.model <- lm("mpg ~ factor(am)", data=mtcars.local)
        output$residualsVsFitted <- renderPlot({plot(mtcars.model,which = 1:1)},width=800,height=800)
        output$normalQQ <- renderPlot({plot(mtcars.model,which = 2:2)},width=800,height=800)
        output$scaleLocation <- renderPlot({plot(mtcars.model,which = 3:3)},width=800,height=800)
        output$residualsVsLeverage <- renderPlot({plot(mtcars.model,which = 5:5)},width=800,height=800)
        
        output$model.summary <- renderPrint({
            if (input$buildButton == 0)
            {
                return(summary(mtcars.model))
            }
            
            isolate({
                model.formula <- paste0("mpg ~ ",paste(c(input$modelVariables,"factor(am)"),collapse=" + "))
                cat(model.formula)
                mtcars.model <- lm(model.formula, data=mtcars.local)
                output$residualsVsFitted <- renderPlot({plot(mtcars.model,which = 1:1)},width=800,height=800)
                output$normalQQ <- renderPlot({plot(mtcars.model,which = 2:2)},width=800,height=800)
                output$scaleLocation <- renderPlot({plot(mtcars.model,which = 3:3)},width=800,height=800)
                output$residualsVsLeverage <- renderPlot({plot(mtcars.model,which = 5:5)},width=800,height=800)
                summary(mtcars.model)
            })
        })
    }
)