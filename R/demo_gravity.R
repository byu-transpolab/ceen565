# inputs
p <- c(100, 200, 100)
a <- c(200, 50, 150)
C <- matrix(c(2,5,4,5,2,3,4,3,2), nrow=3, byrow=TRUE)

trips <- matrix(0, nrow = 3, ncol = 3)
b <- 1.5

for (i in 1:3) {
  
  bottomA <- sum(a * C[i, ]^(-b))
  
  for (j in 1:3) {
    topA <- a[j] * C[i,j]^(-b)
    trips[i, j] <- p[i] * topA / bottomA
  }
}

rowSums(trips)
colSums(trips)

#' Gravity Model Function
#' @param p vector of productions, length n
#' @param A vector of attractions, lenth n
#' @param C matrix of impedances, dim n x n
#' @param b impedance parameter
gravity <- function(p, a, C, b){
  # output matrix (all 0 here)
  trips <- matrix(0, nrow = length(p), ncol = length(a)) 
  # loop over all rows (production)
  for (i in 1:length(p)) {
    bottomA <- sum(a * C[i, ]^(-b)) # denominator
    
    # loop over all columns (attraction)
    for (j in 1:length(a)) {
      # calculate gravity model for trips from i to j
      topA <- a[j] * C[i,j]^(-b)
      trips[i, j] <-  p[i] * topA / bottomA
    }
  }
  
  return(trips)
}

#' Function to balance gravity model PSEUDO-CODE
#' @param p vector of productions, length n
#' @param A vector of attractions, lenth n
#' @param C matrix of impedances, dim n x n
#' @param b impedance parameter
#' @param tolerance Acceptable change in trips matrix
balance_gravity <- function(p, a, C, b, tolerance = 0.01, maxiterations = 40) {
  # loop through algorithm
  while(error > tolerance){
    # compute gravity model with adjusted attractions, using your function
    trips <- gravity(p, astar, C, b) 
    # calculate the error as the change in trips in successive iterations
  }
  return(trips)
}
# calibration
observed <- matrix(c(80, 5, 15, 80, 40, 80, 40, 5, 55), nrow=3, byrow=TRUE)

# root mean squared error
rmse <- function(x, y){
  sqrt(mean((x - y)^2))
}


single_constrained <- gravity(p, a, C, 2)
double_constrained <- balance_gravity(p, a, C, 2)



for(b in seq(0.1, 5, 0.1)){
  print(rmse(gravity(p, a, C, b), observed))
  print(b)
}

tibble(
  b = seq(0.1, 5, 0.1),
  rmse = rmse(gravity(p, a, C, b), observed)
)

  




gravity(p, a, C, 1.5)
gravity(p, a, C, 2)
