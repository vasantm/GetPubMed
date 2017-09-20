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
#source("global.R")
shinyUI(fluidPage(theme=shinytheme("united"),
                  tags$head(
                    tags$style(HTML("
      .shiny-output-error-myvalidation {
              color: grey;
              font-size: x-large;
              left: 0;
              line-height: 200px;
              margin-top: 200px;
              position: absolute;
              text-align: center;
              top: 50%;
              width: 100%;
      }
    "))
                  ),
                  useShinyjs(),
                  headerPanel("PubMed Search"),
                  sidebarLayout(
                    sidebarPanel(
                      helpText("Type a word below and search PubMed to find documents that contain that word in the text. You can even type multiple words. You can search authors, topics, any acronym, etc."),
                      textInput("query", label = h2("Keyword(s)"),
                                value = "",placeholder = "Type search term here"),
                      helpText("Please specify the start and end dates of your search,
                               using the format YYYY-MM-DD."),
                      dateRangeInput("dates", label = h2("Date Range:"),
                                     start = GetPastDate(years = 30),
                                     end = format(Sys.Date(),"%Y/%m/%d"),
                                     format = "yyyy/mm/dd", width = '300px'),
                      #textInput("date1", label = h3("From"),value="1990/01/01"),
                      #textInput("date2", label = h3("To"),  value = format(Sys.time(),"%Y/%m/%d")),
                helpText("Past date is set to 30 years before & To Date
                         is auto populated with today's date"),
                sliderInput("req_count",
                             label = h2("Number of Abstracts to get:"),
                           min = 200, max = 1000, value =200, step = 50,
                           width = '300px'),
                helpText("Choose number of Abstracts to retrieve,
                         Note: higher number takes longer"),

                      actionButton("goButton","Get Abstracts"),
                      helpText("Now click Get Abstracts to get the results."),
                      downloadButton('downloadResults','Download as Text File'),
helpText("Download button is only active after results are returned from PubMed")),
#actionButton("reset","Clear"),
#helpText("Hit Clear to clear current search")),

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
