\encoding{UTF-8}


\name{CreateParamSet_LHS}
\alias{CreateParamSet_LHS}


\title{Generation of a Latin Hypercube parameter sample}


\description{
Generates a set of parameter values sampled with the Latin Hypercube technique within a user-defined
range (\code{ParamMin}, \code{ParamMax}) for each parameter. \cr
Latin Hypercube Sampling (LHS) is a stratified sampling technique: for each parameter, the
[\code{ParamMin}, \code{ParamMax}] range is divided into \code{NSamples} equal-probability intervals
(strata), and each stratum is sampled exactly once. The strata are independently shuffled across
parameters, which spreads the samples more evenly over the multidimensional parameter space than a
simple uniform random draw would.
}


\usage{
CreateParamSet_LHS(ParamMin, ParamMax, NSamples, Seed = NULL)
}


\arguments{
\item{ParamMin}{[numeric] vector giving the lower bound of each parameter}

\item{ParamMax}{[numeric] vector giving the upper bound of each parameter (same length as \code{ParamMin})}

\item{NSamples}{[numeric] number of parameter sets to sample}

\item{Seed}{(optional) [numeric] seed used to make the random sampling reproducible (passed to \code{\link{set.seed}}); default = \code{NULL} (no seed is set)}
}


\value{
[matrix] matrix of sampled parameter sets, with \code{NSamples} rows and as many columns as parameters;
column names are taken from \code{names(ParamMin)} when available
}


\examples{
library(airGRalpine)

ParamMin <- c(X1 =    1, X2 = -5, X3 =   1, X4 = 0.5)
ParamMax <- c(X1 = 1500, X2 =  5, X3 = 500, X4 = 10)

ParamSet <- CreateParamSet_LHS(ParamMin = ParamMin, ParamMax = ParamMax,
                               NSamples = 200, Seed = 1234)
str(ParamSet)
}


\author{
Adrian Kreiner
}


\seealso{
\code{\link{Calibration_MonteCarlo}}.
}
