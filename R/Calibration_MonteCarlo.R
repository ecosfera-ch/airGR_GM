Calibration_MonteCarlo <- function(InputsModel,
                                   RunOptions,
                                   InputsCrit,
                                   FUN_MOD,
                                   ParamMin,
                                   ParamMax,
                                   NSamples = 1000,
                                   Seed = NULL,
                                   verbose = TRUE,
                                   ...) {


  FUN_MOD <- match.fun(FUN_MOD)


  ##_____Arguments_check_____________________________________________________________________
  if (!inherits(InputsModel, "InputsModel")) {
    stop("'InputsModel' must be of class 'InputsModel'")
  }
  if (!inherits(RunOptions, "RunOptions")) {
    stop("'RunOptions' must be of class 'RunOptions'")
  }
  if (!inherits(InputsCrit, "InputsCrit")) {
    stop("'InputsCrit' must be of class 'InputsCrit'")
  }
  if (inherits(InputsCrit, "Multi")) {
    stop("'InputsCrit' must be of class 'Single' or 'Compo'")
  }
  if (!is.vector(ParamMin) | !is.numeric(ParamMin)) {
    stop("'ParamMin' must be a numeric vector")
  }
  if (!is.vector(ParamMax) | !is.numeric(ParamMax)) {
    stop("'ParamMax' must be a numeric vector")
  }
  if (length(ParamMin) != length(ParamMax)) {
    stop("'ParamMin' and 'ParamMax' must have the same length")
  }
  NParam <- length(ParamMin)
  if (NParam != RunOptions$FeatFUN_MOD$NbParam) {
    stop(sprintf("'ParamMin' and 'ParamMax' must be of length %i for the chosen 'FUN_MOD'",
                 RunOptions$FeatFUN_MOD$NbParam))
  }
  if (!is.numeric(NSamples) | length(NSamples) != 1 | NSamples < 1) {
    stop("'NSamples' must be a single positive integer")
  }
  NSamples <- as.integer(NSamples)


  ##_variables_initialisation_________________________________________________________________
  ## generation of the Monte Carlo parameter sets using a Latin Hypercube sample
  ## drawn within the user-defined ['ParamMin', 'ParamMax'] range of each parameter
  HistParamR <- CreateParamSet_LHS(ParamMin = ParamMin, ParamMax = ParamMax,
                                   NSamples = NSamples, Seed = Seed)
  HistCrit      <- rep(NA_real_, NSamples)
  CritName      <- NULL
  CritBestValue <- NULL
  Multiplier    <- NULL
  CritOptim     <- +Inf
  iOptim        <- 0L

  ##_temporary_change_of_Outputs_Sim__________________________________________________________
  RunOptions$Outputs_Sim <- RunOptions$Outputs_Cal ### this reduces the size of the matrix exchange with fortran and therefore speeds the calibration


  ##_____Monte_Carlo_sampling_and_evaluation__________________________________________________
  if (verbose) {
    message("Monte Carlo calibration in progress (", appendLF = FALSE)
    message("0%", appendLF = FALSE)
  }
  for (iSample in seq_len(NSamples)) {
    if (verbose) {
      for (k in c(2, 4, 6, 8)) {
        if (iSample == round(k / 10 * NSamples)) {
          message(" ", 10 * k, "%", appendLF = FALSE)
        }
      }
    }
    ##Model_run
    Param <- HistParamR[iSample, ]
    OutputsModel <- RunModel(InputsModel, RunOptions, Param, FUN_MOD = FUN_MOD, ...)

    ##Calibration_criterion_computation
    OutputsCrit <- ErrorCrit(InputsCrit, OutputsModel, verbose = FALSE)
    HistCrit[iSample] <- OutputsCrit$CritValue * OutputsCrit$Multiplier

    if (!is.na(OutputsCrit$CritValue)) {
      if (OutputsCrit$CritValue * OutputsCrit$Multiplier < CritOptim) {
        CritOptim <- OutputsCrit$CritValue * OutputsCrit$Multiplier
        iOptim    <- iSample
      }
    }
    ##Storage_of_crit_info
    if (is.null(CritName) | is.null(CritBestValue) | is.null(Multiplier)) {
      CritName      <- OutputsCrit$CritName
      CritBestValue <- OutputsCrit$CritBestValue
      Multiplier    <- OutputsCrit$Multiplier
    }
  }
  if (verbose) {
    message(" 100%)\n", appendLF = FALSE)
  }
  if (iOptim == 0L) {
    stop("no parameter set among the Monte Carlo sample gave a valid criterion value")
  }


  ##_____Output________________________________________________________________________________
  ParamFinalR <- as.double(HistParamR[iOptim, ])
  CritFinal   <- CritOptim * Multiplier

  if (verbose) {
    message(sprintf("\t Calibration completed (%s runs)", NSamples))
    message("\t     Param = ", paste(sprintf("%8.3f", ParamFinalR), collapse = ", "))
    message(sprintf("\t     Crit. %-12s = %.4f", CritName, CritFinal))
  }

  colnames(HistParamR) <- paste0("Param", seq_len(NParam))

  OutputsCalib <- list(ParamFinalR = ParamFinalR, CritFinal = CritFinal,
                       NRuns = NSamples,
                       HistParamR = HistParamR, HistCrit = HistCrit * Multiplier,
                       ParamMin = ParamMin, ParamMax = ParamMax,
                       CritName = CritName, CritBestValue = CritBestValue)
  class(OutputsCalib) <- c("OutputsCalib", "MonteCarlo")
  return(OutputsCalib)


}
