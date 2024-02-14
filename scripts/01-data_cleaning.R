#### Preamble ####
# Purpose: Cleans the raw "Eurostat.csv" and "market_share.csv" data
# Author: Ahnaf Alam
# Date: 01 February, 2024
# Contact: ahnaf.alam@mail.utoronto.ca
# Pre-requisites: download the data and save it


#### Workspace setup ####



library(tidyverse)
library(dplyr)
library(ggplot2)


#### Cleaning data ####

#### Figure 1 ####

Euro <- read_csv("inputs/data/euro_data.csv")

#Note: The cleaning procedure is based on the original code provided by Systma (2022) and code is derived using help
# from LLM model (ChatGPT). The full conversation can be found under `llm_usage` in the Github repository.

################################# Labeling #################################################
eu_clean <- Euro |>
  select(-1)
label(eu_clean$DECLARANT_LAB)<-"Importer"
label(eu_clean$PARTNER_LAB)<-"Exporter"
label(eu_clean$PRODUCT)<-"Product HS Code"
label(eu_clean$PRODUCT_LAB)<-"Product description"
label(eu_clean$STAT_REGIME_LAB)<-"Processing type"
label(eu_clean$ELIGIBILITY_LAB)<-"Preference eligibility"
label(eu_clean$IMPORT_REGIME_LAB)<-"Preferences product was imported under"
label(eu_clean$year)<-"Year of transaction"
label(eu_clean$value)<-"Value of transaction"

################################# Modifying columns #################################################
eu_clean <- eu_clean |>
  filter(DECLARANT_LAB != "EU total" &
           DECLARANT_LAB != "EU MEMBER STATES- EVOLUTIVE (EU15 UNTIL 30/04/2004, EU25 UNTIL 31/12/2006, EU27 UNTIL 30/06/2013, EU 28 SINCE 01/07/2013)")

eu_clean$value <- eu_clean$value/1

eu_clean$group_id <- eu_clean |>
  group_indices(PARTNER_LAB, PRODUCT, DECLARANT_LAB,year)
eu_clean$exp_year <- eu_clean |>
  group_indices(PARTNER_LAB, year)

gsp_only <- eu_clean |>
  filter(IMPORT_REGIME_LAB %in% c("GSP ZERO", "GSP NON ZERO")) |>
  mutate(gsp_value = value)

total <- eu_clean |>
  group_by(group_id, PARTNER_LAB, PRODUCT, year, DECLARANT_LAB) |>
  summarise(value = sum(value))

total_gsp <- gsp_only |>
  group_by(group_id) |>
  summarise(gsp_value = sum(gsp_value))

################################# Merging and missing values #################################################

util <- merge(total, total_gsp, by = "group_id", all = FALSE, all.x = TRUE) |>
  mutate(gsp_value = ifelse(is.na(gsp_value), 0, gsp_value),
         frac = gsp_value / value) |>
  filter(value != 0)

util$post <- ifelse(util$year >= 2011, 1, 0)
util$woven <- ifelse(util$PRODUCT >= 620000, 1, 0)
util$woven[is.na(util$woven)] <- 0

################################# Final Data #################################################

ldc22 <- util |>
  group_by(year) |>
  summarise(util = mean(frac), var = sd(frac))

################################# Incorporating utility data with Bangladesh, Nepal and Cambodia #################################################

bgd1 <- util |>
  filter(PARTNER_LAB == "BANGLADESH") |>
  group_by(year, woven) |>
  summarise(gsp_value = sum(gsp_value), value = sum(value)) |>
  mutate(frac = gsp_value / value)

cmbd1 <- util |>
  filter(PARTNER_LAB == "CAMBODIA (ex KAMPUCHEA)") |>
  group_by(year, woven) |>
  summarise(gsp_value = sum(gsp_value), value = sum(value)) |>
  mutate(frac = gsp_value / value)

nep1 <- util |>
  filter(PARTNER_LAB == "NEPAL") |>
  group_by(year, woven) |>
  summarise(gsp_value = sum(gsp_value), value = sum(value)) |>
  mutate(frac = gsp_value / value)

########################################################### Cleaning comtrade.csv data set #####################################

comtrade <- read_csv("inputs/data/comtrade.csv")



comtrade <- comtrade |>
  rename(trade_in_1000USD = `TradeValue in 1000 USD`) |>
  select(
    ProductCode,
    Year,
    trade_in_1000USD
  )

#### saving the data ####

write_csv(eu_clean, "outputs/data/eu_clean.csv")
write_csv(ldc22, "outputs/data/ldc22.csv")
write_csv(bgd1, "outputs/data/bgd1.csv")
write_csv(cmbd1, "outputs/data/cmbd1.csv")
write_csv(nep1, "outputs/data/nep1.csv")
write_csv(comtrade, "outputs/data/comtrade.csv")










