
source("src/global.R")
library(dplyr)
library(mrgsolve)
rm(list = ls())

#' Load the model called "pk2" (2-cmt pk) from the internal library
#' 
#' Construct a simulation that shows how time to steady state depends
#' on volume of distribution (V2); look at 10, 50 and 100 L
#' while dosing 100 mg every day for a month
#' 


mod <- mread("model/meropenem") %>% zero_re()

param(mod)


tlook <- 8

idata <- tibble(AGE = runif(100, mod$AGE/2, mod$AGE*2))

mod %>% 
  idata_set(idata) %>% 
  ev(amt = 1000, tinf = 0.5) %>% 
  mrgsim() %>% 
  summarise(sd = sd(Y))



idata <- tibble(CLCR = runif(100,mod$CLCR/2,mod$CLCR*2))

mod %>% 
  idata_set(idata) %>% 
  ev(amt = 1000, tinf = 0.5) %>% 
  mrgsim() %>% 
  filter(time==tlook) %>% 
  summarise(sd = sd(Y))

idata <- tibble(WT = runif(100,mod$WT/2,mod$WT*2))

mod %>% 
  idata_set(idata) %>% 
  ev(amt = 1000, tinf = 0.5) %>% 
  mrgsim() %>% 
  filter(time==tlook) %>% 
  summarise(sd = sd(Y))


