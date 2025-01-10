--- 
title: "Urban Transportation Planning"
author: "Gregory Macfarlane, PhD, PE"
date: "2025-01-10"
site: bookdown::bookdown_site
documentclass: book
bibliography: [book.bib]
biblio-style: apalike
link-citations: yes
description: "These are notes and assignments related to the *Urban Transportation Planning*  class at BYU."
---



# Foreword {-#syllabus}



This book contains course notes and assignments for a senior / graduate class in
transportation planning and elementary travel modeling. A description for this course
is:

> An advanced course in urban transportation planning. Urban transportation as
the outcome of an economic system, details and techniques for four-step travel
model development, applications of travel models within a legal and regulatory
context.

The book is organized into six units:

  1. [Building Blocks](#chap-blocks)
  2. [Trip Generation](#chap-tripgen)
  3. [Trip Distribution](#chap-distribution)
  4. [Mode and Destination Choice](#chap-modechoice)
  5. [Network Assignment and Validation](#chap-assignment)
  6. [The Planning Process](#chap-process)
  
It may seem strange to put the chapter covering the planning process at the end
of the course, after students have learned the details of quantitative travel
modeling. The purpose for this is that I assign a term project where the
students build and calibrate a four-step model as they learn the techniques to do
so, and then complete an alternatives analysis using their models. To create
the time and space to do this project, we cover "softer" and conceptual topics
in the second half of the course.

The demonstration model the students calibrate and study is a model built in the
Cube travel modeling software for the Roanoke, Virginia, metropolitan region.
The model is a relatively advanced four-step, trip-based model with only 250
zones. The limited zone size means that the entire model system runs in
approximately 15 minutes on a laptop computer. I am grateful to Virginia DOT for
allowing my students the use of this model. Directions on how to use the Roanoke
model are given in the [Appendices](#app-demomodel).

A handful of assignments require the students to write numerical programs or
estimate statistical models. Some guidance on using R and RStudio to accomplish
these assignments is also given in the [Appendices](#app-rstudio).

### Acknowledgements {-}
Photographs in the textbook are the work of the author unless otherwise attributed.
The vector art in the textbook uses icons from FontAwesome and the Noun Project
distributed under creative commons licenses. Specific attributions are below:

  - training wheels by Marco Fleseri from the Noun Project
  - Cover image: TRAX by Ashton Bingham on Unsplash
