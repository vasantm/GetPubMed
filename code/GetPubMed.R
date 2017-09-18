library(RISmed)
search_topic <-"APOE4 AND (polyunsaturated OR monounsaturated OR saturated)"
search_topic<-"kristal"
search_query <-EUtilsSummary(search_topic, retmax=1000)
article_count <-QueryCount(search_query)
records <-EUtilsGet(search_query)
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
write.table(pubmed_data, file="apoe4_forBSK.txt",sep="\n", col.names=F,
            row.names = F, quote = F)


