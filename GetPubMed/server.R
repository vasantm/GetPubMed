#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyjs)

library(RISmed)


shinyServer(function(input, output) {

  observeEvent(input$query, {
    shinyjs::disable("downloadResults")
  })

  records <-eventReactive(input$goButton, {
    validate(
      need(input$query != "",
           "Can't search without a search term! Please enter Search Term to display results here"),
      errorClass = "myvalidation")

    search_string <-input$query
    dates <-input$dates
    d.past<-format(dates[1],"%Y/%m/%d")
    d.current<-format(dates[2],"%Y/%m/%d")
    req_count <-input$req_count

    search_query <- EUtilsSummary(search_string,type = "esearch", db = "pubmed",
                                  datetype='pdat', mindate = d.past,
                                  maxdate = d.current,
                                  retmax = req_count)
    if(QueryCount(search_query)>0){
    EUtilsGet(search_query, type="efetch", db="pubmed")
    } else {
      return("No records Found, Please try another search term")
    }
  })
  output$searchresult <- renderPrint({
    if(input$goButton ==0){

      return(HTML(paste('<br/>','<br/>','<br/>', '<center>','<h3>','<span style = "color:grey">',"Please enter Search Term to display results here",'</span>','</h3>','</center>')))


    }
    #input$goButton
    #isolate({
    pubmed_results <- MungeData(records())
#print(pubmed_data)
    if(is.data.frame(pubmed_results)){
      line1 <- pubmed_results$Article
      line2 <-pubmed_results$Title
      line3 <-pubmed_results$Abstract
      line4 <-pubmed_results$Citation
      line5 <- pubmed_results$PMID
      line6 <-'<hr>'
print(HTML(paste(line1,line2,line3,line4,line5,line6, sep='<br/>')))
 shinyjs::enable("downloadResults")
}
    if(is.character(pubmed_results)){
      HTML(paste('<br/>','<br/>','<br/>', '<center>','<h3>','<span style = "color:grey">',"No Records found! Please Use Another Search Term to display results here",'</span>','</h3>','</center>'))
    }
    #})
  })

  output$downloadResults <-downloadHandler(


    filename = function() {
      paste("Results-",input$query,".txt", sep = "")
    },
    content = function(file) {
      write.table(MungeData(records()), file ,sep="\n", col.names=F,
                  row.names = F, quote = F)
    }

  )
shinyjs::disable("downloadResults")
  })
