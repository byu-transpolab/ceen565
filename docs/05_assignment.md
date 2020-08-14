

# Network Assignment and Validation {#chap-assignment}


## Homework {-#hw-assignment}


![Network](images/05_network.png)

The figure above^[This is an adaptation of a homework assignment from
Dr.\ John Ivan at the University of Connecticut.] represents a simple four-node
network where 7000 vehicles travel from A to D, and 5000 travel from B to D
(there are no additional trips from C to D). Link travel times for the network
are given by the functions below.

$$
\begin{aligned}
t_{AD} =& 20 + 0.01 q_{AD}\\
t_{AC} =& 10 + 0.005 q_{AC}\\
t_{CD} =& 12 + 0.005 q_{CD}\\
t_{BC} =& 7.25 + 0.005 q_{BC}\\
t_{BD} =& 20 + 0.01 q_{BD}
\end{aligned}
$$

Question 1: Solve for the user equilibrium (UE) link flows and travel times (HINT:
write and solve a set of simultaneous equations that explicitly define the UE
conditions).  Demonstrate that your solution is the user equilibrium by showing
through example that all UE conditions are satisfied.

Question 2: Perform four iterations of All Or Nothing (AON) assignment on the network
and O/D volumes.  Show the link flows and travel times at the end of each
iteration.

Question 3: Perform an incremental assignment, using trip table increments of 25\% for
each step.  Show the link flows and travel times at the end of each incremental
assignment.

Question 5: Assign trips using the FHWA assignment heuristic.  Show the link flows and
travel times for four assignments, and the final average assignment and
resulting travel times. 

Question 6: Compare these four traffic assignment heuristic approaches to the UE
assignment and to each other.  How do the resulting flow patterns differ (cite
specific differences)?  Which one comes closest to the UE flows? 

Question 7: State in words the general theory underlying each of the heuristic
approaches.  Which one do you prefer and why?  Consider accuracy, ease of
computation and the underlying theory.

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
