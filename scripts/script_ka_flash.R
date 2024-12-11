
library(readr)
library(tidyverse)
library(readxl)
library(openxlsx)

options(scipen = 9999)

version <- format(Sys.time(), "%Y%m")

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

write_csv(zsp, file = "K:/Github/fg_data/data_ka_flash.csv")
