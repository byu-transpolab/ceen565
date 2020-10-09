library(mlogit)
library(tidyverse)
library(modelsummary)

# data file : https://byu.box.com/shared/static/ftzy74uaug0voet2wvwhgicxamhgcvp7.rds"
worktrips <- read_rds("data/worktrips_dfidx.rds")


# estimate a model only with total travel time
mnl1 <- mlogit(CHOSEN ~ TVTT, data = worktrips)

# what is the frequency table in this dataset?
mnl1$freq

# calculate null and market shares log likelihoods
ll0 <- sum(mnl1$freq * log(1/6))
llC <- sum(mnl1$freq * log(mnl1$freq / sum(mnl1$freq)))

# get estimated model log likelihood and calculate rho squared stats
llB <- logLik(mnl1)
rho20 <- 1 - llB / ll0
rho2C <- 1 - llB / llC

# estimate model with total travel time and workplace employment density
mnl2 <- mlogit(CHOSEN ~ TVTT | WKEMPDEN, data = worktrips)

# compare the models against each other.
modelsummary(list(mnl1, mnl2), statistic = "std.error", stars = TRUE, statistic_vertical = FALSE)
