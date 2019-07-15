#.libPaths("/data/Rlibs")
options(mrgsolve.soloc = "build")
knitr::opts_chunk$set(
  comment = '.', 
  fig.height = 5, 
  fig.width = 9, 
  fig.align = "center",
  message = FALSE,
  warning = FALSE
)
ggplot2::theme_set(ggplot2::theme_bw())
