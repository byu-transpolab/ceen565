## Load packages
library(mlogit)
library(tidyverse)
library(modelsummary)

# alternatives <- c("Drive Alone", "Share 2", "Share 3+", "Transit", 
#                   "Bike", "Walk")
# load("data/WorkTrips.Rdata")
# 
# worktrips <-  worktrips %>%
#    mutate(
#      id = str_c(HHID, PERID, sep = "_"),
#      alternative = factor(ALTNUM, labels = alternatives),
#      CHOSEN = as.logical(CHOSEN) 
#   ) %>%
#    select(id, alternative, ALTNUM, CHOSEN:M_OVTT) %>%
#    dfidx(idx = list("id", "alternative"))

#write_rds(worktrips, "data/worktrips_dfidx.rds")

# data file : https://byu.box.com/shared/static/ftzy74uaug0voet2wvwhgicxamhgcvp7.rds"
worktrips <- read_rds("data/worktrips_dfidx.rds")



# log-likelihood ============
freq <- worktrips %>% 
  filter(CHOSEN) %>% group_by(ALTNUM) %>%
  tally()
big_n <- sum(freq$n)


ll0 <- sum(freq$n * log(1/6))
llC <- sum(freq$n * log(freq$n / big_n))

# estimate models =======
# cost-only model
ivt_mnl <- mlogit(CHOSEN ~ IVTT, data = worktrips)
tvt_mnl <- mlogit(CHOSEN ~ TVTT, data = worktrips)

popden_ivt_mnl <- mlogit(CHOSEN ~  IVTT | RSPOPDEN, data = worktrips)

modelsummary(list(ivt_mnl, tvt_mnl, popden_ivt_mnl), digits = 4)


# Nested Logit =========
mnl <- mlogit(CHOSEN ~ IVTT + OVTT + COST | WKEMPDEN, data = worktrips)

nl <- mlogit(CHOSEN ~ COST + TVTT  + OVTT | WKEMPDEN, 
             data = worktrips,
             nests = list(auto = c('Drive Alone', 'Share 2', 'Share 3+'),
                          nonauto = c('Bike', 'Walk', 'Transit')),
             un.nest.el = F) ### estimate unique coefficients for each nest

nl1 <- mlogit(CHOSEN ~ COST + TVTT  + OVTT | WKEMPDEN, 
             data = worktrips,
             nests = list(auto = c('Drive Alone'),
                          carpool = c('Share 2', 'Share 3+'),
                          nonauto = c('Bike', 'Walk', 'Transit')),
             un.nest.el = T) ### estimate a single coefficient for all nests

modelsummary(list(mnl, nl, nl1), digits = 4)


# Segmentation ======
# The logit data uses a rownames object to identify unique users. This means you have to
# re-build the logit data after you segment. Otherwise you'll get the following error:
# Error in data.frame(lapply(index, function(x) x[drop = TRUE]), row.names = rownames(mydata)) : 
#    row names supplied are of the wrong length

nl_li <- mlogit(CHOSEN ~ COST + TVTT  + OVTT | WKEMPDEN, 
             data = worktrips %>% filter(HHINC < 50), # use the low-income segment only!
             nests = list(auto = c('Drive Alone', 'Share 2', 'Share 3+'),
                          nonauto = c('Bike', 'Walk', 'Transit')),
             un.nest.el = TRUE)

nl_hi # <- you should be able to get this from here! 


# logsums ====
