CreateParamSet_LHS <- function(ParamMin, ParamMax, NSamples, Seed = NULL) {

  ## check arguments
  if (!is.vector(ParamMin) | !is.numeric(ParamMin)) {
    stop("'ParamMin' must be a numeric vector")
  }
  if (!is.vector(ParamMax) | !is.numeric(ParamMax)) {
    stop("'ParamMax' must be a numeric vector")
  }
  if (length(ParamMin) != length(ParamMax)) {
    stop("'ParamMin' and 'ParamMax' must have the same length")
  }
  if (any(is.na(ParamMin)) | any(is.na(ParamMax))) {
    stop("'ParamMin' and 'ParamMax' must not contain NA")
  }
  if (any(ParamMin >= ParamMax)) {
    stop("'ParamMin' must be strictly lower than 'ParamMax' for each parameter")
  }
  if (!is.numeric(NSamples) | length(NSamples) != 1 | NSamples < 1) {
    stop("'NSamples' must be a single positive integer")
  }
  if (!is.null(Seed)) {
    if (!is.numeric(Seed) | length(Seed) != 1) {
      stop("'Seed' must be a single numeric value if not NULL")
    }
    set.seed(Seed)
  }

  NSamples <- as.integer(NSamples)
  NParam   <- length(ParamMin)

  ## Latin Hypercube sampling: each parameter dimension is split into 'NSamples' equal-probability
  ## strata; one point is drawn at random inside each stratum, and the strata are independently
  ## permuted across dimensions so that every stratum of every dimension is used exactly once
  UnitLHS <- matrix(NA_real_, nrow = NSamples, ncol = NParam)
  for (iParam in seq_len(NParam)) {
    Strata <- sample.int(NSamples)
    UnitLHS[, iParam] <- (Strata - 1 + runif(NSamples)) / NSamples
  }

  ParamSet <- sweep(UnitLHS, MARGIN = 2, STATS = ParamMax - ParamMin, FUN = "*")
  ParamSet <- sweep(ParamSet, MARGIN = 2, STATS = ParamMin,          FUN = "+")

  if (!is.null(names(ParamMin))) {
    colnames(ParamSet) <- names(ParamMin)
  }

  return(ParamSet)

}
