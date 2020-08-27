# Trip Distribution {#chap-distribution}


## Homework {-#hw-distribution}
<div align = "center">
![Simple Distribution Graph](images/03_networkgraph.png){width=400px}
<div align = "left">
The figure above ^[This problem is adapted with permission from 
*Urban Transportation Planning: Second Edition* by Michael D. Meyer and 
Eric J. Miller.] presents a simple three zone
system, the link travel times for this system (for internal trips, $t_{ii}=2$
globally), and the zonal productions and attractions. Assume a gravity model of
the form.

$$T_{ij}=\frac{P_iA_j^*(t_{ij})^{-b}}{\sum_{j'}A^*_{j'}(t_{ij})^{-b}}$$

where $A_j^*$ is a ``modified attraction term'' defined by the
algorithm shown in the figure below. This algorithm constrains 
the predicted trips to a given zone to equal the true zonal attractions
$A_j$. 

<div align = "center">
![Trip Balancing Algorithm](images/03_algorithm.png){width=250px}
<div align = "left">
Question 1: Write a computer program or build a spreadsheet that computes the
O-D flows for this system using the algorithm (with $\varepsilon=1$). Find the
value of $b$ (to a single decimal place) which provides the "best fit" with the
observed O-D matrix in the table below. Discuss how you determined which $b$
value gave the "best fit."

| $i$ |  1 |  2 |  3 |
|-----|:--:|:--:|:--:|
| 1   | 80 |  5 | 15 |
| 2   | 80 | 40 | 80 |
| 3   | 40 |  5 | 55 |




Question 2: The region represented in Question 1 has begun improvements to the
link between zones 1 and 2 that will reduce the travel time from 5 to 3. Using
your program and the value of $b$ estimated above, determine the effect of this
improvement on the predicted trip distribution matrix. Is the response
reasonable?
