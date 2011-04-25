\name{dynamicFBA}

\alias{dynamicFBA}

\encoding{utf8}

\title{dynamic flux balance analysis}
\description{
Calculate concentrations of metabolites of exchange reactions at defined time points given the initial concentrations.
To accomplish this task this function calls \code{\link{simpleFBA}} function to get the fluxes  then update the concentrations and the reaction boundaries ..etc.
}

\usage{
dynamicFBA(model, substrateRxns, initConcentrations, initBiomass, timeStep, nSteps, exclUptakeRxns, 
lpdir = SYBIL_SETTINGS("OPT_DIRECTION"), solver = SYBIL_SETTINGS("SOLVER"), method = SYBIL_SETTINGS("METHOD"), 
 fld = FALSE, verboseMode = 2, ...)
}

\arguments{
  \item{model}{   An object of class \code{\link{modelorg}}.}
  \item{substrateRxns}{
 List of exchange reaction names for substrates initially in the media that may change (e.g. not h2o or co2)
}
  \item{initConcentrations}{
The given start concentrations of substrates
}
  \item{initBiomass}{
   The start value of biomass (must be nonzero)
}
  \item{timeStep}{
   Define the points of time to evaluate the problem at.
}
  \item{nSteps}{
 The maximum number of steps, the procedure may stop before completing this number when the substrate run out.
}
  \item{exclUptakeRxns}{
 List of uptake reactions whose substrate concentrations do not change (Default ={'EX_co2(e)','EX_o2(e)','EX_h2o(e)','EX_h(e)'})
}
  \item{lpdir}{
  Character value, direction of optimisation.  Can be set to \code{"min"} or
    \code{"max"}.\cr
    Default: \code{SYBIL_SETTINGS("OPT_DIRECTION")}.
}
  \item{solver}{
Single character value.  The solver to use.  See
    \code{\link{SYBIL_SETTINGS}} for possible values.\cr
    Default: \code{SYBIL_SETTINGS("SOLVER")}.
}
  \item{method}{
 Single character value.  The optimization algorithm to use.  Possible values
    depend on the setting in \code{solver}.  See \code{\link{SYBIL_SETTINGS}} for
    possible values.\cr
    Default: \code{SYBIL_SETTINGS("METHOD")}.
}
 
  \item{fld}{ 
    Boolean.  Save the resulting flux distribution.\cr
    Default: \code{FALSE}
}
  \item{verboseMode}{
    An integer value indicating the amount of output to stdout:
    0: nothing, 1: status messages, 2: like 1 plus a progress indicator,
    3: a table containing the reaction id's and the corresponding
    min max values.\cr
    Default: \code{2}.
}
  \item{\dots}{ 
 Further arguments passed to \code{\link{prepProbObj}}.  Argument
    \code{solverParm} is a good candidate.
}
}

\value{
returns \code{\link{optsol_dynamicFBA}}
}
\references{
Varma, A. and Palsson, B.O. 1994. Stoichiometric flux balance models quantitatively predict
growth and metabolic by-product secretion in wild-type Escherichia coli W3110. Appl
Environ Microbiol 60: 3724-3731.

Quantitative prediction of cellular metabolism with
  constraint-based models: the COBRA Toolbox. \emph{Nat Protoc} \bold{2}, 727--738.
}
\author{Abdelmoneim Amer Desouki}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
 \code{\link{modelorg}}, \code{\link{optsol_dynamicFBA}}, 
\code{\link{simpleFBA}},  \code{\link{prepProbObj}}, 
\code{\link{SYBIL_SETTINGS}} 
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
	Ec_df <- dynamicFBA(Ec_core,substrateRxns={'EX_glc(e)'},initConcentrations=10,initBiomass=.035,timeStep=.25,nSteps=20,verbose=3)

	## plot biomass and reactions
	plot(Ec_df,plotRxns=c('EX_glc(e)','EX_ac(e)'));

## The function is currently defined as
function (model, substrateRxns, initConcentrations, initBiomass, 
    timeStep, nSteps, exclUptakeRxns, solver = SYBIL_SETTINGS("SOLVER"),
              method = SYBIL_SETTINGS("METHOD"),
              lpdir = SYBIL_SETTINGS("OPT_DIRECTION"), fld = FALSE, 
    verboseMode = 2, ...) 
{
    if (!is(model, "modelorg")) {
        stop("needs an object of class modelorg!")
    }
    if (missing(exclUptakeRxns)) {
        exclUptakeRxns = c("EX_co2(e)", "EX_o2(e)", "EX_h2o(e)", 
            "EX_h(e)")
        if (verboseMode > 2) {
            print("Default extra cellular uptake reactions will be used: ")
            print(exclUptakeRxns)
        }
    }
    excReact = findExchReact(model)
    excReactInd = (react_id(model) \%in\% react_id(excReact$exchange))
    exclUptakeRxnsInd = is.element(react_id(model), exclUptakeRxns)
    excReactInd = excReactInd & !exclUptakeRxnsInd
    excRxnNames = react_id(model)[excReactInd]
    substrateRxnsInd = (react_id(model) \%in\% substrateRxns)
    missingSub = substrateRxnsInd & !excReactInd
    if (sum(missingSub) != 0) {
        print(sum(missingSub))
        print(react_id(model)[missingSub])
        print("Invalid substrate uptake reaction!")
    }
    concentrations = rep(0, length(react_id(model)))
    concentrations[substrateRxnsInd] = initConcentrations
    originalBound = -lowbnd(model)
    noInitConcentration = (concentrations == 0) & (lowbnd(model) < 0)
    concentrations[noInitConcentration] = 1000
    biomass = initBiomass
    uptakeBound = concentrations/(biomass * timeStep)
    aboveOriginal = (uptakeBound > originalBound) & (originalBound > 0)
    uptakeBound[aboveOriginal] = originalBound[aboveOriginal]
    lowbnd(model)[excReactInd] = -uptakeBound[excReactInd]
    concentrationMatrix = concentrations[excReactInd]
    biomassVec = biomass
    timeVec = 0
    lpmod <- prepProbObj(model, nCols = react_num(model), nRows = met_num(model), 
        alg = "FBA", solver = solver, method = method, lpdir = lpdir)
    if (verboseMode > 2) 
        print("Step number    Biomass\n")
    if (verboseMode == 2) 
        progr <- .progressBar()
    for (stepNo in 1:nSteps) {
        if (verboseMode == 2) 
            progr <- .progressBar(stepNo, nSteps, progr)
        sol = simpleFBA(lpmod, fld = T)
        mu = sol$obj
        if (sol$stat != 5) {
            print("No feasible solution - nutrients exhausted\n")
            break
        }
        uptakeFlux = sol$fluxes[excReactInd]
        biomass = biomass * exp(mu * timeStep)
        biomassVec = c(biomassVec, biomass)
        concentrations[excReactInd] = concentrations[excReactInd] - 
            uptakeFlux/mu * biomass * (1 - exp(mu * timeStep))
        concentrations[concentrations <= 0] = 0
        concentrationMatrix = c(concentrationMatrix, concentrations[excReactInd])
        uptakeBound[excReactInd] = concentrations[excReactInd]/(biomass * 
            timeStep)
        uptakeBound[uptakeBound > 1000] = 1000
        aboveOriginal = (uptakeBound > originalBound) & (originalBound > 0)
        uptakeBound[aboveOriginal] = originalBound[aboveOriginal]
        uptakeBound = ifelse(abs(uptakeBound) < 1e-09, 0, uptakeBound)
        uppb_tmp <- getColsUppBnds(lpmod, which(excReactInd))
        changeColsBnds(lpmod, which(excReactInd), lb = -uptakeBound[excReactInd], 
            ub = uppb_tmp)
        if (verboseMode > 2) 
            print(paste(stepNo, sep = "    ", biomass))
        timeVec = c(timeVec, stepNo * timeStep)
    }
    return(optsol_dynamicFBA(solver = solver, method = method, 
        nprob = stepNo, lpdir = lpdir, ncols = react_num(model), 
        nrows = met_num(model), objf = printObjFunc(model), fld = fld, 
        concmat = concentrationMatrix, exRxn = excRxnNames, tmVec = timeVec, 
        bmVec = biomassVec))
  }
}% end dontrun
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ optimize }
\keyword{ Dynamic FBA }% __ONLY ONE__ keyword per line
