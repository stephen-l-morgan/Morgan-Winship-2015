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

teffects psmatch ($outcome) ($treatment $short), ///
 nneighbor(1) atet
tebalance summarize

tebalance density ses
graph export graph/tmp1.pdf, replace

tebalance box ses
graph export graph/tmp2.pdf, replace

tebalance density test
graph export graph/tmp3.pdf, replace

tebalance box test
graph export graph/tmp4.pdf, replace

teffects psmatch ($outcome) ($treatment $short), ///
 nn(5) cal(`=.05*r(sd)') atet 
tebalance summarize

teffects psmatch ($outcome) ($treatment $correct), ///
 nneighbor(1) atet
tebalance summarize
tebalance summarize
tebalance density ses
graph export graph/tmp5.pdf, replace

tebalance box ses
graph export graph/tmp6.pdf, replace

tebalance density test
graph export graph/tmp7.pdf, replace

tebalance box test
graph export graph/tmp8.pdf, replace


teffects psmatch ($outcome) ($treatment $correct), ///
 nn(5) cal(`=.05*r(sd)') atet
tebalance summarize



*let's look at some of many variations

teffects nnmatch ($outcome $correct) ($treatment), atet
tebalance summarize

teffects ipw ($outcome) ($treatment $correct), atet
tebalance summarize

teffects ipwra ($outcome $correct) ($treatment $correct), atet
tebalance summarize

