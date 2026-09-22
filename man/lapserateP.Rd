\docType{data}
\encoding{UTF-8}


\name{lapserateP}
\alias{lapserateP}


\title{Precipitation lapse rate values}


\description{
Example precipitation lapse rate (elevation gradient) coefficients for a small set of station codes, for use as the \code{GradP} argument of \code{\link{DataAltiExtrapolation_Valery}}.
}


\format{Data frame containing two numeric vectors:
  \tabular{ll}{
    Code  \tab station code                                    \cr
    GradP \tab precipitation lapse rate (elevation gradient) [1/m] \cr
  }
}


\seealso{
  \code{\link{DataAltiExtrapolation_Valery}}.
}


\examples{
library(airGR)

## loading the precipitation lapse rate example values
data(lapserateP)
str(lapserateP)
}
