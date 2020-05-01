library(tidyverse)
library(nhts2017)

# demonstration trips dataset
trips <- nhts2017::nhts_trips
trips %>%
  select(houseid, personid, trpmiles, trippurp) %>%
  sample_frac(0.01) %>%
  write_csv("data/demo_trips.csv")
