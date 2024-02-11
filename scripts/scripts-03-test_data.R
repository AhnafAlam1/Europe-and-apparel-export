#### Preamble ####
# Purpose: Tests on cleaned market share data set, ldc, and UN comtrade data set
# Author: Ahnaf Alam
# Date: February 10, 2024
# Contact: ahnaf.alam@mail.utoronto.ca
# Pre-requisites: Clean the data and upload it to the `outputs/data` folder


#### Workspace setup ####
library(tidyverse)
library(dtplyr)

#### Downloading the data ####

comtrade <- read_csv("outputs/data/comtrade.csv")
utl <- read_csv("outputs/data/ldc22.csv")
mkt <- read_csv("inputs/data/market_share.csv")



#### Test data ####

#1 Checking to see if there are any missing values in the `mkt` data set
is.na(mkt$share) & is.na(mkt$export) & is.na(mkt$Year) &
  is.na(mkt$type)

#2 Checking to see if utilization rate is between 0 and 1.
utl$util >= 0 & utl$util <= 1

#3 Chekcing to see if there products on only two type of HS codes
comtrade$ProductCode |>
  unique() == c(61, 62)

#4 Checking to see if all the years (2002-2018) is in the data set
utl$year |>
  unique() == c(2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011,
               2012, 2013, 2014, 2015, 2016, 2017, 2018)

#5 Checking to see if each year is there in the data set at least twice
table(comtrade$Year) >= 2


