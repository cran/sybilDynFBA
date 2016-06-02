\name{optsol_dynamicFBA-class}
\Rdversion{1.1}
\docType{class}
\alias{optsol_dynamicFBA-class}
\alias{optsol_dynamicFBA}

\alias{plot,optsol_dynamicFBA,missing-method}

\title{Class \code{"optsol_dynamicFBA"}}
\description{
 Structure of the class \code{"optsol_dynamicFBA"}. Objects of that class are
  returned by the function \code{\link{dynamicFBA}}. Extends the Class \code{\linkS4class{optsol_optimizeProb}}.
}
\section{Objects from the Class}{
  Objects can be created by calls of the function \code{optsol_dynamicFBA}:

  \code{test <- optsol_dynamicFBA(solver = "glpk", method = "simplex")}.
}

\section{Slots}{
  \describe{
    \item{\code{solver}:}{Object of class \code{"character"}
          indicating the used solver.
        }
        \item{\code{method}:}{Object of class \code{"character"}
          indicating the used method.
    }
 \item{\code{num_of_prob}:}{Object of class \code{"integer"}
      indicating the number of optimization problems.
    }
    \item{\code{lp_num_cols}:}{Object of class \code{"integer"}
      indicating the number of columns.
    }
    \item{\code{lp_num_rows}:}{Object of class \code{"integer"}
      indicating the number of rows.
    }
    \item{\code{lp_obj}:}{Object of class \code{"numeric"}
         containing the values of the objective function.
       }
       \item{\code{lp_ok}:}{Object of class \code{"integer"}
         containing the exit code of the optimization.
       }
       \item{\code{lp_stat}:}{Object of class \code{"integer"}
         containing the solution status of the optimization.
       }
 
   \item{\code{lp_dir}:}{Object of class \code{"character"}
         indicating the direction of optimization.
       }

    \item{concentrationMatrix}{
  Object of class \code{"matrix"}
        contains concentrations of extracellular metabolite
  }
    \item{excRxnNames}{
  Object of class \code{"matrix"}
        contains names of exchange reactions for the EC metabolites
  }
 \item{\code{fluxdist}:}{Object of class \code{"fluxDistribution"}
      containing the solutons flux distributions.
    }
    \item{timeVec}{
  Object of class \code{"numeric"}
             Vector of time points
  }
    \item{biomassVec}{
	Object of class \code{"numeric"} 
            Vector of biomass values
    }
	
	 \item{all_fluxes}{
		Object of class \code{"matrix"}
        contains fluxes of all reactions at all steps
  }
  }% describe
}%slots
\section{Extends}{
Class \code{"\linkS4class{optsol_optimizeProb}"}, directly.
Class \code{"\linkS4class{optsol}"}, by class "optsol_optimizeProb", distance 2.
}
\section{Methods}{
  \describe{
    \item{plot}{\code{signature(x = "optsol_dynamicFBA", y = "missing")}: 
    \describe{
  \item{x}{   An object of class \code{\link{optsol_dynamicFBA}}.}
  \item{y}{
 not used but kept for compitability with generic plot.
 }
  \item{plotRxns}{
List of reaction id's to be ploted
}
  \item{\dots}{ 
 Further arguments passed to \code{\linkS4class{sysBiolAlg}}.  Argument
    \code{solverParm} is a good candidate.
}
}
}
	 }
}
\author{
Abdelmoneim Amer Desouki
}


%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
 \code{\link{checkOptSol}},
  \code{\linkS4class{optsol}},
  \code{\linkS4class{optsol_optimizeProb}}
}
\examples{
showClass("optsol_dynamicFBA")
}
\keyword{classes}
