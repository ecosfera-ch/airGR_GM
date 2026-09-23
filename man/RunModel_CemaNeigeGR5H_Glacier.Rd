\encoding{UTF-8}


\name{RunModel_CemaNeigeGR5H_Glacier}
\alias{RunModel_CemaNeigeGR5H_Glacier}


\title{Run with the RunModel_CemaNeigeGR5H_Glacier hydrological model}


\description{
This function runs the RunModel_CemaNeigeGR5H_Glacier hourly lumped model over the test period. The model combines the GR5H rainfall-runoff model (with its optional interception store) and the CemaNeige snow model, with an additional glacier module using the temperature melt index (TMI) model described below. The glacier module is spatially discretized in the same way as the CemaNeige layers.}


\usage{
RunModel_CemaNeigeGR5H_Glacier(InputsModel, RunOptions, Param)
}


\arguments{
\item{InputsModel}{[object of class \emph{InputsModel}] see \code{\link{CreateInputsModel}} for details}

\item{RunOptions}{[object of class \emph{RunOptions}] see \code{\link{CreateRunOptions}} for details}

\item{Param}{[numeric] vector of 10 parameters
  \tabular{ll}{
    GR5H X1        \tab production store capacity [mm]                                          \cr
    GR5H X2        \tab intercatchment exchange coefficient [mm/h]                              \cr
    GR5H X3        \tab routing store capacity [mm]                                             \cr
    GR5H X4        \tab unit hydrograph time constant [h]                                       \cr
    GR5H X5        \tab intercatchment exchange threshold [-]                                   \cr
    CemaNeige X1   \tab weighting coefficient for snow pack thermal state [-]                   \cr
    CemaNeige X2   \tab degree-hour melt coefficient [mm/°C/h]                                  \cr
    Glacier Fi     \tab ice melting factor [mm/°C/h]                                            \cr
    Glacier Tm     \tab ice melting threshold temperature [°C]                                  \cr
    Glacier SWEth  \tab threshold amount of SWE on the glacier before ice melt occurs [mm]      \cr
  }}
}


\value{
[list] containing the function outputs organised as follows:
  \tabular{ll}{
    \emph{$DatesR  } \tab [POSIXlt] series of dates                                                                             \cr
    \emph{$PotEvap } \tab [numeric] series of input potential evapotranspiration (E) [mm/h]                                     \cr
    \emph{$Precip  } \tab [numeric] series of input total precipitation (P) [mm/h]                                              \cr
    \emph{$Interc  } \tab [numeric] series of interception store level (I) [mm]                                                 \cr
    \emph{$Prod    } \tab [numeric] series of production store level (S) [mm]                                                   \cr
    \emph{$Pn      } \tab [numeric] series of net rainfall (Pn) [mm/h]                                                          \cr
    \emph{$Ps      } \tab [numeric] series of the part of Pn filling the production store (Ps) [mm/h]                           \cr
    \emph{$AE      } \tab [numeric] series of actual evapotranspiration (Ei+Es) [mm/h]                                          \cr
    \emph{$EI      } \tab [numeric] series of evapotranspiration from rainfall neutralisation or interception store (Ei) [mm/h] \cr
    \emph{$ES      } \tab [numeric] series of evapotranspiration from production store (Es) [mm/h]                              \cr
    \emph{$Perc    } \tab [numeric] series of percolation (Perc) [mm/h]                                                         \cr
    \emph{$PR      } \tab [numeric] series of Pr=Pn-Ps+Perc (Pr) [mm/h]                                                         \cr
    \emph{$Q9      } \tab [numeric] series of UH outflow going into branch 9 (Q9) [mm/h]                                        \cr
    \emph{$Q1      } \tab [numeric] series of UH outflow going into branch 1 (Q1) [mm/h]                                        \cr
    \emph{$Rout    } \tab [numeric] series of routing store level (R1) [mm]                                                     \cr
    \emph{$Exch    } \tab [numeric] series of potential semi-exchange between catchments [mm/h]                                 \cr
    \emph{$AExch1  } \tab [numeric] series of actual exchange between catchments for branch 1 [mm/h]                            \cr
    \emph{$AExch2  } \tab [numeric] series of actual exchange between catchments for branch 2 [mm/h]                            \cr
    \emph{$AExch   } \tab [numeric] series of actual exchange between catchments (AExch1+AExch2) [mm/h]                         \cr
    \emph{$QR      } \tab [numeric] series of routing store outflow (Qr) [mm/h]                                                 \cr
    \emph{$QD      } \tab [numeric] series of direct flow from UH after exchange (Qd) [mm/h]                                    \cr
    \emph{$Qsim    } \tab [numeric] series of simulated discharge (Q) [mm/h]                                                    \cr
    \emph{$CemaNeigeLayers} \tab [list] CemaNeige outputs (1 element per layer)                                                 \cr
    \emph{$CemaNeigeLayers[[iLayer]]$Pliq         } \tab [numeric] series of liquid precip. [mm/h]                              \cr
    \emph{$CemaNeigeLayers[[iLayer]]$Psol         } \tab [numeric] series of solid precip. [mm/h]                               \cr
    \emph{$CemaNeigeLayers[[iLayer]]$SnowPack     } \tab [numeric] series of snow pack (snow water equivalent) [mm]             \cr
    \emph{$CemaNeigeLayers[[iLayer]]$ThermalState } \tab [numeric] series of snow pack thermal state [°C]                       \cr
    \emph{$CemaNeigeLayers[[iLayer]]$Gratio       } \tab [numeric] series of Gratio [0-1]                                       \cr
    \emph{$CemaNeigeLayers[[iLayer]]$PotMelt      } \tab [numeric] series of potential snow melt [mm/h]                         \cr
    \emph{$CemaNeigeLayers[[iLayer]]$Melt         } \tab [numeric] series of actual snow melt [mm/h]                            \cr
    \emph{$CemaNeigeLayers[[iLayer]]$PliqAndMelt  } \tab [numeric] series of liquid precip. + actual snow melt [mm/h]           \cr
    \emph{$CemaNeigeLayers[[iLayer]]$Temp         } \tab [numeric] series of air temperature [°C]                               \cr
    \emph{$CemaNeigeLayers[[iLayer]]$Gthreshold   } \tab [numeric] series of melt threshold [mm]                                \cr
    \emph{$CemaNeigeLayers[[iLayer]]$Glocalmax    } \tab [numeric] series of local melt threshold for hysteresis [mm]           \cr
    \emph{RunOptions$WarmUpQsim} \tab [numeric] series of simulated discharge (Q) on the warm-up period [mm/h] \cr
    \emph{RunOptions$Param     } \tab [numeric] parameter set parameter set used by the model                  \cr
    \emph{$StateEnd} \tab [numeric] states at the end of the run: store & unit hydrographs levels [mm], CemaNeige states [mm & °C]. See \code{\link{CreateIniStates}} for more details \cr
    \emph{TotGlacMelt} \tab [numeric] modelled glacier melt Mi as total over all elevation bands [mm/h] \cr
  }
Refer to the provided references or to the package source code for further details on these model outputs.
}


\details{
Glacier melt in the elevation layers is given as liquid input into the GR5H model, similar to snow melt. SWE is modeled within the CemaNeige compartment and given as input to the glacier module. Ice melt starts only if the temperature and SWE thresholds are exceeded. For calculating Ai, please refer to \code{\link{CreateRunOptions}}. The formula for calculating the ice melt, \code{Mi}, from glaciers at each time step is given by:
  \deqn{M_i = \left\{
    \begin{array}{ll}
      F_i \times (T - T_m) \times A_i & \text{if } SWE \geq SWE_{th} \text{ and } T \geq T_m \\
      0 & \text{if } SWE < SWE_{th} \text{ or } T < T_m
    \end{array}
  \right.}{M_i = {F_i*(T-T_m)*A_i   if SWE ≥ SWE_th  and T ≥ T_m
0                                   if SWE < SWE_th  and T < T_m }}

Note that this is the same temperature melt index model used by \code{\link{RunModel_CemaNeigeGR6J_Glacier}}; only the time step differs (hourly instead of daily), so the \code{Fi} and CemaNeige \code{X2} parameters should be calibrated for an hourly time step (e.g. approximately 24 times smaller than their daily equivalent, as a starting point).

The choice of the CemaNeige version is explained in \code{\link{CreateRunOptions}}. \cr
For further details on the model, see the references section. \cr
For further details on the argument structures and initialisation options, see \code{\link{CreateRunOptions}}. \cr
See \code{\link{RunModel_GR5H}} to look at the diagram of the hydrological model or \code{\link{RunModel_GR5J}} when no interception store is used.
}


\examples{
\dontrun{
library(airGRalpine)

## loading catchment data
data(U2345030)

## preparation of the InputsModel object
InputsModel <- CreateInputsModel(FUN_MOD = RunModel_CemaNeigeGR5H_Glacier, DatesR = BasinObs$DatesR,
                                 Precip = BasinObs$P, PotEvap = BasinObs$E, TempMean = BasinObs$T,
                                 ZInputs = BasinInfo$ZInputs,
                                 HypsoData = BasinInfo$HypsoData, NLayers = 5)

## run period selection
Ind_Run <- seq(which(format(BasinObs$DatesR, format = "\%Y-\%m-\%d \%H")=="2004-03-01 00"),
               which(format(BasinObs$DatesR, format = "\%Y-\%m-\%d \%H")=="2008-12-31 23"))

## relative ice-covered area of each of the 5 elevation layers
RelIce <- c(0, 0, 0.01, 0.03, 0.06)

## Imax computation
Imax <- Imax(InputsModel = InputsModel, IndPeriod_Run = Ind_Run,
             TestedValues = seq(from = 0, to = 3, by = 0.2))

## preparation of the RunOptions object
RunOptions <- CreateRunOptions(FUN_MOD = RunModel_CemaNeigeGR5H_Glacier, InputsModel = InputsModel,
                               Imax = Imax, IndPeriod_Run = Ind_Run, RelIce = RelIce)

## simulation
Param <- c(X1 = 218.537, X2 = -0.009, X3 = 174.862, X4 = 6.674, X5 = 0.000,
           CNX1 = 0.002, CNX2 = 3.787, Fi = 3.5, Tm = 0.5, SWEth = 2)
OutputsModel <- RunModel_CemaNeigeGR5H_Glacier(InputsModel = InputsModel,
                                               RunOptions = RunOptions, Param = Param)

## results preview
plot(OutputsModel, Qobs = BasinObs$Qmm[Ind_Run])

## efficiency criterion: Nash-Sutcliffe Efficiency
InputsCrit  <- CreateInputsCrit(FUN_CRIT = ErrorCrit_NSE, InputsModel = InputsModel,
                                RunOptions = RunOptions, Obs = BasinObs$Qmm[Ind_Run])
OutputsCrit <- ErrorCrit_NSE(InputsCrit = InputsCrit, OutputsModel = OutputsModel)
}
}


\author{
Laurent Coron, Guillaume Thirel, Olivier Delaigue, Audrey Valéry, Vazken Andréassian, Adrian Kreiner
}


\references{
Ficchi, A. (2017).
  An adaptive hydrological model for multiple time-steps:
  Diagnostics and improvements based on fluxes consistency.
  PhD thesis, UPMC - Irstea Antony, Paris, France.
\cr\cr
Ficchi, A., Perrin, C. and Andréassian, V. (2019).
  Hydrological modelling at multiple sub-daily time steps: model improvement via flux-matching.
  Journal of Hydrology, 575, 1308-1327, \doi{10.1016/j.jhydrol.2019.05.084}.
\cr\cr
Perrin, C., Michel, C. and Andréassian, V. (2003).
  Improvement of a parsimonious model for streamflow simulation.
  Journal of Hydrology, 279(1-4), 275-289, \doi{10.1016/S0022-1694(03)00225-7}.
\cr\cr
Riboust, P., Thirel, G., Le Moine, N. and Ribstein, P. (2019).
  Revisiting a simple degree-day model for integrating satellite data: Implementation of SWE-SCA hystereses.
  Journal of Hydrology and Hydromechanics, 67(1), 70–81, \doi{10.2478/johh-2018-0004}.
\cr\cr
Valéry, A., Andréassian, V. and Perrin, C. (2014).
  "As simple as possible but not simpler": What is useful in a temperature-based snow-accounting routine?
  Part 1 - Comparison of six snow accounting routines on 380 catchments.
  Journal of Hydrology, 517(0), 1166-1175, \doi{10.1016/j.jhydrol.2014.04.059}.
\cr\cr
Valéry, A., Andréassian, V. and Perrin, C. (2014).
  "As simple as possible but not simpler": What is useful in a temperature-based snow-accounting routine?
  Part 2 - Sensitivity analysis of the Cemaneige snow accounting routine on 380 catchments.
  Journal of Hydrology, 517(0), 1176-1187, \doi{10.1016/j.jhydrol.2014.04.058}.
}


\seealso{
\code{\link{RunModel_CemaNeige}}, \code{\link{RunModel_CemaNeigeGR4H_Glacier}}, \code{\link{RunModel_GR5H}}, \code{\link{Imax}},
\code{\link{CreateInputsModel}}, \code{\link{CreateRunOptions}}, \code{\link{CreateIniStates}}.
}
