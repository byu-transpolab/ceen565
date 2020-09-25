library(tidyverse)

mtcars
ggplot(mtcars, aes(y = mpg, x = disp)) + 
  geom_point() +  stat_smooth(method = "lm", color = "red") + theme_bw()

# create y vector, X matrix
y <- mtcars$mpg
X <- model.matrix(mpg ~ disp, data = mtcars)

# Calculate beta estimates using least squares estimator
# (X'X)^-1 * X' y
XTX1 <- solve(t(X) %*% X)
beta <- XTX1 %*% t(X) %*% y

# Calculate variance of beta estimator, which is the sum of squared
# residuals multiplied by the XTX1 matrix
# s2 (X'X)^-1
# The standard error is the square root of the variance
e <- y - X %*% beta
s2 <- sum(e^2 / (nrow(X) - ncol(X)))
se <- sqrt(diag(s2 * XTX1))

#View results
tibble(
  term = colnames(X), 
  estimate = beta,
  stderr = se,
  tstat = beta / se,
  pval = 2*pt(abs(tstat), nrow(X) - ncol(X), lower.tail = FALSE)
)

# r squared is 1 - the ratio of the residual sum of squares to the total sum of
# squares (using mean of y as a reference)
sst <- sum((y - mean(y))^2)
ssr <- sum((y - X %*% beta)^2)
1 - ssr / sst

# compare to LM
summary(lm(mpg ~ disp, data = mtcars))
