#### Preamble ####
# Purpose: Simulate the market share and UN comtrade data sets
# Author: Ahnaf Alam
# Date: February 10, 2024
# Contact: ahnaf.alam@mail.utoronto.ca
# Pre-requisites: None

#### Workspace setup ####
library(tidyverse)
library(dplyr)
library(janitor)

#### Simulate the data ####

#### Simulating UN contrade data set #####

set.seed(100)

Year <- c(2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013,
         2014, 2015, 2016, 2017, 2018)
HS <- c(61, 62)

simulate_un <- 
  tibble(
    Year = Year,
    HS_code = sample(HS, 18, replace = TRUE),
    value_USD = sample(100000:500000, 18, replace = TRUE)
  )

simulate_un

#### Simulating market share data set #####

set.seed(101)

country <- c("China", "LDCs")

simulate_ms <-
  tibble(
    Year = Year,
    Export = sample(300000:1500000, 18, replace = TRUE),
    Total = sample(1600000: 3000000, 18, replace = TRUE),
    Share = (Export/Total),
    Entity = sample(country, 18, replace = TRUE)
  )

simulate_ms

#### Running tests on simulated data #####

#1. Checking to see if China and LDCs are the only unique characters in the tibble
simulate_ms$Entity |>
  unique() == c("China", "LDCs")

#2. Checking to see if the share column is restricted between 0 and 1.
simulate_ms$Share >= 0 & simulate_ms$Share <= 1

#3. Checking to see if valuation in USD is atleast $100,000
simulate_un$value_USD >= 100000

#4. Checking to see if there are only 2 HS codes, 61 and 62
simulate_un$HS_code == 61 | simulate_un$HS_code == 62

#5 Checking to see if exports are valued between $300,0000 and $1,500,000
simulate_ms$Export >= 300000 & simulate_ms$Export <= 1500000

  
  



