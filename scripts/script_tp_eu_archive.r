library(readr)
library(tidyverse)
data <- read_csv("dot_2022_final.csv")

options(scipen=9999)

data_AUT <- data %>% 
  mutate(export_value = export_value / 1000000) %>%
  group_by(reporter_iso_3) %>%
  mutate(export_value_percent = export_value / sum(export_value)) %>%
  filter(reporter_iso_3 == "AUT") %>%
  arrange(desc(export_value)) %>%
  filter(export_value_percent > 0.005)

write.csv(data_AUT, "data_AUT.csv", fileEncoding = "UTF-8")

toplist <- t(data_AUT$partner_country_ger[1:10])


options(scipen=9999)

data <- data %>% 
  mutate(export_value = export_value / 1000000) %>%
  group_by(reporter_iso_3) %>%
  mutate(export_value_percent = export_value / sum(export_value)) %>%
  arrange(desc(export_value)) %>%
  filter(export_value_percent > 0.005)

write.csv(data, "data_full.csv", fileEncoding = "UTF-8")