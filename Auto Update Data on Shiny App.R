
library(shiny)
library(shinyalert)


ui <- fluidPage(
  
  column(
    width = 6,
    align ='left',
    "OPTION 1",
    tableOutput(outputId = 'mdatatable1'),
    "OPTION 2",
    tableOutput(outputId = 'mdatatable2')
  )
)

server <- function(input, output, session) {
  
 myfile <-  'C:/Users/pc/Documents/ArrestsNew.csv'
 

 # OPTION 1
  # Ref: https://shiny.rstudio.com/reference/shiny/latest/reactivePoll.html
  data <- reactivePoll(1000, session,
                       # This function returns the time that myfile was last modified
                       checkFunc = function() {
                         if (file.exists(myfile))
                           file.info(myfile)$mtime[1]
                         else
                           shinyalert(title = "file",text = "There is no such file")
                       },
                       # This function returns the content of myfile
                       valueFunc = function() {
                         read.csv(myfile)
                       }
  )


  output$mdatatable1 <- renderTable({
    data()
  })

  
  # OPTION 2
  # Ref: https://shiny.rstudio.com/reference/shiny/latest/reactiveFileReader.html
  fileData <- reactiveFileReader(1000, NULL, myfile, read.csv)

  output$mdatatable2 <- renderTable({
    fileData()
  })

  
}

shinyApp(ui, server)

