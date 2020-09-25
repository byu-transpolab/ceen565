library(tidyverse)
library(nhts2017)


# Gather the data we need =========
hh <- nhts_households %>% 
  # filter to MSA size 2, travel on weekday
  filter(msasize == "02", !travday %in% c("01", "07")) %>%
  select(houseid, wthhfin, hhsize, hhvehcnt, numadlt, hhfaminc, wrkcount) %>%
  mutate(
    hhsize = ifelse(hhsize > 4, 4, hhsize),
    hhvehcnt = ifelse(hhvehcnt > 3, 3, hhvehcnt),
    wrkcount = ifelse(wrkcount > 2, 2, wrkcount)
  )


trips <- nhts_trips %>%
  filter(houseid %in% hh$houseid) %>%
  group_by(houseid, trippurp) %>%
  summarise(trips = n()) %>%
  pivot_wider(id_cols = houseid, names_from = trippurp, 
            values_from = trips, values_fill = 0)

nato0 <- function(x){ifelse(is.na(x), 0, x)}

tripprod <- hh %>%
  left_join(trips, by = "houseid") %>%
  # change all NA values in columns from the trips data to 0
  mutate_at(vars(names(trips)), nato0)

# Trip productions ==============
tripprod %>%
  group_by(hhsize, hhvehcnt) %>%
  summarise(mean_hbo = weighted.mean(HBO, wthhfin)) %>%
  pivot_wider(names_from = hhvehcnt, values_from = mean_hbo)

tripprod %>%
  group_by(hhsize, hhvehcnt) %>%
  summarise(count = n()) %>%
  pivot_wider(names_from = hhvehcnt, values_from = count)

# consider variance ======
tripprod %>%
  group_by(hhsize, hhvehcnt) %>%
  summarise(
    mean_hbw = weighted.mean(HBW, wthhfin),
    sd_hbw = sqrt(Hmisc::wtd.var(HBW, wthhfin))
  ) %>%
  ggplot(aes(x = hhsize, y = mean_hbw, ymin = mean_hbw - sd_hbw, ymax = mean_hbw + sd_hbw,
             color = factor(hhvehcnt), fill = factor(hhvehcnt))) + 
  geom_line() +
  geom_ribbon(alpha = 0.1) + 
  facet_wrap(~hhvehcnt)
  
