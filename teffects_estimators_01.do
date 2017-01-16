******************************************************************************
*** matching and iptw estimators (Stata's routines)
*******************************************************************************


/* estimate logit for pscore to determine caliper size */

*** logit for pscore
logit $treatment $correct
predict estpscore
sum estpscore
scalar sdpsc=r(sd)
display sdpsc
scalar setcal=.05*sdpsc
display setcal
drop estpscore

teffects psmatch ($outcome) ($treatment $correct), ///
 nneighbor(1) atet
tebalance summarize

teffects psmatch ($outcome) ($treatment $correct), ///
 nn(5) cal(`=.05*r(sd)') atet
tebalance summarize

teffects psmatch ($outcome) ($treatment $correct), ///
 nneighbor(1) ate
tebalance summarize
teffects psmatch ($outcome) ($treatment $correct), ///
 nn(5) cal(`=.05*r(sd)') ate
tebalance summarize

teffects psmatch ($outcome) ($treatment $bdcolliders),  ///
 nneighbor(1) atet
tebalance summarize
teffects psmatch ($outcome) ($treatment $long),  ///
 nneighbor(1) atet
tebalance summarize


*** let's looks at some graphs

teffects psmatch ($outcome) ($treatment $correct),   ///
 nneighbor(1) atet
tebalance density v
graph export graph/tmp21.pdf, replace

tebalance box v
graph export graph/tmp22.pdf, replace

teffects psmatch ($outcome) ($treatment $bdcolliders), ///
 nneighbor(1) atet
tebalance density ytminus1
graph export graph/tmp23.pdf, replace

tebalance box ytminus1
graph export graph/tmp24.pdf, replace


*let's look at some of many variations

teffects nnmatch ($outcome $correct) ($treatment), ate
tebalance summarize

teffects nnmatch ($outcome $correct) ($treatment), atet
tebalance summarize

teffects ipw ($outcome) ($treatment $correct), atet
tebalance summarize

teffects ipwra ($outcome $correct) ($treatment $correct), atet
tebalance summarize

