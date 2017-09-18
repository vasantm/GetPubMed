#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(shinyjs)
library(shinycssloaders)
shinyUI(fluidPage(theme=shinytheme("united"),
                  useShinyjs(),
                  headerPanel("PubMed Search"),
                  sidebarLayout(
                    sidebarPanel(
                      helpText("Type a word below and search PubMed to find documents that contain that word in the text. You can even type multiple words. You can search authors, topics, any acronym, etc."),
                      textInput("query", label = h3("Keyword(s)"),
                                value = "APOE4 AND (polyunsaturated OR monounsaturated OR saturated)"),
                      helpText("You can specify the start and end dates of your search,
                               use the format YYYY/MM/DD."),
                      textInput("date1", label = h3("From"),value="1990/01/01"),
                      textInput("date2", label = h3("To"),  value = format(Sys.time(),"%Y/%m/%d")),
                      helpText("To Date is auto populated with today's date"),
                      actionButton("goButton","Get Abstracts"),
                      helpText("Now click Get Abstracts to get the results."),
                      downloadButton('downloadResults','Download as Text File'),
helpText("Download button is only active after results are returned from PubMed")),

                    mainPanel(
                      tabsetPanel(
                        tabPanel("Search Results",
                                 withSpinner(htmlOutput("searchresult"),
                                 type = 8))
                      )
                    )
                  )
)

)
