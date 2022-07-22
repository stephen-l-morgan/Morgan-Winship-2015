********************************************************************************
// Author:  Stephen L. Morgan
// Date:    July 22, 2022
// Note:    Simulations for the example in Section 2.7.3 (see Table 2.3)
********************************************************************************
		 
capture clear 
capture program drop _all
capture log close
cls

set cformat %4.2f
set pformat %4.2f
set sformat %4.2f
set more off

log using morgan-2-7-3-sim-01.log, replace

********************************************************************************
********************************************************************************
*** Example for Simulation:  Returns to BA attainment (from section 2.7.3)
********************************************************************************
********************************************************************************

*** N for simulation (where we start with a large pseudo population)

set obs 1000000 

*** Set seed for reproducibility (Steve's birthday. Don't forget it!)

set seed 73071

********************************************************************************
*** Set up potential outcomes and treatment selection pattern to match the
***   example stipulated in Table 2.3 and its accompanying text.  

***   (Note:  This way of setting up the simulation produces the desiered 
***           joint distribution, but it departs from the individual-level 
***           choice narrative in the text.  The second example below will 
***           produce the same pattern of results, and it is based on a setup 
***           that explicitly matches the selection narrative from the text.)
********************************************************************************

*** Generate the specified proportion of the pseudo population as BA attainers

gen ba = rbinomial(1, .3)

*** Generate potential outcomes as if all individuals could be in each of the 
***   four subpopulations in Table 2.3 

gen y1_chooser = rnormal(10, 2)
gen y0_chooser = rnormal(6, 2)
gen y1_non = rnormal(8, 2)
gen y0_non = rnormal(5, 2)

*** Use the BA attainment draw to assign the appropriate potential outcomes
***   to each individual.  (This should 'feel' backwards.  We are defining
***   the potential outcomes, as if we know the treatment that will be
***   chosen.  This is, therefore, a mechanical way of getting the stipulated
***   joint distribution without having to introduce any other variables that
***   encode why some individuals are choosers or not.  It could be that
***   "chooser" and "non" above are "smart" and "less smart."  But the setup
***   is completely general.)

gen y1 =  [ba * y1_chooser] + [(1 - ba) * y1_non] /* 10 or 8, on average */ 
gen y0 =  [ba * y0_chooser] + [(1 - ba) * y0_non] /* 6 or 5, on average */ 
gen ite = y1 - y0

*** Generate the observed outcome 		

gen y = [ba * y1] + [(1- ba) * y0] 

********************************************************************************
*** For comparison, create a BA attainment variable and observed outcome 
***   variable AS IF we randomly reassigned the same individuals (while
***   leaving their potential outcomes the same as above) to BA attainment
***   or not
********************************************************************************
		
gen ba_rand = rbinomial(1, .3)
gen y_rand =  [ba_rand * y1] + [(1 - ba_rand) * y0]

********************************************************************************
*** Simulation results
********************************************************************************

*** Summarize the constructed data and treatment effects at the population level 

summ
mean y0 y1 ite y, over(ba)
regress y ba
mean y0 y1 ite y_rand, over(ba_rand)
regress y_rand ba_rand

*** Sample and estimate

sample 2500, count
summ
mean y0 y1 ite y, over(ba)
regress y ba
mean y0 y1 ite y_rand, over(ba_rand)
regress y_rand ba_rand

********************************************************************************
********************************************************************************
*** Alternative: Show the same basic pattern without using subpopulations,
***   thereby allowing bias to emerge based on individual-level self-selection
********************************************************************************
********************************************************************************

capture clear

*** N for simulation (where we start with a large pseudo population)

set obs 1000000 

*** Set seed for reproducibility (Steve's birthday. Don't forget it!)

set seed 73071

*** Generate data from a self-selection model, where the potential outcome 
***   y1 is y0 with an ite added to it (and where the ite has both a random
***   component and a component correlated with y0).  As a result, selection on 
***   the ite, with noise, is selection both on the level of y0 and the
***   purely individual determinant of the ite.  This generates the two sources
***   of bias outlined in the text.

gen y0 = rnormal(100, 10)
gen ite = [y0 * rnormal(0.05, 0.001)] + rnormal(5, 1)
gen y1 = y0 + ite
gen ba = [ite + rnormal(0, 1) > 10.75] 

summ
corr

gen y = [ba * y1] + [(1 - ba)* y0]

*** outcome and treatment from an ex post randomization of ba completion		

gen ba_rand = rbinomial(1, .5)
gen y_rand =  [ba_rand * y1] + [(1 - ba_rand) * y0]

********************************************************************************
*** Simulation results
********************************************************************************

*** Summarize the constructed data and treatment effects at the population level 

summ
mean y0 y1 ite y, over(ba)
regress y ba
mean y0 y1 ite y_rand, over(ba_rand)
regress y_rand ba_rand

*** Sample and estimate

sample 2500, count
summ
mean y0 y1 ite y, over(ba)
regress y ba
mean y0 y1 ite y_rand, over(ba_rand)
regress y_rand ba_rand

log close
