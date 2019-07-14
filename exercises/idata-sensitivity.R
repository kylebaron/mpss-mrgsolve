
library(mrgsolve)

id30 <- function(mod,n=5,cv=30,df=FALSE) {
  x <- as.numeric(param(mod))
  x <- x[x>0]
  if(!length(x)) stop()
  mu <- log(x)
  v <- (cv/100)^2
  sigma <- diag(v,length(x))
  sims <- MASS::mvrnorm(n,mu,sigma)
  sims <- exp(sims)
  sims <- as.data.frame(sims)
  names(sims) <- names(mu)
  if(df) return(sims)
  mod %>% idata_set(sims)
}

mod <- modlib("pk1", add = c(0.2,0.8)) %>% Req(CP)

mod %>% 
  param(CL = .$CL*2) %>%
  id30(n=100) %>% ev(amt = 100) %>% 
  mrgsim(end=24) %>% plot(logy=TRUE)


