********************************************************************************
// Author:  Stephen L. Morgan
// Date:    August 21, 2020
// Note:    Simulations for Section 2.7.4, focused on partial identification
********************************************************************************
		 
capture clear 
capture program drop _all
capture log close
cls

set cformat %4.2f
set pformat %4.2f
set sformat %4.2f
set more off

log using morgan-2-7-4-sim-01.log, replace

********************************************************************************
********************************************************************************
*** Randomization vs. choice (with three choice processes)
********************************************************************************
********************************************************************************

*** N for simulation (where we start with a large pseudo population)

set obs 1000000 

*** Set seed for reproducibility (Steve's birthday. Don't forget it!)

set seed 73071

********************************************************************************
*** Generate potential outcomes (fixed for individuals, regardless of type of
***   treatment assignment/selection)  
********************************************************************************

gen y0 = rnormal(100, 10)
gen ite = rnormal(10, 1)
gen y1 = y0 + ite

summ 
corr

********************************************************************************
*** Generate observed data for random assignment to treatment
********************************************************************************

gen treat_rand = runiform(0, 1) > .5 /* or: gen treat_rand = rbinomial(1, .5) */
gen y_rand =  treat_rand * y1 + (1 - treat_rand) * y0

********************************************************************************
*** Generate observed data for non-random selection into treatment
********************************************************************************

*** Generate common random noise variable for choices (fixed for individuals)

gen u = rnormal(0, 1)

*** Treatment selection: Positive selection on y0

gen treat_ch_y0 = [y0 + u > 100]
gen y_ch_y0 =  treat_ch_y0 * y1 + (1 - treat_ch_y0) * y0

*** Treatment selection: Positve selection on y1

gen treat_ch_y1 = [y1 + u > 110]
gen y_ch_y1 =  treat_ch_y1 * y1 + (1 - treat_ch_y1) * y0

*** Treatment selection: Positve selection on y1-y0

gen treat_ch_ite = [ite + u > 10]
gen y_ch_ite =  treat_ch_ite * y1 + (1 - treat_ch_ite) * y0

********************************************************************************
*** Simulation results
********************************************************************************

*** Summarize the constructed data and treatment effects at the population level 

summ

mean y0 y1 ite y_rand, over(treat_rand)
regress y_rand treat_rand

mean y0 y1 ite y_ch_y0, over(treat_ch_y0)
regress y_ch_y0 treat_ch_y0

mean y0  y1 ite y_ch_y1, over(treat_ch_y1)
regress y_ch_y1 treat_ch_y1

mean y0 y1 ite y_ch_y1, over(treat_ch_ite)
regress y_ch_ite treat_ch_ite

*** Sample and estimate

sample 2500, count
summ

mean y0 y1 ite y_rand, over(treat_rand)
regress y_rand treat_rand

mean y0 y1 ite y_ch_y0, over(treat_ch_y0)
regress y_ch_y0 treat_ch_y0

mean y0  y1 ite y_ch_y1, over(treat_ch_y1)
regress y_ch_y1 treat_ch_y1

mean y0 y1 ite y_ch_y1, over(treat_ch_ite)
regress y_ch_ite treat_ch_ite

log close
