library(shiny)
library(ggplot2)

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
        
        output$vsCyl <- renderPlot({qplot(wt, mpg, data=mtcars.local, xlab="Number of cylinders", ylab="Fuel efficiency (mpg)") + geom_smooth(method='lm')})
        output$vsDisp <- renderPlot({qplot(disp, mpg, data=mtcars.local, xlab="Displacement (cu. in.)", ylab="Fuel efficiency (mpg)") + geom_smooth(method='lm')})
        output$vsHp <- renderPlot({qplot(hp, mpg, data=mtcars.local, xlab="Gross horsepower", ylab="Fuel efficiency (mpg)") + geom_smooth(method='lm')})
        output$vsDrat <- renderPlot({qplot(drat, mpg, data=mtcars.local, xlab="Rear axle ratio", ylab="Fuel efficiency (mpg)") + geom_smooth(method='lm')})
        output$vsWt <- renderPlot({qplot(wt, mpg, data=mtcars.local, xlab="Weight (lb/1000)", ylab="Fuel efficiency (mpg)") + geom_smooth(method='lm')})
        output$vsQsec <- renderPlot({qplot(qsec, mpg, data=mtcars.local, xlab="1/4 mile time (sec)", ylab="Fuel efficiency (mpg)") + geom_smooth(method='lm')})
        output$vsVs <- renderPlot({qplot(ifelse(vs==0,"V-type","Straight"), mpg, data=mtcars.local, xlab="Engine shape", ylab="Fuel efficiency (mpg)")})
        output$vsAm <- renderPlot({qplot(ifelse(vs==0,"Automatic","Manual"), mpg, data=mtcars.local, xlab="Transmission type", ylab="Fuel efficiency (mpg)")})
        output$vsGear <- renderPlot({qplot(gear, mpg, data=mtcars.local, xlab="Number of forward gears", ylab="Fuel efficiency (mpg)") + geom_smooth(method='lm')})
        output$vsCarb <- renderPlot({qplot(carb, mpg, data=mtcars.local, xlab="Number of carburators", ylab="Fuel efficiency (mpg)") + geom_smooth(method='lm')})
        
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
                
                output$vsCyl <- renderPlot({qplot(wt, mpg, data=mtcars.local, xlab="Number of cylinders", ylab="Fuel efficiency (mpg)") + geom_smooth(method='lm')})
                output$vsDisp <- renderPlot({qplot(disp, mpg, data=mtcars.local, xlab="Displacement (cu. in.)", ylab="Fuel efficiency (mpg)") + geom_smooth(method='lm')})
                output$vsHp <- renderPlot({qplot(hp, mpg, data=mtcars.local, xlab="Gross horsepower", ylab="Fuel efficiency (mpg)") + geom_smooth(method='lm')})
                output$vsDrat <- renderPlot({qplot(drat, mpg, data=mtcars.local, xlab="Rear axle ratio", ylab="Fuel efficiency (mpg)") + geom_smooth(method='lm')})
                output$vsWt <- renderPlot({qplot(wt, mpg, data=mtcars.local, xlab="Weight (lb/1000)", ylab="Fuel efficiency (mpg)") + geom_smooth(method='lm')})
                output$vsQsec <- renderPlot({qplot(qsec, mpg, data=mtcars.local, xlab="1/4 mile time (sec)", ylab="Fuel efficiency (mpg)") + geom_smooth(method='lm')})
                output$vsVs <- renderPlot({qplot(ifelse(vs==0,"V-type","Straight"), mpg, data=mtcars.local, xlab="Engine shape", ylab="Fuel efficiency (mpg)")})
                output$vsAm <- renderPlot({qplot(ifelse(vs==0,"Automatic","Manual"), mpg, data=mtcars.local, xlab="Transmission type", ylab="Fuel efficiency (mpg)")})
                output$vsGear <- renderPlot({qplot(gear, mpg, data=mtcars.local, xlab="Number of forward gears", ylab="Fuel efficiency (mpg)") + geom_smooth(method='lm')})
                output$vsCarb <- renderPlot({qplot(carb, mpg, data=mtcars.local, xlab="Number of carburators", ylab="Fuel efficiency (mpg)") + geom_smooth(method='lm')})
                
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
                model.formula <- paste0("mpg ~ ",paste(input$modelVariables,collapse=" + "))
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