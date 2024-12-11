library(wifo.base)
library(wifo.data)
library(tidyverse)

wds_series = c(
  "gen_t00clim_s", 
  "gen_t10clim_s", 
  "gen_t20clim_s", 
  "gen_t40clim_s", 
  "gen_t30clim_s"
  # "gen_t32clim_s"
  )

wds_names <- c(
  "Gesamtwirtschaft", 
  "Sachgütererzeugung", #  (produzierende Industrie und Gewerbe)
  "Bau",
  "Einzelhandel",
  "Dienstleistungen"
  # "Beherbergung und Gastronomie"
)

wds_names_en <- c(
  "Overall economy",
  "Manufacturing", # (manufacturing industry and commerce)
  "Construction",
  "Retail",
  "Services"
  # "Accommodation and food services"
)

data <- NULL

for (i in 1:length(wds_series)) {
  temp <- wdGetWdsData(wds_series[i], db = "wds")
  temp$indicator <- wds_names[i]
  temp$indicator_en <- wds_names_en[i]
  names(temp) <- c("month", "value", "indicator", "indicator_en")
  data <- rbind(data, temp)
}

write_csv(data, "K:/Github/fg_data/data_kt.csv")
