source("src/global.R")
library(dplyr)
library(mrgsolve)
rm(list = ls())

#' 
#' G-CSF can be dosed SC or IV at 1 to 10 ug / kg
#' You will practice implementing these simulations
#' with the model called gcsf_pk.cpp in the model directory
#' 
 
mod <- mread_cache("model/gcsf_pk.cpp")

#' First, SC administration of 5 mcg/kg (WT = 70 kg)
e <- ev(amt =1*70, cmt=1)

#' 
#' Simulate and plot a single dose
#' Look at GCSF PK and ANC over 120 hours
#' 
out <- mrgsim(mod, events =e, end = 60, delta=0.1)

plot(out,CP~time, logy=TRUE)



