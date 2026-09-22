\encoding{UTF-8}


\name{Calibration_MonteCarlo}
\alias{Calibration_MonteCarlo}


\title{Monte Carlo calibration algorithm based on a Latin Hypercube parameter sample}


\description{
Calibration algorithm that optimises the error criterion selected as objective function using a
Monte Carlo approach. \cr
\cr
A sample of \code{NSamples} parameter sets is drawn using a Latin Hypercube design (see
\code{\link{CreateParamSet_LHS}}) within the \code{ParamMin}/\code{ParamMax} range given by the
user for each parameter. The model is run and the objective function computed for every sampled
parameter set, and the parameter set giving the best value of the criterion is returned.
}


\usage{
Calibration_MonteCarlo(InputsModel, RunOptions, InputsCrit, FUN_MOD,
                       ParamMin, ParamMax, NSamples = 1000, Seed = NULL,
                       verbose = TRUE, ...)
}


\arguments{
\item{InputsModel}{[object of class \emph{InputsModel}] see \code{\link{CreateInputsModel}} for details}

\item{RunOptions}{[object of class \emph{RunOptions}] see \code{\link{CreateRunOptions}} for details}

\item{InputsCrit}{[object of class \emph{InputsCrit}] see \code{\link{CreateInputsCrit}} for details}

\item{FUN_MOD}{[function] hydrological model function (e.g. \code{\link{RunModel_GR4J}}, \code{\link{RunModel_CemaNeigeGR4J}})}

\item{ParamMin}{[numeric] vector giving the lower bound of each parameter, in the same order and of the same length as the parameters expected by \code{FUN_MOD}}

\item{ParamMax}{[numeric] vector giving the upper bound of each parameter (same length as \code{ParamMin})}

\item{NSamples}{(optional) [numeric] number of parameter sets sampled by the Latin Hypercube design, default = \code{1000}}

\item{Seed}{(optional) [numeric] seed used to make the Latin Hypercube sample reproducible (passed to \code{\link{set.seed}}); default = \code{NULL} (no seed is set)}

\item{verbose}{(optional) [boolean] boolean indicating if the function is run in verbose mode or not, default = \code{TRUE}}

\item{...}{(optional) arguments to pass to \code{\link{RunModel}}}
}


\value{
[list] list containing the function outputs organised as follows:
  \tabular{ll}{
    \emph{$ParamFinalR  } \tab [numeric] parameter set giving the best criterion value among the Monte Carlo sample \cr
    \emph{$CritFinal    } \tab [numeric] error criterion selected as objective function obtained for \emph{$ParamFinalR} \cr
    \emph{$NRuns        } \tab [numeric] number of model runs done during the calibration (i.e. \code{NSamples}) \cr
    \emph{$HistParamR   } \tab [numeric] matrix of the \code{NSamples} sampled parameter sets \cr
    \emph{$HistCrit     } \tab [numeric] vector of the criterion value obtained for each sampled parameter set \cr
    \emph{$ParamMin     } \tab [numeric] lower bound used for each parameter \cr
    \emph{$ParamMax     } \tab [numeric] upper bound used for each parameter \cr
    \emph{$CritName     } \tab [character] name of the calibration criterion used as objective function \cr
    \emph{$CritBestValue} \tab [numeric] theoretical best criterion value \cr
  }
}


\details{
Unlike \code{\link{Calibration_Michel}}, which searches the parameter space using a screening step
followed by a steepest descent local search, \code{Calibration_MonteCarlo} only evaluates the
\code{NSamples} parameter sets proposed by the Latin Hypercube design: no local refinement is
performed. \cr
This makes the method well suited to a first, global exploration of the response surface, or to
uncertainty/sensitivity analyses (e.g. GLUE-like approaches) based on the full \emph{$HistParamR} /
\emph{$HistCrit} sample, in addition to being usable as a stand-alone calibration method. \cr
The quality of the result depends on \code{NSamples}: the larger the number of samples, the better
the parameter space is covered, at the cost of additional model runs.
}


\examples{
library(airGR)

## loading catchment data
data(L0123001)

## preparation of InputsModel object
InputsModel <- CreateInputsModel(FUN_MOD = RunModel_GR4J, DatesR = BasinObs$DatesR,
                                 Precip = BasinObs$P, PotEvap = BasinObs$E)

## calibration period selection
Ind_Run <- seq(which(format(BasinObs$DatesR, format = "\%Y-\%m-\%d")=="1990-01-01"),
               which(format(BasinObs$DatesR, format = "\%Y-\%m-\%d")=="1999-12-31"))

## preparation of RunOptions object
RunOptions <- CreateRunOptions(FUN_MOD = RunModel_GR4J, InputsModel = InputsModel,
                               IndPeriod_Run = Ind_Run)

## calibration criterion: preparation of the InputsCrit object
InputsCrit <- CreateInputsCrit(FUN_CRIT = ErrorCrit_NSE, InputsModel = InputsModel,
                               RunOptions = RunOptions, Obs = BasinObs$Qmm[Ind_Run])

## user-defined parameter ranges (real parameter space) for the GR4J model
ParamMin <- c(X1 =    1, X2 = -5, X3 =   1, X4 = 0.5)
ParamMax <- c(X1 = 1500, X2 =  5, X3 = 500, X4 = 10)

## Monte Carlo calibration
OutputsCalib <- Calibration_MonteCarlo(InputsModel = InputsModel, RunOptions = RunOptions,
                                       InputsCrit = InputsCrit, FUN_MOD = RunModel_GR4J,
                                       ParamMin = ParamMin, ParamMax = ParamMax,
                                       NSamples = 200, Seed = 1234)

## simulation
Param <- OutputsCalib$ParamFinalR
OutputsModel <- RunModel_GR4J(InputsModel = InputsModel,
                              RunOptions = RunOptions, Param = Param)

## results preview
plot(OutputsModel, Qobs = BasinObs$Qmm[Ind_Run])
}


\author{
Adrian Kreiner
}


\seealso{
\code{\link{Calibration}}, \code{\link{Calibration_Michel}}, \code{\link{CreateParamSet_LHS}},
\code{\link{RunModel_GR4J}}, \code{\link{ErrorCrit_RMSE}},
\code{\link{CreateInputsModel}}, \code{\link{CreateRunOptions}}, \code{\link{CreateInputsCrit}}.
}
