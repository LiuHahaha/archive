#Clear the workspace
rm(list=ls())
set.seed(0)

#Load the data.  NAs are coded as "?"
dat = read.csv('breast-cancer-wisconsin.data', header=FALSE, na.strings="?")
#Label the data fields.  Description and values are as noted.
names(dat) = c(
  'id',#Sample code number            id number
  'thickness',#Clump Thickness               1 - 10
  'size_uniformity',#Uniformity of Cell Size       1 - 10
  'shape_uniformity',#Uniformity of Cell Shape      1 - 10
  'adhesion',#Marginal Adhesion             1 - 10
  'size',#Single Epithelial Cell Size   1 - 10
  'nuclei',#Bare Nuclei                   1 - 10
  'chromatin',#Bland Chromatin               1 - 10
  'nucleoli',#Normal Nucleoli               1 - 10
  'mitoses',#Mitoses                       1 - 10
  'class'#Class:            (2 for benign, 4 for malignant)
  )
#Drop ID number, we don't want to use this for anything
dat = dat[,-1]
#Change outcome to be descriptive
dat$class = ifelse(dat$class==2, "benign", "malignant")
#Make outcome a factor
dat$class = as.factor(dat$class)
#Drop a few missing things
dat = dat[complete.cases(dat),]

#Tumor characteristics
X = dat[,1:9]
#Tumor class
y = dat[,10]

# Cluster the tumors based on X
km = kmeans(X, centers = 2, iter.max = 20, nstart = 10, algorithm = "Lloyd")
# Compare the cluster assignments to y
print(table(km$cluster, y))
