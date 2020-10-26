

# Network Assignment and Validation {#chap-assignment}

The purpose of network assignment is to estimate the traffic flows that will 
occur on each highway link, given the highway network and the trips flowing 
from all origins to all destinations (determined by the other three 
steps of the four-step model).

On average, we start from the assumption that people will take the shortest path
available to them. The travel time on a particular road is a function of the
road's capacity as well as its volume. Because the volume is not known when we
start a traffic assignment process, we will have to find the solution iteratively.

## Volume - Delay Functions

A volume-delay function (VDF) calculates the increase of travel time on a
roadway based on the ratio of volume $V$ to capacity $C$. A popular equation in
travel modeling is a function developed by the Buruea of Public Roads (the
predecessor to the US Department of Transportation). The BPR VDF is

\begin{equation}
  t = t_0[1 + \alpha * (V/C)^\beta] 
  (\#eq:bpr-vdf)
\end{equation}

Where $t$ is the travel time on the link, $t_0$ is the base travel time, 
and $\alpha, \beta$ are calibrated parameters. Figure \@ref(fig:bpr-coeffs) 
shows average values for BPR functions obtained from a sample of MPO travel models
of different sizes. As roads become more heavily loaded, the travel time increases
and other routes become more attractive.

<div class="figure">
<img src="05_assignment_files/figure-epub3/bpr-coeffs-1.png" alt="Average BPR VDF curves in a sample of MPO models."  />
<p class="caption">(\#fig:bpr-coeffs)Average BPR VDF curves in a sample of MPO models.</p>
</div>


## Assignment Algorithms

Consider that we have the network below, with two routes between nodes $A$ and
$B$. The bypass is longer initially, but its travel time will grow less quickly
with added volume.

<img src="05_assignment_files/figure-epub3/unnamed-chunk-1-1.png" width="90%" style="display: block; margin: auto;" />

The most basic way to assign trips is with an "all-or-nothing" (AON) assignment.
This simply puts all the trips between $i$ and $j$ on the shortest route. This
is obviously not great in a lot of ways, because it will overload some
roads while leaving other roads completely empty. So if we assign 1000 trips to
this network, the volumes and travel times become

<img src="05_assignment_files/figure-epub3/unnamed-chunk-2-1.png" width="90%" style="display: block; margin: auto;" />

We could repeat this process many times, assigning new AON loads to the updated
travel times. This won't converge to anything, but we could take the average of
all the different AON loadings and run with that. It's not perfect, but it's
easy.

In general, the operating theory of network assignment is called 
*static user equilibrium*,

> A network is in static user equilibrium if a person cannot find a shorter path 
between their origin and destination. That is, all paths that are used have the
same travel cost, and all longer paths are unused.

In a small and simple network, we could just generate a system of equations that
represent the SUE conditions, and solve for the values that will give us that
loading. In our example, we can write the system of equations as

\begin{align*}
    &   t_b &- 0.005 V_b  &           &= 15 \\
t_t &       &             &- 0.02 V_t &= 10 \\
t_t & - t_b &             &           &= 0\\
    &       &       V_b   & + V_t     &= 1000\\
\end{align*}

We can solve this using our matrix calculation skills from linear algebra. The
SUE assignment is reached when 600 vehicles take the bypass and 400 vehicles take
the through road, because when that happens both the routes have an equal
travel time of 18 minutes.


```r
(A <- matrix(c(0, 1, -0.005, 0, 
              1, 0, 0, -0.02, 
              1, -1, 0, 0,
              0, 0, 1, 1), byrow = TRUE, ncol = 4))
```

```
##      [,1] [,2]   [,3]  [,4]
## [1,]    0    1 -0.005  0.00
## [2,]    1    0  0.000 -0.02
## [3,]    1   -1  0.000  0.00
## [4,]    0    0  1.000  1.00
```

```r
b <- c(15, 10, 0, 1000)
# Ax = b -> x = A^-1 b
solve(A) %*% b
```

```
##      [,1]
## [1,]   18
## [2,]   18
## [3,]  600
## [4,]  400
```

In larger networks, this is really not possible. So we are going to learn two
methods that are designed to simulate the true SUE solution by working
iteratively.

### FHWA Incremental Assignment

A big problem with the AON assignment is the large jump in travel times between
iterations. The FHWA algorithm is designed to weight the travel time from 
previous iterations more heavily than the current iteration.

  1. Determine the number of increments, $N$.
  1. Assign $T / N$ trips via AON
  1. Calculate the the travel times for links on the network as 
  $t_{i + 1} = t_{i}/N + t_{i - 1}*(N-1)/N$
  1. Return to step 2
  

### Frank-Wolfe 

We can represent SUE traffic assignment as a nonlinear optimization problem. Let

  - $v_a =$ vehicles assigned to link $a$.
  - $S_a(v_a) =$ the travel cost on link $a$ as a function of its volume (VDF function)
  - $X_{ij}^r =$ the total number of vehicles traveling from $i$ to $j$ on
  the sum of links that represent route $r$.
  
We want to minimize the total travel cost

\begin{equation}
  \sum_a \int_0^{v_a} S_a(x) dx
  (\#eq:fw-objective)
\end{equation}

subject to the constraints

\begin{align*}
  v_a &= \sum_i \sum_j \sum_r \delta_{ij}^{ar}X_{ij}{r}\\
  \sum_r X_{ij}^r &= T_{ij}\\
  X_{ij}^r &\geq 0 
\end{align*}  
 
In text, the constraints are as follow: the volume on a link is a
sum of the volume on all routes that use that link ($\delta$ is indicator), the 
total of all routes has to equal the total number of trips assigned, and the
paths on a route are not allowed to be negative.

Various algorithms can be used to find the values of $v_a$ that minimize this
objective function subject to these constraints. A popular algorithm is the 
Frank-Wolfe algorithm, though other algorithms have been developed that converge 
more quickly under different scenarios.

With these algorithms, it is essential to allow the algorithm to converge
appropriately. A measure of the convergence is a statistic called the "relative
gap", or the difference between the assignment at that iteration and an AON
assignment made with the calculated travel times. As this gap becomes smaller,
it means that the difference between travel times on the routes are becoming
closer to each other. The figure below shows the value of the relative gap 
after several thousand iterations in the Washington, D.C. travel model.

<div class="figure">
<img src="images/05_convergence.png" alt="Relative gap after several thousand iterations." width="964" />
<p class="caption">(\#fig:relative-gap)Relative gap after several thousand iterations.</p>
</div>

Large networks may take many hours to reach convergence that is acceptable for
policy analysis. There is a large incentive to "cut corners" by shrinking the
maximum number of iterations that are run, but this can lead to strange behavior.

## Homework {-#hw-assignment}


![Network](images/05_network.png)

The figure above^[This is an adaptation of a homework assignment from
Dr.\ John Ivan at the University of Connecticut.] represents a simple four-node
network where 7000 vehicles travel from A to D, and 5000 travel from B to D
(there are no additional trips from C to D). Link travel times for the network
are given by the functions below.

\begin{align*}
t_{AD} =& 20 + 0.01 q_{AD}\\
t_{AC} =& 10 + 0.005 q_{AC}\\
t_{CD} =& 12 + 0.005 q_{CD}\\
t_{BC} =& 7.25 + 0.005 q_{BC}\\
t_{BD} =& 20 + 0.01 q_{BD}
\end{align*}

Question 1: Solve for the static user equilibrium (SUE) link flows and travel times by
solving a set of simultaneous equations that explicitly define the SUE
conditions.  Demonstrate that your solution is the user equilibrium by showing
through example that all UE conditions are satisfied.

Question 2: Perform four iterations of All Or Nothing (AON) assignment on the network
and O/D volumes.  Show the link flows and travel times at the end of each
iteration and compute the average link loads and travel times.

Question 3: Assign trips using the FHWA assignment heuristic.  Show the link
flows and travel times for four incremental assignments, and the final average
assignment and resulting travel times.

Question 4: Compare these four traffic assignment heuristic approaches to the UE
assignment and to each other.  How do the resulting flow patterns differ (cite
specific differences)?  Which one comes closest to the UE flows? 

Question 5: You are considering a road widening project in a suburb of a large
metropolitan area (indicated with the blue circle). The difference in loaded
volumes between your base scenario (no-build) and the widening is given in the figure
below. What is a likely explanation for the patterns shown in the figure?

<div class="figure">
<img src="images/05_convergence.png" alt="Difference in assigned volumes when adding a lane in area with blue circle." width="964" />
<p class="caption">(\#fig:unnamed-chunk-3)Difference in assigned volumes when adding a lane in area with blue circle.</p>
</div>


## Laboratory Assignment

The highway volume-to-capacity curves in the Roanoke Model have already been
largely calibrated^[To be specific, VDOT has values that they assert for all of
their models]. They use the Bureau of Public Roads (BPR) format,

$$T_c = T_0 * (1 + \alpha (V / C)^\beta)$$
Create a plot showing the values of these curves for varying VOC ratios and 
discuss the implications of the different curves on different facility types in
your report. Note that there are 5 facility types in the BPR table but 11
facility types in the model network. The assignment script files have comments
that build a crosswalk between the two facility type definitions.

For this lab, you will create a model validation report where you 
examine the following:

  - Root mean squared error (RMSE) by facility type, area type, volume group,
  and by screenline. Are there certain classes that are outperforming others? 
  - Observed vs Modeled link volume scatterplots: an X-Y fit
  line by facility type as well as a maximum desirable deviation plot defined in
  NCHRP 765.
  - Geographic distribution of link error. 
  
Comment on the Roanoke model's calibration.
