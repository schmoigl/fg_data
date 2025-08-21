library(readr)
library(tidyverse)
options(scipen = 9999)

data <- read_csv("scripts/dot_2022_final.csv")

data <- data %>%
  mutate(export_value = export_value / 1000000000) %>%
  group_by(reporter_iso_3) %>%
  mutate(export_value_percent = export_value / sum(export_value)) %>%
  filter(reporter_iso_3 == "AUT") %>%
  arrange(desc(export_value)) %>%
  mutate(rank = row_number())

write.csv(data, "data_AUT.csv", fileEncoding = "UTF-8")

toplist <- t(data$partner_country_ger[1:13])