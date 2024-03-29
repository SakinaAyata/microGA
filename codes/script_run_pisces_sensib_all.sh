#!/bin/sh
# script_run_pisces_sensib.sh
#-------------------------------------------------------------
# Sakina, May 2012
#
# bash script called by Matlab in script_run_pisces_sensib.m to :
#                      1) write the namelist_pisces
#                      2) execute PISCES
#####################################

# Namelist writing
#####################
 
cat > namelist_pisces << EOD
!! Sakina, 2012-05
!!>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
!! PISCES  :    1  - air-sea exchange                         (nampisext)
!! namelists    2  - biological parameters                    (nampisbio)
!!              3  - parameters for nutrient limitations      (nampislim)    
!!              4  - parameters for phytoplankton             (nampisprod,nampismort)
!!              5  - parameters for zooplankton               (nampismes,nampiszoo)
!!              6  - parameters for remineralization          (nampisrem)
!!              7  - parameters for calcite chemistry         (nampiscal)
!!              8  - parameters for inputs deposition         (nampissed)
!!              9  - parameters for Kriest parameterization   (nampiskrp, nampiskrs)
!!              10 - additional 2D/3D  diagnostics            (nampisdia)
!!              11 - Damping                                  (nampisdmp)
!>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
!'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
&nampisext     !   air-sea exchange
!,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ln_co2int  =  .false. ! read atm pco2 from a file (T) or constant (F)
   atcco2     =  280.    ! Constant value atmospheric pCO2 - ln_co2int = F
   clname     =  'atcco2.txt'  ! Name of atm pCO2 file - ln_co2int = T
   nn_offset  =  0       ! Offset model-data start year - ln_co2int = T
!                        ! If your model year is iyy, nn_offset=(years(1)-iyy) 
!                        ! then the first atmospheric CO2 record read is at years(1)
/
!'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
&nampisatm     !  Atmospheric prrssure 
!,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
!              !  file name   ! frequency (hours) ! variable   ! time interp. !  clim  ! 'yearly'/ ! weights  ! rotation !
!              !              !  (if <0  months)  !   name     !   (logical)  !  (T/F) ! 'monthly' ! filename ! pairing  !
   sn_patm     = 'presatm'    ,     -1            , 'patm'     ,  .true.      , .true. ,   'yearly'  , ''       , ''
   cn_dir      = './'     !  root directory for the location of the dynamical files
!
   ln_presatm  = .false.   ! constant atmopsheric pressure (F) or from a file (T)
/
!'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
&nampisbio     !   biological parameters
!,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   nrdttrc    =  3        ! time step frequency for biology
   wsbio      =  ${1} !   2.       ! POC sinking speed
   xkmort     =  ${2} !   2.E-7    ! half saturation constant for mortality
   ferat3      =  ${3} ! 10.E-6   ! Fe/C in zooplankton 
   wsbio2     =  ${4} !   30.      ! Big particles sinking speed
/
!'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
&nampislim     !   parameters for nutrient limitations
!,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   conc0      =    ${5} ! 1.e-6    ! Phosphate half saturation
   conc1      =    ${6} ! 8E-6     ! Phosphate half saturation for diatoms
   conc2      =  ${7} ! 1E-9     ! Iron half saturation for phyto
   conc2m     =  ${8} ! 3E-9     ! Max iron half saturation for phyto
   conc3      =  ${9} ! 3E-9     ! Iron half saturation for diatoms
   conc3m     =  ${10} ! 8E-9     ! Maxi iron half saturation for diatoms
   xsizedia   =    ${11} ! 1.E-6    ! Minimum size criteria for diatoms
   xsizephy   =    ${12} ! 1.E-6    ! Minimum size criteria for phyto
   concnnh4   =    ${13} ! 1.E-7    ! NH4 half saturation for phyto
   concdnh4   =    ${14} ! 8.E-7    ! NH4 half saturation for diatoms
   xksi1      =    ${15} ! 2.E-6    ! half saturation constant for Si uptake
   xksi2      =    ${16} ! 3.33E-6  ! half saturation constant for Si/C
   xkdoc      =   ${17} !  417.E-6  ! half-saturation constant of DOC remineralization
   concfebac  =  ${18} ! 1.E-11   ! Half-saturation for Fe limitation of Bacteria
   qnfelim    =  ${19} ! 7.E-6    ! Optimal quota of phyto
   qdfelim    =  ${20} ! 7.E-6    ! Optimal quota of diatoms
   caco3r     =  0.16     ! mean rain ratio
/
!'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
&nampisprod     !   parameters for phytoplankton growth
!,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   pislope    =  ${21} !  2.       ! P-I slope
   pislope2   =  ${22} ! 2.       ! P-I slope  for diatoms
   excret     =  ${23} !   0.05     ! excretion ratio of phytoplankton
   excret2    =  ${24} !   0.05     ! excretion ratio of diatoms
   ln_newprod =  .true.  ! Enable new parame. of production (T/F) 
   bresp      =  ${25} !   0.00333  ! Basal respiration rate
   chlcnm     =  ${26} ! 0.033    ! Minimum Chl/C in nanophytoplankton
   chlcdm     =  ${27} ! 0.05     ! Minimum Chl/C in diatoms
   chlcmin    =  ${28} ! 0.0033   ! Maximum Chl/c in phytoplankton
   fecnm      =  ${29} ! 40E-6    ! Maximum Fe/C in nanophytoplankton
   fecdm      =  ${30} ! 40E-6    ! Minimum Fe/C in diatoms
   grosip     =  ${31} ! 0.151    ! mean Si/C ratio
/
!'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
&nampismort     !   parameters for phytoplankton sinks
!,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   wchl       =  ${32} !   0.001    ! quadratic mortality of phytoplankton
   wchld      =  ${33} !   0.02     ! maximum quadratic mortality of diatoms
   mprat      =  ${34} !   0.01     ! phytoplankton mortality rate
   mprat2     =  ${35} !   0.01     ! Diatoms mortality rate
   mpratm     =  ${36} !   0.01     ! Phytoplankton minimum mortality rate
/
!'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
&nampismes     !   parameters for mesozooplankton
!,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   part2      =   ${37} ! 0.75    ! part of calcite not dissolved in mesozoo guts
   grazrat2   =  ${38} !  0.7      ! maximal mesozoo grazing rate
   resrat2    =  ${39} !  0.005    ! exsudation rate of mesozooplankton
   mzrat2     =  ${40} !  0.03     ! mesozooplankton mortality rate
   xprefc     =  ${41} !  1.       ! zoo preference for phyto
   xprefp     =  ${42} !  0.3      ! zoo preference for POC
   xprefz     =  ${43} !  1.       ! zoo preference for zoo
   xprefpoc   =  ${44} !  0.3      ! zoo preference for poc
   xthresh2zoo =  ${45} ! 1E-8     ! zoo feeding threshold for mesozooplankton 
   xthresh2dia =   ${46} !1E-8     ! diatoms feeding threshold for mesozooplankton 
   xthresh2phy =  ${47} ! 1E-8     ! nanophyto feeding threshold for mesozooplankton 
   xthresh2poc =  ${48} ! 1E-8     ! poc feeding threshold for mesozooplankton 
   xthresh2   =  ${49} !  2E-7    ! Food threshold for grazing
   xkgraz2    =  ${50} !  20.E-6   ! half sturation constant for meso grazing
   epsher2    =  ${51} !  0.3      ! Efficicency of Mesozoo growth
   sigma2     =  ${52} !  0.6      ! Fraction of mesozoo excretion as DOM
   unass2     =  ${53} !  0.3      ! non assimilated fraction of P by mesozoo
   grazflux   =   ${54} ! 2.e3     ! flux-feeding rate
/
!'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
&nampiszoo     !   parameters for microzooplankton
!,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   part       =  ${55} !  0.5      ! part of calcite not dissolved in microzoo gutsa
   grazrat    =  ${56} !  3.0      ! maximal zoo grazing rate
   resrat     =  ${57} !  0.03     ! exsudation rate of zooplankton
   mzrat      =  ${58} !  0.001    ! zooplankton mortality rate
   xpref2c    =  ${59} !  0.1      ! Microzoo preference for POM
   xpref2p    =  ${60} !  1.       ! Microzoo preference for Nanophyto
   xpref2d    =  ${61} !  0.5      ! Microzoo preference for Diatoms
   xthreshdia =  ${62} !  1.E-8    ! Diatoms feeding threshold for microzooplankton 
   xthreshphy =  ${63} !  1.E-8    ! Nanophyto feeding threshold for microzooplankton 
   xthreshpoc =  ${64} !  1.E-8    ! POC feeding threshold for microzooplankton 
   xthresh    =  ${65} !  2.E-7    ! Food threshold for feeding
   xkgraz     =  ${66} !  20.E-6   ! half sturation constant for grazing
   epsher     =  ${67} !  0.3      ! Efficiency of microzoo growth
   sigma1     =  ${68} !  0.6      ! Fraction of microzoo excretion as DOM
   unass      =  ${69} !  0.3      ! non assimilated fraction of phyto by zoo
/
!'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
&nampisrem     !   parameters for remineralization
!,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   xremik    =  ${70} !  0.25      ! remineralization rate of DOC
   xremip    =  ${71} !  0.025     ! remineralisation rate of POC
   nitrif    =  ${72} !  0.05      ! NH4 nitrification rate
   xsirem    =  ${73} !  0.003     ! remineralization rate of Si
   xsiremlab =  ${74} !  0.025     ! fast remineralization rate of Si
   xsilab    =  ${75} !  0.31      ! Fraction of labile biogenic silica
   xlam1     =  ${76} !  0.005     ! scavenging rate of Iron
   oxymin    =  ${77} !  1.E-6     ! Half-saturation constant for anoxia
   ligand    =   ${78} ! 0.6E-9    ! Ligands concentration
/
!'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
&nampiscal     !   parameters for Calcite chemistry
!,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   kdca       =  ${79} !  6.       ! calcite dissolution rate constant (1/time)
   nca        =  ${80} !  1.       ! order of dissolution reaction (dimensionless)
/
!'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
&nampissed     !   parameters for inputs deposition
!,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
!              !  file name        ! frequency (hours) ! variable   ! time interp. !  clim  ! 'yearly'/ ! weights  ! rotation !
!              !                   !  (if <0  months)  !   name     !   (logical)  !  (T/F) ! 'monthly' ! filename ! pairing  !
   sn_dust     = 'dust.orca'       ,     -1            , 'dust'     ,  .true.      , .true. ,   'yearly'  , ''       , ''
   sn_riverdic = 'river.orca'      ,    -12            , 'riverdic' ,  .false.     , .true. ,   'yearly'  , ''       , ''
   sn_riverdoc = 'river.orca'      ,    -12            , 'riverdoc' ,  .false.     , .true. ,   'yearly'  , ''       , ''
   sn_ndepo    = 'ndeposition.orca',    -12            , 'ndep'     ,  .false.     , .true. ,   'yearly'  , ''       , ''
   sn_ironsed  = 'bathy.orca'      ,    -12            , 'bathy'    ,  .false.     , .true. ,   'yearly'  , ''       , ''
!
   cn_dir      = './'      !  root directory for the location of the dynamical files
   ln_dust     =  .true.   ! boolean for dust input from the atmosphere
   ln_river    =  .true.   ! boolean for river input of nutrients
   ln_ndepo    =  .true.   ! boolean for atmospheric deposition of N
   ln_ironsed  =  .true.   ! boolean for Fe input from sediments
   sedfeinput  =  1E-9     ! Coastal release of Iron
   dustsolub   =  0.02     ! Solubility of the dust
   wdust       =  2.0      ! Dust sinking speed
   nitrfix     =  1E-7     ! Nitrogen fixation rate
   diazolight  =  50.      ! Diazotrophs sensitivity to light (W/m2)
   concfediaz  =  1.E-10   ! Diazotrophs half-saturation Cste for Iron
/
!'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
&nampiskrp     !   Kriest parameterization : parameters     "key_kriest"
!,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   xkr_eta      = 1.17    ! Sinking  exponent
   xkr_zeta     = 2.28    ! N content exponent
   xkr_mass_min = 0.0002  ! Minimum mass for Aggregates
   xkr_mass_max = 1.      ! Maximum mass for Aggregates
/
!'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
&nampiskrs     !   Kriest parameterization : size classes  "key_kriest"
!,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   xkr_sfact    = 942.    ! Sinking factor
   xkr_stick    = 0.5     ! Stickiness
   xkr_nnano    = 2.337   ! Nbr of cell in nano size class
   xkr_ndiat    = 3.718   ! Nbr of cell in diatoms size class
   xkr_nmeso    = 7.147   ! Nbr of cell in mesozoo size class
   xkr_naggr    = 9.877   ! Nbr of cell in aggregates  size class
/
!'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
&nampisdia     !   additional 2D/3D tracers diagnostics 
!,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
!              !    name   !           title of the field          !     units      !
!              !           !                                       !                !  
   pisdia2d(1)  = 'Cflx     ' , 'DIC flux                          ',  'molC/m2/s    '
   pisdia2d(2)  = 'Oflx     ' , 'Oxygen flux                       ',  'molC/m2/s    '
   pisdia2d(3)  = 'Kg       ' , 'Gas transfer                      ',  'mol/m2/s/uatm'
   pisdia2d(4)  = 'Delc     ' , 'Delta CO2                         ',  'uatm         '
   pisdia2d(5)  = 'PMO      ' , 'POC export                        ',  'molC/m2/s    '
   pisdia2d(6)  = 'PMO2     ' , 'GOC export                        ',  'molC/m2/s    '
   pisdia2d(7)  = 'ExpFe1   ' , 'Nano iron export                  ',  'molFe/m2/s   '
   pisdia2d(8)  = 'ExpFe2   ' , 'Diatoms iron export               ',  'molFe/m2/s   '
   pisdia2d(9)  = 'ExpSi    ' , 'Silicate export                   ',  'molSi/m2/s   '
   pisdia2d(10) = 'ExpCaCO3 ' , 'Calcite export                    ',  'molC/m2/s    '
   pisdia2d(11) = 'heup     ' , 'euphotic layer depth              ',  'm            '
   pisdia2d(12) = 'Fedep    ' , 'Iron dep                          ',  'molFe/m2/s   '
   pisdia2d(13) = 'Nfix     ' , 'Nitrogen Fixation                 ',  'molN/m2/s    '
   pisdia3d(1)  = 'PH       ' , 'PH                                ',  '-            '
   pisdia3d(2)  = 'CO3      ' , 'Bicarbonates                      ',  'mol/l        '
   pisdia3d(3)  = 'CO3sat   ' , 'CO3 saturation                    ',  'mol/l        '
   pisdia3d(4)  = 'PAR      ' , 'light penetration                 ',  'W/m2         '
   pisdia3d(5)  = 'PPPHY    ' , 'Primary production of nanophyto   ',  'molC/m3/s    '
   pisdia3d(6)  = 'PPPHY2   ' , 'Primary production of diatoms     ',  'molC/m3/s    '
   pisdia3d(7)  = 'PPNEWN   ' , 'New Primary production of nano    ',  'molC/m3/s    '
   pisdia3d(8)  = 'PPNEWD   ' , 'New Primary production of diat    ',  'molC/m3/s    '
   pisdia3d(9)  = 'PBSi     ' , 'Primary production of Si diatoms  ',  'molSi/m3/s   '
   pisdia3d(10) = 'PFeN     ' , 'Primary production of nano iron   ',  'molFe/m3/s   '
   pisdia3d(11) = 'PFeD     ' , 'Primary production of diatoms iron',  'molFe/m3/s   '
/
!'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
&nampisdmp     !  Damping 
!,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ln_pisdmp    =  .true.     !  Relaxation fo some tracers to a mean value
   nn_pisdmp    =  2400       !  Frequency of Relaxation 
/
!'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
&nampismass     !  Mass conservation
!,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
   ln_check_mass =  .true.    !  Check mass conservation
/
EOD


#PISCES Execution
############################

# run one year (with restart)
./opa > bli.dat




