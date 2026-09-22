!------------------------------------------------------------------------------
!    Subroutines relative to the glacier ablation (temperature-index melt) module
!------------------------------------------------------------------------------
! TITLE   : airGR
! PROJECT : airGR
! FILE    : frun_GLACIER.f90
!------------------------------------------------------------------------------
! Creation date: 2026
!------------------------------------------------------------------------------
! Quick description of public procedures:
!         1. frun_glacier
!------------------------------------------------------------------------------


      SUBROUTINE frun_glacier(LInputs,InputsTemp,InputsSWE, &
                              Fi,Tm,SWEth,RelIce,OutputsIceMelt)
! Subroutine that computes the ice melt contribution of one elevation layer
! at each time step using a temperature-index (degree-day) model
! Inputs
!       LInputs        ! Integer, length of input and output series
!       InputsTemp     ! Vector of real, input series of air mean temperature [degC]
!       InputsSWE      ! Vector of real, input series of snow water equivalent (SWE) of the layer [mm]
!       Fi             ! Real, degree-day ice melt factor [mm/degC/time step]
!       Tm             ! Real, ice melt threshold temperature [degC]
!       SWEth          ! Real, SWE threshold below which ice melt can occur [mm]
!       RelIce         ! Real, relative ice-covered area of the layer [-]
! Outputs
!       OutputsIceMelt ! Vector of real, ice melt contribution of the layer, scaled by RelIce [mm/time step]


      Implicit None

      !! dummies
      ! in
      integer, intent(in) :: LInputs
      doubleprecision, intent(in), dimension(LInputs) :: InputsTemp
      doubleprecision, intent(in), dimension(LInputs) :: InputsSWE
      doubleprecision, intent(in) :: Fi,Tm,SWEth,RelIce
      ! out
      doubleprecision, intent(out), dimension(LInputs) :: OutputsIceMelt

      !! locals
      integer :: k

      !--------------------------------------------------------------
      ! Time loop
      !--------------------------------------------------------------
      DO k=1,LInputs

        IF (InputsSWE(k).LE.SWEth .AND. InputsTemp(k).GT.Tm) THEN
          OutputsIceMelt(k)=(InputsTemp(k)-Tm)*Fi*RelIce
        ELSE
          OutputsIceMelt(k)=0.d0
        ENDIF

      ENDDO

      RETURN

      END SUBROUTINE
