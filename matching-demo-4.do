********************************************************************************
// Author:  Stephen L. Morgan
// Date:    July 22, 2022
// Note:    Matching demonstration 4
********************************************************************************

capture clear 
capture program drop _all
capture log close
cls

set cformat %4.2f
set pformat %4.2f
set sformat %4.2f
set more off

log using matching-demo-4.log, replace

*******************************************************************************
*** load the simulated data set utilized for Table 5.6
*******************************************************************************

*** 10 simulated Stata datasets are in the repository.  The 9th dataset is the
***    the one that genereates the results for Table 5.6.  Other datasets 
***    can be used to evaluate the variability repoted in Table 5.7.

	/* 
	
	Datasets can also be downloaded at the publisher website:

		http://www.cambridge.org/download_file/857876 
	
	*/

use mw_cath9.dta

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

mean y yt yc dshock d test ses twoparent, over(treat)

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

	/* 

	To continue, psmatch2 must be installed.  

	This is the package:

		package name:  psmatch2.pkg
				from:  http://fmwww.bc.edu/RePEc/bocode/p/

	The ssc install command below will install (or update or do nothing 
	if up-to-date).

	*/

ssc install psmatch2

do psmatch2_estimators_02.do

log close
