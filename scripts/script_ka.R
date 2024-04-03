
library(readr)

ampel <- read_excel("ampel.xlsx") %>%
  rename(date = ...1) %>%
  select(date, ampel) %>%
  drop_na()

write_csv(ampel, file = "../data_ka.csv")


# #VERSION UND ZEITBEREICH MANUELL EINTRAGEN 
# 
# ##########################################################
# version <- "202403"  #hier die aktuelle Version eintragen#
# ##########################################################
# 
# #Zeitachse basierend auf dem Versionsinput erstellen
# endDate = as.Date(paste0(version,"01"), "%Y%m%d")                                         #wandelt Version in Datum um
# 
# startDateString = paste0(as.integer(substr(version, 1, 4)) - 3, substr(version, 5, 6))    #generiert Startdatum aus Enddatum
# startDate = as.Date(paste0(startDateString,"01"), "%Y%m%d")                               #Startdatum als Datumsformat
# 
# datehv <- format(seq(startDate, endDate, "3 months"), "%Y-%m")                            #Datumssequenz ohne die leeren Ticks, die f?r Achse n?tig sind
# 
# zeitbereich = c()                                    
# for(i in 1:(length(datehv)-1)) {              
#   zeitbereich = c(zeitbereich, datehv[i], "", "")       
# }
# zeitbereich = c(zeitbereich, datehv[length(datehv)])
# 
# rm(startDateString)
# rm(endDate)
# rm(datehv)
# rm(startDate)
# 
# ##########################################################
# 
# 
# #SET-UP of WORKSPACE        
# # ueberpruefen ob benoetigte Packages vorhanden sind und wenn nicht, diese installieren
# list.of.packages <- c("RODBC", "openxlsx")                #no need for: "ggplot2", Cairo", "xlsx"
# new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
# if(length(new.packages)) install.packages(new.packages, repos="http://cran.at.r-project.org/")
# rm(new.packages)
# 
# setwd(paste0("\\\\int.wsr.at/Nabu/Themen/Surveys/Konjunkturtest/ktflash/Konjunkturampel",version))            #working directory je nach version
# 
# #Packages laden und Funktionen Sourcen
# lapply(list.of.packages, require, character.only = TRUE)  #l?dt alle Packages
# rm(list.of.packages)                                      #wird jetzt nicht mehr ben?tigt
# 
# source("achsen.R")                                        #holt unsere Funktionen herein
# 
# #READ IN FILES AND DATA
# 
# zsp <- read.xlsx(paste0("Zsp_Indices_",version,"_r.xlsx"), colNames = TRUE)       
# colnames(zsp) <- c("datum", "aktuell", "erwartet", "econclimate")              
# ampel <- read.xlsx("ampel.xlsx", colNames = TRUE)
# 
# #zsp3j=ein datenframe aus zsp der unsere daten fuer die 2 linien fuer die letzten 3 jahre enthaelt, +leichte umformungen
# zsp3j <- zsp[(nrow(zsp)-36):nrow(zsp),c(1,2,3,4)]
# zsp3j$datum<-NULL
# zsp3j$newcol <- c(0:36)
# zsp3j <- zsp3j[,c(4,1,2,3)]