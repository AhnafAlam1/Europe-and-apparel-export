#### Preamble ####
# Purpose: Downloads and saves the data from "Eurostat.csv" and "market_share.csv"
# Author: Ahnaf Alam
# Date: 31 January, 2022
# Contact: ahnaf.alam@mail.utoronto.ca
# Pre-requisites: Read the original paper as this is a replication


#### Workspace setup ####
library(tidyverse)
library(janitor)
library(knitr)


#### Download data ####

### Downloading market share dataset ####
f <- file.choose()
market_share <- read_csv(f)

#### Downloading Eurostat dataset ####

k <- file.choose()
euro_data <- read_csv(k)

#Note: The code for downloading the data was derived with the help of LLM. The complete LLM conversation can be found under "llm_usage" 
## folder on Github. 

#### Save data ####

write_csv(
  x = market_share,
  file = "inputs/data/market_share.csv"
)

write_csv(
  x = euro_data,
  file = "inputs/data/euro_data.csv"
)
