alpha0 <- 1871 + 253 + 605
beta0 <- 1924*3 + 1

alpha1 <- 44 + 8 + 16
beta1 <- 41*3 + 2
p1 <- alpha1/(alpha1 + beta1)




png('ervin-santana.png')
curve(dbeta(x,alpha0,beta0),xlim=c(0.29,0.37), xlab='Probability of hit, walk, homerun', ylab='Density', main='Ervin Santana Pitching Stats')

x1 <- qbeta(0.975, alpha0, beta0)
x0 <- qbeta(0.025, alpha0, beta0)
coord.x <- c(x0,seq(x0,x1,0.001),x1)
coord.y <- c(0, dbeta(seq(x0,x1,0.001), alpha0, beta0),0)
polygon(coord.x, coord.y, col='red')

abline(v=p1, col='blue')
dev.off()
