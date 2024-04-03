
library(tidyverse)
library(openxlsx)
library(countrycode)

time <- Sys.Date()
time <- format(time, "%y%m")

#Download Dataset - automatic
temp <- tempfile()

time <- as.numeric(time) - 1

download.file(
  paste0(
    "https://ec.europa.eu/economy_finance/",
    "db_indicators/surveys/documents/series/nace2_ecfin_",
    time,
    "/main_indicators_sa_nace2.zip"
    ), 
  temp
  )

bcsData <- read.xlsx(
  unzip(temp, "main_indicators_nace2.xlsx"), 
  colNames = TRUE, 
  sheet = "MONTHLY", 
  detectDates = F
  )

unlink(temp)
rm(temp)

bcsData <- bcsData %>% 
  mutate_all(as.numeric) %>%
  rename(date = X1) %>% 
  mutate(date = format(convertToDate(date))) %>%
  pivot_longer(
    cols = 2:ncol(bcsData), 
    names_to = "key", 
    values_to = "value"
    ) %>%
  separate(
    key, 
    into = c("country", "series"), 
    "\\."
    ) %>%
  drop_na() %>%
  filter(
    series %in% c(
      # "INDU", 
      # "CONS", 
      # "BUIL", 
      # "RETA", 
      # "SERV", 
      "ESI",
      "EEI"
      )
    ) %>%
  mutate(
    iso3 = countrycode(country, origin = "eurostat", destination = "iso3c"),
    country_de = countrycode(country, origin = "eurostat", destination = "country.name.de"),
    country_en = countrycode(country, origin = "eurostat", destination = "country.name")
    ) %>%
  select(-country)
  
write.table(
  bcsData, 
  file = paste0("../data_esi.csv"), 
  append = FALSE, 
  na = "", 
  quote = FALSE, 
  sep = ",", 
  dec = ".", 
  row.names = FALSE, 
  col.names = TRUE
  )


