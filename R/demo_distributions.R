library(tidyverse)
library(nhts2017)

hh <- nhts_households %>%
  filter(travday == "02")
  

# Continuous variables
trips <- nhts_trips %>%
  filter(houseid %in% hh$houseid) %>%
  filter(trptrans %in% c("03", "04", "01", "02"))
  filter(trpmiles < 120)

# histogram
hist(log(trips$trpmiles))

ggplot(trips, aes(x = trpmiles)) + 
  geom_histogram(bins = 10) + 
  theme_bw()


# discrete / categorical
table(trips$trptrans)

trips %>%
  group_by(trptrans) %>%
  summarise(number = n()) %>%
  arrange(-number) %>%
  mutate(
    proportion = number / sum(number)
  )

ggplot(trips, aes(x = as_factor(trptrans, levels = "labels"))) + 
  geom_bar()


# joint distribution
ggplot(trips, aes(x = trpmiles, fill = as_factor(trptrans, levels = "labels"))) + 
  geom_density(alpha = 0.5) + 
  scale_x_log10()


# marginals and joint
trips %>%
  mutate(
    miles = cut(trpmiles, breaks = c(0, 1, 5, 10, 30, 50, Inf))
  ) %>%
  group_by(trptrans, miles) %>%
  summarise(number = n()) %>%
  pivot_wider(names_from = miles, values_from = number)
