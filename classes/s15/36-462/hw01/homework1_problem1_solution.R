# if you don't already have glmnet installed, run
# install.packages("glmnet", repos = "http://cran.us.r-project.org")

library(glmnet)
n = 50
p_max = 40
reps = 100 # number of trials
ridge_lambda = 1

## Comment one out
# method = "linear" #For linear regression
method = "ridge" #For ridge regression

bias = numeric(p_max)
variance = numeric(p_max)
pred_err = numeric(p_max)

for (p in 1:40){
  # Skip p=1 in ridge regression because glmnet fails
  if (method=='ridge' && p==1){next}
  
  X = matrix(rnorm(n*p),ncol=p) # n normal random covariate samples in R^p
  beta = c(1,runif(p-1,-.2,.2)) # beta_1 = 1 and beta_2,...,beta_p uniformly random
  y_hat = matrix(0,nrow=n,ncol=reps)
  y_prime = matrix(0,nrow=n,ncol=reps)
  for (k in 1:reps){
    y_train = X%*%beta + rnorm(n) # y = X*beta + noise
    if (method=='linear'){
      # lsfit is convenient; important to not include intercept here
      beta_hat = lsfit(X,y_train,intercept=FALSE)$coef
    } else if (method=='ridge') {
      # glmnet returns a sparse vector with an entry for the intercept, even
      # when the intercept is excluded this just extracts the correct entries
      # and makes them numeric
      beta_hat = as.numeric(coef(glmnet(X,y_train,intercept=FALSE,alpha=0,family='gaussian'),s=ridge_lambda)[2:(p+1)])
    }
    y_hat[,k] = X%*%beta_hat # true y
    y_prime[,k] = X%*%beta + rnorm(n) # predicted y
  }
  pred_err[p] = mean((y_prime-y_hat)^2)
  bias[p] = mean((X%*%beta-rowMeans(y_hat))^2)
  variance[p] = mean((y_hat-rowMeans(y_hat))^2)
}
# plot error for each p
plot(1:p_max,pred_err,col='black',ylim=c(0,3),pch=20,xlab="Dimension",ylab="")
points(1:p_max,bias,col='blue',pch=20)
points(1:p_max,variance,col='red',pch=20)
# plot trend lines
abline(a=0,b=1/n,lty=2,col='grey')
abline(a=1,b=1/n,lty=2,col='grey')
abline(h=1,lty=2,col='grey')
legend('topleft',legend=c("Pred. Err.","Bias","Variance"),fill=c('black','blue','red'))
