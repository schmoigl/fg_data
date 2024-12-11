
rm(list = ls())
library(wifo.base)
loadPackages(c('data.table', 'readr','microbenchmark', 'haven', 'RODBC', 'lubridate', 'tidyverse'))

source(file = 'scripts/functions_create_csv.R', encoding = 'UTF8')

create_fb3()

daten_fb3 <- read_delim(
  "daten_fb3.csv", 
  delim = ";", 
  escape_double = FALSE, 
  trim_ws = TRUE
  )

daten_fb3 <- daten_fb3 |>
  mutate(Jahr = substr(SeriesDate, 1, 4)) |>
  select(-SeriesDate) |>
  relocate(Jahr) |>
  gather(key = "Variable", value = "Wert", 2:7) |>
  filter(Variable != "omeeu") |> # or keep?
  mutate(Variable = fct_recode(
    Variable, 
    "Bruttoinlandsausgaben für F&E in % des BIP" = "brausgfe",
    "AT Marktanteil am Export in die Welt in %" = "omw",
    "AT Marktanteil am Export der Welt in die EU28 in %" = "omeu",
    "Ausgaben des Unternehmenssektors für F&E in % des BIP" = "ausgfe",
    "Produktion je Beschäftigtem/Beschäftigter (rechte Achse)" = "prodbesch"
  )) |>
  mutate(Variable_en = fct_recode(
    Variable, 
    "Gross domestic expenditure for R&D in % of GDP" = "Bruttoinlandsausgaben für F&E in % des BIP",
    "Austria's market share of exports to the world in %" = "AT Marktanteil am Export in die Welt in %",
    "Austria's market share to the EU-28 in %" = "AT Marktanteil am Export der Welt in die EU28 in %",
    "Expenditures in the business sector on R&D in % of GDP" = "Ausgaben des Unternehmenssektors für F&E in % des BIP",
    "Production per person employed (right axis)" = "Produktion je Beschäftigtem/Beschäftigter (rechte Achse)"
  ))
  
write_csv(daten_fb3, file = "K:/Github/fg_data/data_fg3.csv")
file.remove("daten_fb3.csv")