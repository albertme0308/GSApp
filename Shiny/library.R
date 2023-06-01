
# Verificar si los paquetes están instalados y si no, instalarlos
packages <- c("shiny",
              "shinydashboard",
              "ggplot2",
              "ggridges",
              "ggridges",
              "openxlsx",
              "rmarkdown",
              "clusterProfiler",
              "enrichplot",
              "ReactomePA",
              "DOSE",
              "pathview",
              "SPIA",
              "org.Hs.eg.db",
              "org.Mm.eg.db",
              "org.Rn.eg.db"
              )

# Verificar si los paquetes están instalados y si no, instalarlos
for (package in packages) {
  if (!require(package, character.only = TRUE)) {
    if(package %in% c("clusterProfiler","enrichplot","ReactomePA","DOSE","pathview","SPIA","org.Hs.eg.db","org.Mm.eg.db","org.Rn.eg.db")){
      if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
      BiocManager::install(package)
    }else{
      install.packages(package)
    }
  }
}

# Cargar las librerías necesarias
library(shinydashboard)
library(shiny)
library(ggplot2)
library(ggridges)
library(ggupset)
library(openxlsx)
library(rmarkdown)
library(clusterProfiler)
library(enrichplot)
library(ReactomePA)
library(DOSE)
library(pathview)
library(SPIA)
library(org.Hs.eg.db)
library(org.Mm.eg.db)
library(org.Rn.eg.db)
