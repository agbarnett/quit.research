# Decision.Tool.function.R
# A Bayesian decision tool for when to quit applying
# Version for shiny
# Feb 2017
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
library(ggplot2)
library(grid)
library(doBy)

quit = function(mean.prob=0.2, prior.success=1, n.fail=5){

# prior
prior.failures = (prior.success/mean.prob) - prior.success
theta = seq(0, 0.8, 0.001)
n.prior = length(theta)
prior = dbeta(x=theta, shape1=prior.success+1, shape2=prior.failures+1) # beta
prior = prior / sum(prior) # normalise
# starting probability of being in the bottom half
pbeta(mean.prob, shape1=prior.success+1, shape2=prior.failures+1)
for.plot.prior = data.frame(theta=theta, prior=prior)

# posterior is beta by conjugacy
n.attempts = n.fail
post = dbeta(x=theta, shape1=prior.success+1+0, shape2=prior.failures+1+n.attempts-0) 
post = post/sum(post)
for.plot.posterior = data.frame(theta=theta, post=post, n.attempts=n.attempts)
# probability in bottom half
prob = pbeta(mean.prob , shape1=prior.success+1+0, shape2=prior.failures+1+n.attempts-0)
bottom = data.frame(n.attempts=n.attempts, prob=prob)

## plot prior plus posterior
for.plot.prior$group = 'Prior'
for.plot.posterior$group = 'Posterior'
for.plot.posterior = subset(for.plot.posterior, select=c('theta', 'post', 'group')) # to help with merge
names(for.plot.posterior)[2] = 'prior'
for.plot.prior.posterior = rbind(for.plot.prior, for.plot.posterior)
pplot = ggplot(data=for.plot.prior.posterior, aes(x=theta, y=prior, fill=group))+
  theme_bw()+
  geom_area(alpha=0.3, position='identity')+
  xlab("Probability of winning fellowship")+
  ylab('Probability density')+
  scale_fill_manual(name=NULL, values=cbPalette[2:3])+
  geom_vline(xintercept=mean.prob, col=cbPalette[4], size=1.1)+
  geom_text(aes(x=0.07, y=0, label='Plodder'), vjust=0, size=7)+
  geom_text(aes(x=0.7, y=0, label='Genius'), vjust=0, size=7)+
  theme(plot.margin=unit(c(1, 1, 1, 1), "mm"), legend.position=c(0.8, 0.8),
        text=element_text(size = 20))

# return
ret = list()
ret$plot = pplot
ret$bottom = bottom$prob
return(ret)
}

