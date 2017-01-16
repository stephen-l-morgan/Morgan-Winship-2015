*******************************************************************************
*** matching etimators (psmatch2 routines)
*******************************************************************************

/* kernel matching (deafult kernel=epanechnikov) */

psmatch2 $treatment $correct, logit kernel out($outcome)
pstest $correct _pscore
psmatch2 $treatment $bdcolliders, logit kernel out($outcome)
pstest $bdcolliders _pscore
psmatch2 $treatment $long, logit kernel out($outcome)
pstest $bdcolliders _pscore


/* kernel matching (kernel=gaussian) */

psmatch2 $treatment $correct, logit kernel k(normal) out($outcome)
pstest $correct _pscore
psmatch2 $treatment $bdcolliders, logit kernel k(normal) out($outcome)
pstest $bdcolliders _pscore
psmatch2 $treatment $long, logit kernel k(normal) out($outcome)
pstest $long _pscore

/* estimate logit for pscore to determine caliper size */

*** logit for pscore
logit $treatment $correct
predict estpscore
sum estpscore
scalar sdpsc=r(sd)
display sdpsc
scalar setcal=.05*sdpsc
display setcal


/* nearest neighbor one-to-one matching -- no caliper, no replace */

capture drop _*
psmatch2 $treatment $correct, logit neighbor(1) noreplacement ///
 out($outcome) ate
pstest $correct _pscore
summ _pdif, detail

/*

codebook _n1 if d==1
tab _nn if d==1
sum _* if d==1
codebook _n1 if d==0
tab _nn if d==0
sum _* if d==0
*/

/* nearest neighbor one-to-one matching -- no caliper, with replace */

drop _*
psmatch2 $treatment $correct, logit neighbor(1) out($outcome) ate
pstest $correct _pscore
summ _pdif, detail

/*
codebook _n1 if d==1
tab _nn if d==1
sum _* if d==1
codebook _n1 if d==0
tab _nn if d==0
sum _* if d==0
*/

/* nearest neighbor one-to-one matching -- with caliper, no replace */

quietly sum estpscore
psmatch2 $treatment $correct, logit neighbor(1) noreplacement ///
 cal(`=.05*r(sd)') out($outcome) ate
pstest $correct _pscore
summ _pdif, detail

/* codebook _n1 if d==1
tab _nn if d==1
sum _* if d==1
codebook _n1 if d==0
tab _nn if d==0
sum _* if d==0
*/

/* nearest neighbor one-to-one matching -- with caliper, with replace */

quietly sum estpscore
psmatch2 $treatment $correct, logit neighbor(1) cal(`=.05*r(sd)') ///
 out($outcome) ate
pstest $correct _pscore
summ _pdif, detail

/*
codebook _n1 if d==1
tab _nn if d==1
sum _* if d==1
codebook _n1 if d==0
tab _nn if d==0
sum _* if d==0
*/

/* nearest neighbor five-to-one matching -- no caliper, with replace */

psmatch2 $treatment $correct, logit neighbor(5) out($outcome) ate
pstest $correct _pscore
summ _pdif, detail

/*
codebook _n1 if d==1
codebook _n2 if d==1
codebook _n3 if d==1
codebook _n4 if d==1
codebook _n5 if d==1
distinct (_n1-_n5) if d==1, joint
tab _nn if d==1
sum _* if d==1
codebook _n1 if d==0
codebook _n2 if d==0
codebook _n3 if d==0
codebook _n4 if d==0
codebook _n5 if d==0
distinct (_n1-_n5) if d==0, joint
tab _nn if d==0
sum _* if d==0
*/

/* nearest neighbor 5-to-one matching -- with caliper, with replace */

quietly sum estpscore
psmatch2 $treatment $correct, logit neighbor(5) cal(`=.05*r(sd)') ///
 out($outcome) ate
pstest $correct _pscore
summ _pdif, detail

/*
codebook _n1 if d==1
codebook _n2 if d==1
codebook _n3 if d==1
codebook _n4 if d==1
codebook _n5 if d==1
distinct (_n1-_n5) if d==1, joint
tab _nn if d==1
sum _* if d==1
codebook _n1 if d==0
codebook _n2 if d==0
codebook _n3 if d==0
codebook _n4 if d==0
codebook _n5 if d==0
distinct (_n1-_n5) if d==0, joint
tab _nn if d==0
sum _* if d==0
*/

/* radius matching with caliper */
 
sum estpscore
psmatch2 $treatment $correct, logit radius cal(`=.05*r(sd)') ///
 out($outcome) ate
pstest $correct _pscore

drop estpscore
