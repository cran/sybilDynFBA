\name{sybilDynFBA-package}
\alias{sybilDynFBA-package}
\alias{sybilDynFBA}
\docType{package}
\title{
  Dynamic Flux Balance Analysis
}
\description{
The package \code{sybilDynFBA} implements dynamic flux balance analysis as proposed by Varma et al (1994). 
It uses functions from package \code{sybil} to find standard FBA solution. Solution can also be plotted.
}
\details{
\tabular{ll}{
Package: \tab sybilDynFBA\cr
Type: \tab Package\cr
Version: \tab 1.0.0\cr
Date: \tab 2015-07-24\cr
License: \tab GPL Version 3\cr
LazyLoad: \tab yes\cr
Depends: \tab \code{\link{sybil}}\cr
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
    mod <- Ec_core

    # Change bounds for glucsoe, oxygen and acetate uptake
    mod <- changeBounds(mod, react = "EX_glc(e)", lb = -12)
    mod <- changeBounds(mod, react = "EX_o2(e)",  lb = -10)
    mod <- changeBounds(mod, react = "EX_ac(e)",  lb = -10)

    # initial values
    init.source <- c("EX_ac(e)","EX_o2(e)","EX_glc(e)")
    init.conc   <- c(10,50,28)
    init.bmass  <- 0.01

    # dFBA
    Ec_df <- dynamicFBA(mod,exclUptakeRxns = c(),
                        substrateRxns      = init.source,
                        initConcentrations = init.conc,
                        initBiomass        = init.bmass,
                        timeStep=.1,nSteps=200,verbose=3)


    # Plotting
    plot(Ec_df,
      plotRxns=c('EX_glc(e)','EX_ac(e)',"EX_for(e)","EX_o2(e)"),
                      legend_cex=0.85,legend_xpos=0,legend_ypos=45)

}
}
