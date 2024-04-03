library(readr)
library(tidyverse)
data <- read_csv("C:/Users/schmo/Downloads/dot_2022_final@1.csv")

options(scipen=9999)

data <- data %>% 
  mutate(export_value = export_value / 1000000000) %>%
  group_by(reporter_iso_3) %>%
  mutate(export_value_percent = export_value / sum(export_value)) %>%
  filter(reporter_iso_3 == "AUT") %>%
  arrange(desc(export_value)) %>%
  mutate(rank = row_number())

write.csv(data, "data.csv", fileEncoding = "UTF-8")

toplist <- t(data$partner_country_ger[1:13])

c("Deutschland", "Italien", "Vereinigte Staaten von Amerika", "Schweiz", "Frankreich", "Ungarn", "Polen", "Slowakei", "Tschechien", "China")

getwd()