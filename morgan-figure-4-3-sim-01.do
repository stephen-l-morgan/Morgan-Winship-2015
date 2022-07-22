********************************************************************************
// Author:  Stephen L. Morgan
// Date:    July 22, 2022
// Note:    Demonstrate identification claims for Figure 4.3
********************************************************************************

capture clear 
capture program drop _all
capture log close
cls

set cformat %4.2f
set pformat %4.2f
set sformat %4.2f
set more off

log using morgan-figure-4-3-sim-01.log, replace

*******************************************************************************
*** set the number of observations
*******************************************************************************

set obs 1000000

*** Set seed for reproducibility (Steve's birthday. Don't forget it!)

set seed 73071

*******************************************************************************
*** generate data
*******************************************************************************

gen u = rnormal()
gen v = rnormal()
gen ytminus1 = u + v + rnormal()

gen dindex = -1 + v
gen trueps = exp(dindex)/(1+exp(dindex))
gen d = rbinomial(1, trueps)
* gen d = v + rnormal() /* alternative linear d */

gen y0 = 20 + u + ytminus1 + rnormal()
gen dshock = rnormal()
gen ite = 1 + dshock
gen y1 = y0 + ite
gen y = (1-d)*y0 + d*y1
* gen y = 10 + u + ytminus1 + d + rnormal() /* alternative w/o potential o's */

*******************************************************************************
*** summary statistics for simulated data
*******************************************************************************

summ

/*
preserve

sample 10000, count

dotplot u v ytminus1 d y
graph export tmp431.pdf, replace

kdensity y, nograph generate(x fx)
kdensity y if d==0, nograph generate(fx0) at(x)
kdensity y if d==1, nograph generate(fx1) at(x)
label var fx0 "Control"
label var fx1 "Treatment"
line fx0 fx1 x, sort ytitle(Density)
graph export tmp432.pdf, replace

restore
*/

mean y0 ite y1 u v y ytminus1, over(d)
corr y0 ite y1 u v d y ytminus1

*******************************************************************************
*** set up macros for specifications
*******************************************************************************

global outcome "y"
global treatment "d"

global short " "
global correct "v"

global bdcolliderdescendant " "
global bdcolliders "ytminus1"

global long "v ytminus1"
global all "v u ytminus1"

global mediator " "

*******************************************************************************
*** regression estimators
*******************************************************************************

regress $outcome $treatment
regress $outcome $treatment $correct
regress $outcome $treatment $bdcolliders
regress $outcome $treatment $long
regress $outcome $treatment $all

log close

