
source("src/global.R")
library(dplyr)
library(mrgsolve)
rm(list = ls())

#' Choose a `PKPD` model from the internal model library (`?modlib`)
#' to explore

#' - Check the parameter values (`param`)
#' - Check the compartments and initial values (`init`)
#' - Review the model code (`see)

mod <- mread()


