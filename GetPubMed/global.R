#util functions

#calculate start date 30 years before today's date
#to populate as default start date
GetPastDate <-function(years=30){
  d <-as.POSIXlt(Sys.time())
  d$year <-d$year - years
  format(as.Date(d),"%Y/%m/%d")
}

MungeData <-function(results){

   if(class(results) == "Medline"){
     doi <-ELocationID(results)
     article_count <-length(doi)
     pubmed_data <-data.frame('Article' = paste("Article", 1:article_count," of ",
                                                article_count),
                              'Title' = ArticleTitle(results),
                              'Abstract'=AbstractText(results),
                              'Citation' = paste0(MedlineTA(results)," ",
                                                  YearPubmed(results)," ",
                                                  MonthPubmed(results)," ",
                                                  DayPubmed(results),";",
                                                  Volume(results),"(",Issue(results),
                                                  ")",":",MedlinePgn(results),".",
                                                  ifelse(!is.na(doi),doi,""),
                                                  " Language: ",Language(results)
                              ),
                              'PMID' = paste0('Pubmed ID: ',PMID(results)),
                              'LineSep'= rep("_______________________________________________________________________________", article_count),
                              'LineBreak'=rep("\n", article_count))
     pubmed_data$Abstract <- as.character(pubmed_data$Abstract)
     pubmed_data$Abstract<- paste0("ABSTRACT: ","\n",pubmed_data$Abstract)
     return(pubmed_data)
   }
  if(is.character(results)){
    return(results)
  }
}
