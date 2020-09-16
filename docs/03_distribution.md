# Trip Distribution {#chap-distribution}

The purpose of the trip distribution model is to show


## Homework {-#hw-distribution}
<div class="figure">
<img src="images/03_networkgraph.png" alt="Simple 3-zone system." width="570" />
<p class="caption">(\#fig:networkgraph)Simple 3-zone system.</p>
</div>

shows a basic three-zone system,
including the
productions and attractions at each zone, as well as the travel times between them.

Figure \@ref(fig:networkgraph)^[This problem is adapted with permission from 
*Urban Transportation Planning: Second Edition* by Michael D. Meyer and 
Eric J. Miller.] 
presents a simple three zone system, the link travel times for this system (for
internal trips, $t_{ii}=2$ globally), and the zonal productions and attractions.
Assume a gravity model of the form

$$T_{ij}=\frac{P_iA_j^*(t_{ij})^{-b}}{\sum_{j'}A^*_{j'}(t_{ij})^{-b}}$$

where $A_j^*$ is a "modified attraction term" defined by the
algorithm shown in Figure \@ref(fig:tripbalancing) below. This algorithm
constrains the predicted trips to a given zone to equal the true zonal
attractions $A_j$.

<div class="figure">
<img src="images/03_algorithm.png" alt="Trip balancing algorithm." width="384" />
<p class="caption">(\#fig:tripbalancing)Trip balancing algorithm.</p>
</div>

### First Problem: Gravity Model Development

Write a computer program or build a spreadsheet that computes the
O-D flows for this system using the algorithm (with $\varepsilon=1$). Find the
value of $b$ (to a single decimal place) which provides the "best fit" with the
observed O-D matrix in the table below. Discuss how you determined which $b$
value gave the "best fit."

| $i$ |  1 |  2 |  3 |
|-----|:--:|:--:|:--:|
| 1   | 80 |  5 | 15 |
| 2   | 80 | 40 | 80 |
| 3   | 40 |  5 | 55 |

The function below shows how to calculate one round of a gravity model in R.
The function takes the production and attractions vector, in addition to the
cost matrix and the impedance parameter, and calculates the $T_{ij}$ matrix.


```r
#' Gravity Model
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
```

Once you have this function (as well as the necessary vectors and cost matrix),
you can calculate the gravity model with arbitrary values of the impedance coefficient.

```r
# calculate one round of gravity model with 
p <- c(100, 200, 100)
a <- c(200, 50, 150)
C <- matrix(c(2,5,4,5,2,3,4,3,2), nrow=3, byrow=TRUE)
gravity(p, a, C, b = 0.5)
```

```
##          [,1]      [,2]     [,3]
## [1,] 59.22613  9.364473 31.40940
## [2,] 84.61917 33.448665 81.93216
## [3,] 42.56523 12.287524 45.14725
```

```r
gravity(p, a, C, b = 1.5)
```

```
##          [,1]      [,2]     [,3]
## [1,] 75.27793  4.760994 19.96108
## [2,] 55.52540 54.870858 89.60374
## [3,] 28.52074 10.977638 60.50162
```

The code I provided above is real, and will work for you if you choose to do
this exercise in R. The code below is pseudo-code that you will need to flesh
out on your own (and with your classmates) to accomplish the first part of this
homework. You will need to figure out how to store the adjusted attractions
vector, as well as how to compute the error between successive iterations of the
algorithm.


```r
#' Function to balance gravity model PSEUDO-CODE
#' @param p vector of productions, length n
#' @param A vector of attractions, lenth n
#' @param C matrix of impedances, dim n x n
#' @param b impedance parameter
#' @param tolerance Acceptable change in trips matrix
balance_gravity(p, a, C, b, tolerance) {
  # loop through algorithm
  while(error > tolerance){
    # compute gravity model with adjusted attractions, using your function
    trips <- gravity(p, astar, C, b) 
    # calculate the error as the change in trips in successive iterations
  }
  return(trips)
}
```

Once you have the algorithm in place, you will need to determine how you will
decide which value of `b` minimizes the total error between the predicted and 
observed trip distribution. You could solve this manually by trying different
values of beta, or by using a goal seek / optimization program. The choice
is yours, but you should document what you do in your homework response.

### Second Problem: Model Application

The region represented in Problem 1 has begun improvements to the
link between zones 1 and 2 that will reduce the travel cost from 5 to 3. Using
your algorithm and the value of $b$ estimated above, determine the effect of this
improvement on the predicted trip distribution matrix.  
Is the response reasonable?

