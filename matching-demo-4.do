
capture clear
capture log close
set cformat %4.2f
set pformat %4.2f
set sformat %4.2f
set more off

log using matching-demo-4.log, replace


*******************************************************************************
*** load the simulated data set utilized for Table 5.6
*******************************************************************************

use mw_cath9.dta

*** Datasets available here:  http://www.cambridge.org/download_file/857876

*** alternative data set 
*use mw_cath1.dta

*******************************************************************************
*** summary statistics for simulated data
*******************************************************************************

summ

/*
dotplot u v ytminus1 d y

kdensity y, nograph generate(x fx)
kdensity y if d==0, nograph generate(fx0) at(x)
kdensity y if d==1, nograph generate(fx1) at(x)
label var fx0 "Control"
label var fx1 "Treatment"
line fx0 fx1 x, sort ytitle(Density)
*/



table treat, c(mean y mean ses mean twoparent) format(%5.2f)
table treat, c(mean test mean d) format(%5.2f) center

*******************************************************************************
*** set up macros for specifications
*******************************************************************************

global outcome "y"
global treatment "treat"

global shortreg "asian-ses"
global correctreg "asian-ses test"

global short " asian-ses sessq"
global correct "asian-southhisp"

global bdcolliderdescendant " "
global bdcolliders " "

global long " "
global all " "

global mediator " "


*******************************************************************************
*** regresssion estimators
*******************************************************************************

regress $outcome $treatment
regress $outcome $treatment $shortreg
regress $outcome $treatment $correctreg
regress $outcome $treatment $short
regress $outcome $treatment $correct

*******************************************************************************
*** call estimators from other matching routines
*******************************************************************************

do teffects_estimators_02.do
do psmatch2_estimators_02.do
