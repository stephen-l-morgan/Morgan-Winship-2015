
capture clear
capture log close

set cformat %4.2f
set pformat %4.2f
set sformat %4.2f
set more off

log using figure-4-3.log, replace


*******************************************************************************
*** set the number of observations
*******************************************************************************

set obs 1000

*******************************************************************************
*** generate data
*******************************************************************************

gen u = rnormal()
gen v = rnormal()
gen ytminus1 = u + v + rnormal()

gen dindex = -1 + v
gen trueps = exp(dindex)/(1+exp(dindex))
gen d = rbinomial(1, trueps)
* gen d = v + rnormal() *** alternative linear d

gen yc = 20 + u + ytminus1 + rnormal()
gen dshock = rnormal()
gen ite = 1 + dshock
gen yt = yc + ite
gen y = (1-d)*yc + d*yt
* gen y = 10+ u + ytminus1 + d + rnormal() *** alternative with no potential o's

*******************************************************************************
*** summary statistics for simulated data
*******************************************************************************

summ

dotplot u v ytminus1 d y
graph export graph/tmp431.pdf, replace

kdensity y, nograph generate(x fx)
kdensity y if d==0, nograph generate(fx0) at(x)
kdensity y if d==1, nograph generate(fx1) at(x)
label var fx0 "Control"
label var fx1 "Treatment"
line fx0 fx1 x, sort ytitle(Density)
graph export graph/tmp432.pdf, replace

ttest y, by(d)
table d, c(mean y mean ytminus1) format(%9.2f)
table d, c(mean u mean v mean ite) format(%9.2f) center

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

/*
*******************************************************************************
*** call estimators from other matching routines
*******************************************************************************

do teffects_estimators_01.do
do psmatch2_estimators_01.do
*/

log close

