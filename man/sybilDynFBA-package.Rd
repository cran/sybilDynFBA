\name{sybilDynFBA-package}
\alias{sybilDynFBA-package}
\alias{sybilDynFBA}
\docType{package}
\title{
  Dynamic Flux Balance Analysis
}
\description{
The package \code{sybilDynFBA} implements dynamic flux balance anaylsis as proposed by Verma et al (1994). 
It uses functions from package \code{sybil} to find standard FBA solution. Solution can also be ploted.
}
\details{
\tabular{ll}{
Package: \tab sybilDynFBA\cr
Type: \tab Package\cr
Version: \tab 0.0.1\cr
Date: \tab 2011-04-20\cr
License: \tab GPL Version 3\cr
LazyLoad: \tab yes\cr
Depends: \tab \code{\link{sybil}}, methods\cr
}
}
\author{
Abdelmoneim Amer Desouki

Maintainer: Abdelmoneim Amer Desouki <abdelmoneim.amer@uni-duesseldorf.de>
}
\references{
	Varma, A. and Palsson, B.O. 1994. Stoichiometric flux balance models quantitatively predict
	growth and metabolic by-product secretion in wild-type Escherichia coli W3110. Appl
	Environ Microbiol 60: 3724-3731.
}
\keyword{ package }
\seealso{
 \code{\link{sybil}} 
}
\examples{
\dontrun{
	## The examples here require the package glpkAPI to be
	## installed. If that package is not available, you have to set
	## the argument 'solver' (the default is: solver = "glpk").

	## load the example data set
	data(Ec_core)
        lowbnd(Ec_core)[react_id(Ec_core)=='EX_glc(e)']=-10;
        lowbnd(Ec_core)[react_id(Ec_core)=='EX_o2(e)']=-18;
	## run dynamicFBA(), Ec_df will be an object of class \code{\link{optsol_dynamicFBA}}
	Ec_df <- dynamicFBA(Ec_core,substrateRxns={'EX_glc(e)'},initConcentrations=40,initBiomass=.035,timeStep=.25,nSteps=20,verbose=3)

	## plot biomass and reactions
	plot(Ec_df,plotRxns=c('EX_glc(e)','EX_ac(e)'));
}
}
