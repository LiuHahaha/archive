# Compute either K-means clustering
#
# Arguments:
# x: data matrix, n observations (rows) by p features (cols).
# centers: a vector giving the starting centers. Defaults
#   to NULL in which case we choose k centers at random.
# k: number of clusters. If the centers argument is specified,
#   then this doesn't need to be specified.
# maxiter: Maximum number of iterations before we quit. 
#   Defaults to 100.
#
# Returns:
# centers: a vector of length k, giving the final centers.
# cluster: a vector of length n, giving the final clustering
#   assignments.
# iter: number of iterations performed.
#
my.kmeans = function(x, centers=NULL, k=NULL, maxiter=20) {
  n = nrow(x)
  p = ncol(x)
  # Initialize the centers, unless there were supplied in the function call
  # If centers are not given, k must be specified
  if (is.null(centers)) {
    if (is.null(k)) stop("Either centers or k must be specified.")
    centers = matrix(runif(k*p, min(x), max(x)), nrow=k)
  }
  #We can get k from the number of centers we were given
  k = nrow(centers)
  
  cluster = matrix(0, nrow=0, ncol=n)
  cluster.old = cluster
  
  for (iter in 1:maxiter) {
    #Given the centers we have, assign every point to its closest center
    
    # Assign each data point to the nearest cluster
    # (we represent assigning data point i to cluster j by cluster[i] = j)
    dists = numeric(k)
    for (i in 1:n) {
      for (j in 1:k) {
        # compute distance from i^th data point to j^th center
        dists[j] = dist(rbind(x[i,], centers[j,])) 
      }

      # the outer min is just to break ties
      cluster[i] = min(which(dists == min(dists)))
    }

    # Given the cluster assignments, recompute the centers
    # (the means of points assigned to each cluster, with one row per cluster).
    for (j in 1:k) {
      centers[j,] = colMeans(x[which(cluster == j),])
    }
    
    # Check if the cluster assignments have changed.  If not, then we are done.
    if (iter > 1 & all(cluster == cluster.old)) {
      break
    }
    
    # Keep track of previous clustering so we can see if it changed
    cluster.old=cluster
  }
  return(list(centers=centers,cluster=cluster,iter=iter))
}

#Simple test example:
set.seed(0)
x = rbind(matrix(rnorm(2*100,sd=0.2),ncol=2),
          scale(matrix(rnorm(2*100,sd=0.3), ncol=2), cent=-c(1,1), scal=F),
          scale(matrix(rnorm(2*100,sd=0.2), ncol=2), cent=-c(0,1), scal=F))
#Use 3 clusters
k = 3
#Initialize the centers
cent.init = rbind(c(0.5,1),c(1,0),c(0,0.5))

km_yours = my.kmeans(x, centers=cent.init, maxiter=20)
km_truth = kmeans(x, centers=cent.init, iter.max = 20, algorithm = "Lloyd")

xtabs(~km_yours$cluster+km_truth$cluster)

#Plot your success!
nicecolors = c("#E69F00", "#009E73", "#0072B2", "#CC79A7")
plot(x[,1], x[,2], pch=20, col=nicecolors[km_yours$cluster])
points(km_yours$centers, pch=20, cex=3, col=nicecolors)
