
library(readr)
library(tidyverse)
library(readxl)
library(openxlsx)

options(scipen = 9999)

version <- "202404"
"//int.wsr.at/Nabu/Themen/Surveys/Konjunkturtest/ktflash/Flash202403/ampel.xlsx"

ampel <- read_excel(paste0(
  "//int.wsr.at/Nabu/Themen/Surveys/Konjunkturtest/ktflash/Flash",
  version,
  "/ampel.xlsx"
  )) %>%
  rename(date = ...1) %>%
  select(date, ampel) %>%
  drop_na()

zsp <- read_excel(paste0(
  "//int.wsr.at/Nabu/Themen/Surveys/Konjunkturtest/ktflash/Flash",
  version,
  "/Zsp_Indices_", 
  version,
  "_r.xlsx"
  )) %>%
  rename(
    date = ...1,
    aktuell = ECON_CONTEMPORARY_INDEX,
    erwartet = ECON_EXPECTATIONS_INDEX,
    econclimate = ECON_CLIMATE
  ) %>%
  left_join(ampel) %>%
  drop_na()

write_csv(zsp, file = "data_ka.csv")


# # ??
# #zsp3j=ein datenframe aus zsp der unsere daten fuer die 2 linien fuer die letzten 3 jahre enthaelt, +leichte umformungen
# zsp3j <- zsp[(nrow(zsp)-36):nrow(zsp),c(1,2,3,4)]
# zsp3j$newcol <- c(0:36)
# zsp3j <- zsp3j[,c(4,1,2,3)]
# 
# for (i in 0:35) {
#   zsp_value <- ampel$ampel [nrow(ampel)-37+i+2]
#   
#   if(zsp_value > 0.67) color <- "#00FF00" 
#   if(zsp_value <= 0.67 & zsp_value > 0.65) color <-  "#E3FF00"
#   if(zsp_value <= 0.65 & zsp_value > 0.33) color <-  "#FFFF00"
#   if(zsp_value <= 0.33 & zsp_value > 0.32) color <-  "#FFDB00"
#   if(zsp_value <= 0.32) color <- "#FF0000"
#   
#   rect(i, MinYScale_klima-3, (i+1), MinYScale_klima-1, border = "black" ,col=color, lwd=0.5)
# }

