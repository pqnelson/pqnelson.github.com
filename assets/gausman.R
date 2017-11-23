alpha0 <- 213 + 22 + 65
beta0 <- 214*3 + 1
x0 <- qbeta(0.05, alpha0, beta0)
x1 <- qbeta(0.95, alpha0, beta0)
coord.x <- c(x0,seq(x0,x1,0.001),x1)
coord.y <- c(0, dbeta(seq(x0,x1,0.001), alpha0, beta0),0)

# https://www.baseball-reference.com/boxes/ANA/ANA201508070.shtml
alpha1 <- 9
beta1 <- 27 - alpha1
p1 <- alpha1/(alpha1 + beta1)

png('gausman-pitching.png')
curve(dbeta(x,alpha0,beta0),xlim=c(0.25,0.37), xlab='Probability of hit, walk, homerun', ylab='Density', main='Gausman Pitching Stats')
polygon(coord.x, coord.y, col='red')
abline(v=p1, col='blue')
dev.off()
