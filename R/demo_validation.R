# This script generates plots and tables that can be used to validate the 
# highway assignments of travel demand models. The examples are not exhaustive,
# there are things you will need to add in order to pull out the insights you need.

# There is a detailed example of a good validation report at 
# http://wsp-sag.github.io/HickoryNC/Assignment-Validation.html that you can follow
# for your lab report.


# packages, functions ============
library(tidyverse)

# function for rmse
rmse <- function(x, y){
  sqrt(mean( (x - y)^2 ))
}

# function for percent rmse
prmse <- function(x, y) {
  rmse(x, y) / mean(y)
}

# Load data ================================
# Example file at https://bit.ly/33guMKy, you should use the version from your
# own model.
links <- read_csv("~/Box/share/Hwy_eval_links.csv") %>%
  mutate(pcterror = (Volume - Count) / Count * 100 )


# PRMSE by area type, facility type ============
# This is a table of PRMSE by facility types. The PRMSE should be lower for
# larger and more important facilities.
links %>%
  group_by(`Fac Type Group`) %>%
  mutate(modvmt = Distance * Volume,
         obsvmt = Distance * Count) %>%
  summarise(prmse = prmse(Volume, Count), vmt = sum(modvmt),
            obsvmt = sum(obsvmt)) 


# Plots =================
# This is a x-y scatter plot of counts and modeled volumes, with a 1:1 target
# trendline in the background.
ggplot(links, aes( x= Count, y = Volume)) + 
  geom_abline(slope = 1, intercept = 0, lty = "dotted") +
  geom_point() + theme_bw()


# MDD plot ===================
# This is the MDD plot defined in NCHRP 765. It includes a "target zone" 
# shown as a ribbon of acceptable percent error at different volume ranges.
mdd <- tibble(
  volume = c(1000, 2500, 5000, 10000, 25000, 50000, 70000),
  mdd = c(0.9, 0.7, 0.5, 0.35, 0.25, 0.2, 0.10) * 100
)

# start the plot
ggplot() + 
  # add the MDD ribbon, with positive upside and negative downside 
  geom_ribbon(
    data = mdd %>% mutate(mdd1 = -1 * mdd),
    aes(x = volume, ymax = mdd, ymin = mdd1), alpha = 0.2) + 
  # add a horizontal line
  geom_hline(yintercept = 0, lty = "dotted") +
  # add the link percent error
  geom_point(data = links, aes (x = Count, y = pcterror, color = factor(`Fac Type Group`))) + 
  theme_bw()
