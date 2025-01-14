# Copyright (C) 2019 by Abhishekh Gupta, Pedro Mendes and The University of Connecticut
# distributed under the Artistic License 2.0

# Mugdha Thakur University of Virginia
# mat3kk@virginia.edu
# April 2021

check.packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, 'Package'])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

packages<-c('shiny','shinyjs', 'remotes', 'reshape2', 'ggplot2', 'shinyTree', 'markdown', 'formattable','XML','DT','knitr','tinytex','wordcloud2','webshot')
check.packages(packages)

if(!('CoRC' %in% installed.packages()[, 'Package'])){
  install_github('jpahle/CoRC')
}


#source("pdf_loc.R")
#i <<- 0
diseaseList = read.csv("diseaselist.csv", stringsAsFactors = F)
choices = setNames(diseaseList$Description,diseaseList$ID)

ui <- fluidPage(
  tags$head(tags$link(rel="shortcut icon", href="dismolib_thumbnail.svg")),
  tags$hr(style="border-width: 2px;border-color: #EB7703;"),
  a(href="https://biocomplexity.virginia.edu/", img(src="inst_bicomplex_4c_c.jpg", width=200)),
  a(href="https://github.com/copasi/shinyCOPASI", img(src="copasi_new.png", width= 170, align= 'right')),
  titlePanel(h1(img(src="dismolib.png", width= 300), align = 'center'), windowTitle = 'dismolib'),
  navbarPage("", id = "navbar",
             tabPanel("Home",
                     # includeMarkdown("home.md")
                     includeMarkdown(knit('home2.rmd', quiet = TRUE))
                     
             ),
             tabPanel("Models",
                      #fluidPage(
                      # img(src="BII_logo.png", height = 100, width = 800),
                      #  titlePanel(title='Disease Modeling Library using ShinyCOPASI', windowTitle = 'Disease Modeling Library using ShinyCOPASI'),
                      #includeMarkdown('title.md'),
                      sidebarLayout(
                        sidebarPanel(
                          useShinyjs(),
                          div(id = "form",style='height: 70px;',
                              selectizeInput('datafile', 'Select a model:',
                              split(choices[diseaseList$ID], diseaseList$Type),
                              
                              selected = "")
                          ),
                          downloadButton("downloadFile", "Download COPASI file"),
                          downloadButton("downloadSBML", "Download SBML file"),
                          
                          #h6('Model files (.cps or SBML) that are less than 30 MB can only be loaded. For larger models, please use stand-alone program of COPASI.'),
                          #h6('If the model has a data file, load it along with your model file using multiple selection.'),
                          tags$hr(),
                          tags$strong(style = 'font-size: 15px;','COPASI:'),
                          shinyTree('taskSelection'),
                          uiOutput("mySliders"),
                          tags$hr(),
                          actionButton("resetAll","Reset all"
                                       ,style="color: #fff; background-color: #CD0000; border-color: #CD0000"
                          ),
                          tags$hr()
                        ),
                        mainPanel(tags$style(type='text/css', '#errorOut {background-color: rgba(255,255,0,0.40); color: red;}'),
                                  verbatimTextOutput('errorOut'),
                                  htmlOutput('modelInfo'),
                                  uiOutput('docModel'),
                                  uiOutput('choose_options',inline = T),
                                  tags$hr(),
                                  uiOutput('choose_columns',inline = T),
                                  uiOutput('show_output',inline = T)
                        )
                      )
                      
                      
             ),
             tabPanel("About",
                      includeMarkdown("about.md")
             ),
             tabPanel("Downloads",
                       includeMarkdown("downloads.md")),
             tabPanel("Documentation",
                  
                      tags$iframe(style="height:600px; width:100%", src = "dismolib.pdf")
             )
                        
             ),
  hr(),
  print(paste0("Cite as: Biocomplexity Institute (University of Virginia), dismolib, http://dismolib.uvadcos.io/, 2021 [Built: BUILD_TIMESTAMP, Accessed: ", format(Sys.Date(), "%m/%d/%Y"), "]"))
)
