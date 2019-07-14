#' https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3555057/pdf/bcp0075-0180.pdf

library(mrgsolve)
library(dplyr)
library(PKPDmisc)
library(purrr)

mod <- mread("cipro", "model")

init(mod)

#' 400 mg IV over 1 hour
single <- ev(amt = 400, tinf = 1)

single

out <- mrgsim(mod, events = single, end = 48, delta = 0.1)

plot(out)

daily <- ev(amt = 400, ii = 12, tinf = 1, addl = 1, ss=1)

idata <- expand.idata(SEX = c(0,1), WT = c(70), CRCL = c(60,81))

out <- 
  mod %>%
  ev(daily) %>% 
  idata_set(idata) %>% 
  carry_out(SEX,WT,CRCL) %>%
  mrgsim(Req = "CP", delta = 0.1, end = 24)

plot(out, CP ~time | SEX, scales="same")  

count(as.data.frame(out),ID)


out %>% 
  as_tibble() %>%
  group_by(SEX,WT,CRCL) %>% 
  summarise(AUC = auc_partial(time, CP))
  



#' Exposure by tissue
mod <- mread("cipro_conc", "model", req="")
out <- mrgsim(mod, events = single, end = 120, delta = 0.1, output="df")

long <- tidyr::gather(out, variable, value,CLUN:CKID)

summ <- 
  long %>% 
  group_by(variable) %>% 
  summarise(auc = auc_partial(time,value), Cmax = max(value))

library(ggplot2)
ggplot(summ, aes(x = variable, y = auc)) + geom_col() + theme_bw()

ggplot(summ, aes(x = variable, y = Cmax)) + geom_col() + theme_bw()



mod <- mread("cipro", "model") %>% zero_re()

data <- readRDS("data/cipro_post.RDS") %>% filter(irep <=100)

e <- ev(amt = 400, tinf = 4, ii = 12, until = 72)

out <- mrgsim_ei(mod, e, data, end = 72, carry_out = "irep", add=0.05, delta=0.25)

out %>% 
  filter(time >= 48) %>% 
  group_by(irep) %>% 
  mutate(DV = CP) %>%
  summarise(auc = auc_partial(time,DV)) %>%
  ungroup() %>% 
  summarise(med = median(auc), lo = quantile(auc,0.05), hi = quantile(auc,0.95))

sims <- 
  out %>% 
  filter(time > 0, time <=12) %>%
  mutate(DV = Ckid) %>%
  group_by(time) %>%
  summarise(med = median(DV), lo = quantile(DV,0.05), hi = quantile(DV,0.95))

ggplot(sims, aes(time)) + 
  geom_ribbon(aes(ymin = lo, ymax = hi), alpha = 0.4, fill = "firebrick") +
  geom_line(aes(y = med), lwd = 1, col = "firebrick") + 
  scale_y_log10() +  theme_bw()


#' First, make all of the dosing regimens
e1 <- ev(amt = 200, ii = 12, tinf = 1, until = 48, CRCL = 30)
e2 <- ev(amt = 400, ii = 12, tinf = 1, until = 48)
e3 <- ev(amt = 400, ii = 8,  tinf = 1, until = 48)
e4 <- ev(amt = 600, ii = 8,  tinf = 1, until = 48)

mrgsim_e(mod,e1, delta=0.1, end=48) %>% plot(CP~time)

x <- list(e1,e2,e3,e4)

data <- readRDS("data/cipro_post.RDS") %>% filter(irep <= 1000)

out <- imap_dfr(x, .f = function(e,i) {
  mod %>% 
    ev(e) %>% 
    idata_set(data) %>%
    update(delta = 0.25, start = 24, end = 48) %>%
    mrgsim(carry.out="irep,ARM",Req="CP") %>% 
    mutate(ID = i*1000 + irep, group=i)
})

#' mic 0.25
sims <- filter(out, group  %in% c(1,3))
sum25 <- 
  sims %>% 
  group_by(ID,group) %>%
  summarise(auc = auc_partial(time,CP)) %>% 
  mutate(aucr = auc/0.5)

sum25


ggplot(sum25, aes(x = aucr)) + 
  geom_histogram(alpha = 0.7,col="grey") + 
  facet_wrap(~group) + theme_bw() + 
  geom_vline(xintercept = 125, col = "firebrick", lty =2,lwd=2)



#' mic 1
sims <- filter(out, group %in% c(2,3,4))
sum1 <- 
  sims %>% 
  group_by(ID,group) %>%
  summarise(auc = auc_partial(time,CP)) %>% 
  mutate(aucr = auc/0.5)

sum1


ggplot(sum1, aes(x = aucr)) + 
  geom_histogram(alpha = 0.7,col="grey") + 
  facet_wrap(~group) + theme_bw() + 
  geom_vline(xintercept = 125, col = "firebrick", lty =2,lwd=2)













