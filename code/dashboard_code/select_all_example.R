#rm(list = ls())
library(shiny)
campaigns_list <- letters[1:10]

ui =fluidPage(
  checkboxGroupInput("campaigns","",campaigns_list),
  actionLink("selectall","Select All") 
)
server = function(input, output, session) {
  
  observe({
    if(input$selectall == 0) return(NULL) 
    else if (input$selectall%%2 == 0)
    {
      updateCheckboxGroupInput(session,"campaigns","",choices=campaigns_list)
    }
    else
    {
      updateCheckboxGroupInput(session,"campaigns","",choices=campaigns_list,selected=campaigns_list)
    }
  })
}
runApp(list(ui = ui, server = server))
