load("hw2problem2.Rdata")
library(glmnet)
set.seed(0) # just to standardize our solutions

#### PART (a) ####

# Least squares
fit_ls = lm(y_train ~ X_train)
yhat_ls = X_test%*%fit_ls$coefficients[-1] + fit_ls$coefficients[1]
pe_ls = mean((yhat_ls - y_test)^2) # compute least squares MSE

# Perform fitting
fit_lasso = glmnet(X_train,y_train,family='gaussian',alpha=1)
fit_ridge = glmnet(X_train,y_train,family='gaussian',alpha=0)

# Perform cross-validation
cv_lasso = cv.glmnet(X_train,y_train,family='gaussian',alpha=1)
cv_ridge = cv.glmnet(X_train,y_train,family='gaussian',alpha=0)

# Extract indices of relevant lambdas
lasso_idx_min = which(cv_lasso$lambda==cv_lasso$lambda.min)
lasso_idx_1se = which(cv_lasso$lambda==cv_lasso$lambda.1se)
ridge_idx_min = which(cv_ridge$lambda==cv_ridge$lambda.min)
ridge_idx_1se = which(cv_ridge$lambda==cv_ridge$lambda.1se)

# Perform prediction on test data
yhat_lasso_min = predict(cv_lasso,newx=X_test,s=cv_lasso$lambda[lasso_idx_min])
yhat_lasso_1se = predict(cv_lasso,newx=X_test,s=cv_lasso$lambda[lasso_idx_1se])
yhat_ridge_min = predict(cv_ridge,newx=X_test,s=cv_ridge$lambda[ridge_idx_min])
yhat_ridge_1se = predict(cv_ridge,newx=X_test,s=cv_ridge$lambda[ridge_idx_1se])

# Compute prediction errors on test data
pe_lasso_min = mean((yhat_lasso_min - y_test)^2)
pe_lasso_1se = mean((yhat_lasso_1se - y_test)^2)
pe_ridge_min = mean((yhat_ridge_min - y_test)^2)
pe_ridge_1se = mean((yhat_ridge_1se - y_test)^2)

# Extract relevant cross-validation errors
cvm_lasso_min = cv_lasso$cvm[lasso_idx_min]
cvm_lasso_1se = cv_lasso$cvm[lasso_idx_1se]
cvm_ridge_min = cv_ridge$cvm[ridge_idx_min]
cvm_ridge_1se = cv_ridge$cvm[ridge_idx_1se]

# Print relevant error values
cat("Least Squares Prediction Error: ", pe_ls, "\n\n")
print('Lasso Prediction Errors:')
cat("lambda.min: ", pe_lasso_min, "  lambda.1se: ", pe_lasso_1se, "\n\n")
print('Ridge Prediction Errors:')
cat("lambda.min: ", pe_ridge_min, "  lambda.1se: ", pe_ridge_1se, "\n\n")
print('Lasso Cross-Validation Errors:')
cat("lambda.min: ", cvm_lasso_min, "  lambda.1se: ", cvm_lasso_1se, "\n\n")
print('Ridge Cross-Validation Errors:')
cat("lambda.min: ", cvm_ridge_min, "  lambda.1se: ", cvm_ridge_1se, "\n\n")

# Plot cross-validation error over lambdas
par(mfrow=c(1,2))
plot(cv_lasso)
plot(cv_ridge)

#### Part (b) ####

# Compute number of nonzero components of beta
nnz_lasso_min = sum(fit_lasso$beta[,lasso_idx_min] != 0)
nnz_lasso_1se = sum(fit_lasso$beta[,lasso_idx_1se] != 0)
nnz_ridge_min = sum(fit_ridge$beta[,ridge_idx_min] != 0)
nnz_ridge_1se = sum(fit_ridge$beta[,ridge_idx_1se] != 0)

# Print number of nonzero beta components in each model
print('Lasso Nonzeros:')
cat("lambda.min: ", nnz_lasso_min, "  lambda.1se: ", nnz_lasso_1se, "\n\n")
print('Ridge Nonzeros:')
cat("lambda.min: ", nnz_ridge_min, "  lambda.1se: ", nnz_ridge_1se, "\n\n")


#### Part (c) ####

# Print first 3 beta coefficients in each model
print('First 3 Beta Coefficients under Lasso, lambda.min:')
print(fit_lasso$beta[1:3,lasso_idx_min])
print('First 3 Beta Coefficients under Lasso, lambda.1se:')
print(fit_lasso$beta[1:3,lasso_idx_1se])
print('First 3 Beta Coefficients under Ridge, lambda.min:')
print(fit_ridge$beta[1:3,ridge_idx_min])
print('First 3 Beta Coefficients under Ridge, lambda.1se:')
print(fit_ridge$beta[1:3,ridge_idx_1se])
