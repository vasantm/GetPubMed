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
  #if(is.null(input$goButton) || input$goButton == 0){return()}
  observe({
    if(input$goButton == 0){

      output$searchresult <-renderPrint({
HTML(paste('<br/>','<br/>','<br/>', '<center>','<h3>','<span style = "color:grey">',"Use the Search Bar in left sidebar
and click on Get Abstracts  to display results here",'</span>','</h3>','</center>'))
      })
}
  if(input$goButton >0 ){
    Sys.sleep(4)
    #enable the download button
    shinyjs::enable("downloadResults")
  }
  })
  search_string<-eventReactive(input$goButton, {input$query})
  output$searchresult <- renderPrint({
    d.past<-input$dates[1]
    d.current<-input$dates[2]

    search_query <- EUtilsSummary(search_string(), type = "esearch", db = "pubmed",
                         datetype='pdat', mindate = d.past, maxdate = d.current,
                         retmax = 1000)
    records <- EUtilsGet(search_query, type="efetch", db="pubmed")
    #search_topic <-"APOE4 AND (polyunsaturated OR monounsaturated OR saturated)"
    #search_query <-EUtilsSummary(search_topic, retmax=100)
    article_count <-QueryCount(search_query)
    #records <-EUtilsGet(search_query)
    doi <-ELocationID(records)
    pubmed_data <-data.frame('Article' = paste("Article", 1:article_count," of ",
                                               article_count),
                             'Citation' = paste0(MedlineTA(records)," ",
                                                 YearPubmed(records)," ",
                                                 MonthPubmed(records)," ",
                                                 DayPubmed(records),";",
                                                 Volume(records),"(",Issue(records),
                                                 ")",":",MedlinePgn(records),".",
                                                 ifelse(!is.na(doi),doi,""),
                                                 " Language: ",Language(records)
                             ),
                             'PMID' = paste0('Pubmed ID: ',PMID(records)),
                             'Title' = ArticleTitle(records),'Abstract'=AbstractText(records),
                             'LineSep'= rep("_______________________________________________________________________________", article_count),
                             'LineBreak'=rep("\n", article_count))
    pubmed_data$Abstract <- as.character(pubmed_data$Abstract)
    pubmed_data$Abstract<- paste0("ABSTRACT: ","\n",pubmed_data$Abstract)

      line1 <- pubmed_data$Article
      line2 <-pubmed_data$Citation
      line3 <- pubmed_data$PMID
      line4 <-pubmed_data$Title
      line5 <-pubmed_data$Abstract
      line6 <-'<hr>'
      HTML(paste(line1,line2,line3,line4,line5,line6, sep='<br/>'))
})
  output$downloadResults <-downloadHandler(
    filename = function() {
      paste("Results-",input$query,".txt", sep = "")
    },
    content = function(file) {
      write.table(pubmed_data, file ,sep="\n", col.names=F,
                  row.names = F, quote = F)
    }

  )
 shinyjs::disable("downloadResults")
  })
