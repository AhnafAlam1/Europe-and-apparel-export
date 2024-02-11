#### Preamble ####
# Purpose: Replicate graphs from Systma (2022) paper
# Author: Ahnaf Alam
# Date: February 11, 2024
# Contact: ahnaf.alam@mail.utoronto.ca
# Pre-requisites: Clean the data and upload it to the inputs/outputs folder

#### Workspace setup ####
library(tidyverse)
library(dplyr)

#### Fetching the data ####
bgd <- read_csv("outputs/data/bgd1.csv")
ldc <- read_csv("outputs/data/ldc22.csv")
m_s <- read_csv("inputs/data/market_share.csv")

#### Replicating Figure 3 ####
m_s |>
  ggplot(mapping = aes(x = Year, y = share, group=type, color = type)) +
  geom_line(size = 2) +
  theme_minimal() +
  labs(x = "Year",
       y = "Percentage of market share (in decimals)") +
  theme(legend.position = "right", 
        axis.text.x = element_text(angle = 45)) +
  scale_color_brewer(palette = "Accent", labels = c("China", "LDCs")) +
  guides(color = guide_legend(title = NULL))

#### Replicating Figure 4 ####
p1 <- bgd |>
  ggplot(aes(x = year, y = frac, group = as.factor(woven), color = as.factor(woven))) +
  geom_line() +
  geom_point() +
  theme_minimal() +
  labs(x = "Year",
       y = "Utilization Rate") + 
  theme(legend.position = "right", 
        axis.text.x = element_text(angle = 45)) +
  scale_color_brewer(palette = "Set1", labels = c("Woven", "Knitted"), breaks = c("1", "0")) +
  guides(color = guide_legend(title = NULL))
print(p1)


#### Replicating Figure 1 ####
ldc|>
  ggplot(mapping = aes(x = year, y = util)) +
  geom_path() +
  theme_classic() +
  labs(x = "Year",
       y = "Utilization Rate")