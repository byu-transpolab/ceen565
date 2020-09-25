library(tidyverse)

psrc_attractions <- read_csv("https://byu.box.com/shared/static/7ci8vomip719bdno7xl5ftjj940dausm.csv")


ggplot(psrc_attractions, aes(x = totemp, y = HBW)) +
  geom_point() + stat_smooth(method = "lm")


lm1 <- lm(HBW ~ totemp, data = psrc_attractions)
summary(lm1)
plot(lm1)

hbo_rates <- lm(HBO ~ tothh + retl + manu + offi + gved + othr, 
                data = psrc_attractions)
summary(hbo_rates)
plot(hbo_rates, which = 1)

hbo_rates2 <- lm(HBO ~ -1 + tothh + retl + offi,
                data = psrc_attractions)
summary(hbo_rates2)
plot(hbo_rates2, which = 1)


