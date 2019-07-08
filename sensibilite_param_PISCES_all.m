%
% Sensibility of a misfit function around a default parameter set
%
% Sakina Ayata
% Initial version (for PISTER) : 8 Dec 2011
% Last modifications :  7 May 2012 for PISTER 1D Austral (Joan)
%                       10 May 2012 : all PISTER parameters (80 param)
%----------------------------------------------------------------------

%clear;
fprintf('*********************************************\n');
fprintf('***** Sensibility analysis for PISTER *******\n');
fprintf('*********************************************\n');
fprintf('***** 1D run in the Austral Ocean     *******\n');
fprintf('***** Bloom characteristics           *******\n');
fprintf('*********************************************\n');

misfit = 9 ; % Line of the first value of interest in the output file (bli.dat)


%--------------------------------------------------
% Definition of the parameter space (name)
%--------------------------------------------------

name     = {...
%nampisbio     %   biological parameters
    'wsbio';'xkmort';'ferat3';'wsbio';...
%nampislim     %   parameters for nutrient limitations
    'conc0';'conc1';'conc2';'conc2m';'conc3';'conc3m';...
    'xsizedia';'xsizephy';'concnnh4';'concdnh4';...
    'xksi1';'xksi2';'xkdoc';'concfebac';'qnfelim';'qdfelim';...
%nampisprod     %   parameters for phytoplankton growth
    'pislope';'pislope2';'ecret';'excret2';'bresp';...          
    'chlcnm';'chlcdm';'chlcmin';'fecnm';'fecdm';'grosip';...
%nampismort     %   parameters for phytoplankton sinks
    'wchl';'wchld';'mprat';'mprat2';'mpratm';...
%nampismes     %   parameters for mesozooplankton
    'part2';'grazrat2';'resrat2';'mzrat2';...
    'xprefc';'xprefp';'xprefz';'xprefpoc';...
    'xthresh2zoo';'xthresh2dia';'xthresh2phy';'xthresh2poc';'xthresh2';...
    'xkgraz2';'epsher2';'sigma2';'unass2';'grazflux';...
%nampiszoo     %   parameters for microzooplankton
    'part';'grazrat';'resrat';'mzrat';'xpref2c';'xpref2p';'xpref2d';...
    'xthreshdia';'xthreshphy';'xthreshpoc';'xthresh';...
    'xkgraz';'epsher';'sigma1';'unass';...
%nampisrem     %   parameters for remineralization
    'xremik';'xremip';'nitrif';'xsirem';'xsiremlab';'xsilab';...
    'xlam1';'oxymin';'ligand';...
%nampiscal     %   parameters for Calcite chemistry
    'kdca';'nca'};
   
%--------------------------------------------------
% Definition of the default parameter values
%--------------------------------------------------

%nampisbio     %   biological parameters
   wsbio      =  2.;       % POC sinking speed
   xkmort     =  2.E-7 ;   % half saturation constant for mortality
   ferat3     =  10.E-6;   % Fe/C in zooplankton 
   wsbio2     =  30. ;     % Big particles sinking speed
%nampislim     %   parameters for nutrient limitations
   conc0      =  1.e-6 ;   % Phosphate half saturation
   conc1      =  8E-6 ;    % Phosphate half saturation for diatoms
   conc2      =  1E-9 ;    % Iron half saturation for phyto
   conc2m     =  3E-9;     % Max iron half saturation for phyto
   conc3      =  3E-9;     % Iron half saturation for diatoms
   conc3m     =  8E-9;     % Maxi iron half saturation for diatoms
   xsizedia   =  1.E-6;    % Minimum size criteria for diatoms
   xsizephy   =  1.E-6;    % Minimum size criteria for phyto
   concnnh4   =  1.E-7;    % NH4 half saturation for phyto
   concdnh4   =  8.E-7;    % NH4 half saturation for diatoms
   xksi1      =  2.E-6;    % half saturation constant for Si uptake
   xksi2      =  3.33E-6 ; % half saturation constant for Si/C
   xkdoc      =  417.E-6;  % half-saturation constant of DOC remineralization
   concfebac  =  1.E-11;   % Half-saturation for Fe limitation of Bacteria
   qnfelim    =  7.E-6;    % Optimal quota of phyto
   qdfelim    =  7.E-6;    % Optimal quota of diatoms
%nampisprod     %   parameters for phytoplankton growth
   pislope    =  2.;       % P-I slope
   pislope2   =  2.;       % P-I slope  for diatoms
   excret     =  0.05;     % excretion ratio of phytoplankton
   excret2    =  0.05;     % excretion ratio of diatoms
   bresp      =  0.00333;  % Basal respiration rate
   chlcnm     =  0.033;    % Minimum Chl/C in nanophytoplankton
   chlcdm     =  0.05;     % Minimum Chl/C in diatoms
   chlcmin    =  0.0033;   % Maximum Chl/c in phytoplankton
   fecnm      =  40E-6;    % Maximum Fe/C in nanophytoplankton
   fecdm      =  40E-6;    % Minimum Fe/C in diatoms
   grosip     =  0.151;    % mean Si/C ratio
%nampismort     %   parameters for phytoplankton sinks
   wchl       =  0.001;    % quadratic mortality of phytoplankton
   wchld      =  0.02;     % maximum quadratic mortality of diatoms
   mprat      =  0.01;     % phytoplankton mortality rate
   mprat2     =  0.01;     % Diatoms mortality rate
   mpratm     =  0.01;     % Phytoplankton minimum mortality rate
%nampismes     %   parameters for mesozooplankton
   part2      =  0.75;    % part of calcite not dissolved in mesozoo guts
   grazrat2   =  0.7;      % maximal mesozoo grazing rate
   resrat2    =  0.005;    % exsudation rate of mesozooplankton
   mzrat2     =  0.03;     % mesozooplankton mortality rate
   xprefc     =  1.;       % zoo preference for phyto
   xprefp     =  0.3;      % zoo preference for POC
   xprefz     =  1.;       % zoo preference for zoo
   xprefpoc   =  0.3;      % zoo preference for poc
   xthresh2zoo = 1E-8;     % zoo feeding threshold for mesozooplankton 
   xthresh2dia = 1E-8;     % diatoms feeding threshold for mesozooplankton 
   xthresh2phy = 1E-8;     % nanophyto feeding threshold for mesozooplankton 
   xthresh2poc = 1E-8;     % poc feeding threshold for mesozooplankton 
   xthresh2   =  2E-7;    % Food threshold for grazing
   xkgraz2    =  20.E-6;   % half sturation constant for meso grazing
   epsher2    =  0.3;      % Efficicency of Mesozoo growth
   sigma2     =  0.6;      % Fraction of mesozoo excretion as DOM
   unass2     =  0.3;      % non assimilated fraction of P by mesozoo
   grazflux   =  2.e3;     % flux-feeding rate
%nampiszoo     %   parameters for microzooplankton
   part       =  0.5 ;     % part of calcite not dissolved in microzoo gutsa
   grazrat    =  3.0;      % maximal zoo grazing rate
   resrat     =  0.03;     % exsudation rate of zooplankton
   mzrat      =  0.001;    % zooplankton mortality rate
   xpref2c    =  0.1 ;     % Microzoo preference for POM
   xpref2p    =  1. ;      % Microzoo preference for Nanophyto
   xpref2d    =  0.5;      % Microzoo preference for Diatoms
   xthreshdia =  1.E-8;    % Diatoms feeding threshold for microzooplankton 
   xthreshphy =  1.E-8;    % Nanophyto feeding threshold for microzooplankton 
   xthreshpoc =  1.E-8;    % POC feeding threshold for microzooplankton 
   xthresh    =  2.E-7;    % Food threshold for feeding
   xkgraz     =  20.E-6;   % half sturation constant for grazing
   epsher     =  0.3;      % Efficiency of microzoo growth
   sigma1     =  0.6;      % Fraction of microzoo excretion as DOM
   unass      =  0.3;      % non assimilated fraction of phyto by zoo
%nampisrem     %   parameters for remineralization
   xremik    =  0.25;      % remineralization rate of DOC
   xremip    =  0.025;     % remineralisation rate of POC
   nitrif    =  0.05;      % NH4 nitrification rate
   xsirem    =  0.003;     % remineralization rate of Si
   xsiremlab =  0.025;     % fast remineralization rate of Si
   xsilab    =  0.31;      % Fraction of labile biogenic silica
   xlam1     =  0.005;     % scavenging rate of Iron
   oxymin    =  1.E-6;     % Half-saturation constant for anoxia
   ligand    =  0.6E-9;    % Ligands concentration
%nampiscal     %   parameters for Calcite chemistry
   kdca       =  6.;       % calcite dissolution rate constant (1/time)
   nca        =  1.;       % order of dissolution reaction (dimensionless)

param=[wsbio xkmort ferat3 wsbio2 conc0 conc1 conc2 conc2m conc3 conc3m...
    xsizedia xsizephy concnnh4 concdnh4 xksi1 xksi2 xkdoc concfebac qnfelim qdfelim...
    pislope pislope2 excret excret2 bresp chlcnm chlcdm chlcmin fecnm fecdm...
    grosip wchl wchld mprat mprat2 mpratm part2 grazrat2 resrat2 mzrat2...
    xprefc xprefp xprefz xprefpoc xthresh2zoo xthresh2dia xthresh2phy xthresh2poc xthresh2 xkgraz2...
    epsher2 sigma2 unass2 grazflux part grazrat resrat mzrat xpref2c xpref2p...
    xpref2d xthreshdia xthreshphy xthreshpoc xthresh xkgraz epsher sigma1 unass xremik...
    xremip nitrif xsirem xsiremlab xsilab xlam1 oxymin ligand kdca nca];   

test=param;
   
P = size(param);
fprintf('Testing its sensibility to %d parameters...\n',P(2));
fprintf('Default characteristics of the bloom:\n');

   
% Estimate of the bloom characteritics of this default parameter set
%--------------------------------------------------------------------

 cmd = sprintf('./script_run_pisces_sensib_all.sh %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d ',...         
     wsbio,xkmort,ferat3,wsbio2,conc0,conc1,conc2,conc2m,conc3,conc3m,...
     xsizedia,xsizephy,concnnh4,concdnh4,xksi1,xksi2,xkdoc,concfebac,qnfelim,qdfelim,...
     pislope,pislope2,excret,excret2,bresp,chlcnm,chlcdm,chlcmin,fecnm,fecdm,...
     grosip,wchl,wchld,mprat,mprat2,mpratm,part2,grazrat2,resrat2,mzrat2,...
     xprefc,xprefp,xprefz,xprefpoc,xthresh2zoo,xthresh2dia,xthresh2phy,xthresh2poc,xthresh2,xkgraz2,...
     epsher2,sigma2,unass2,grazflux,part,grazrat,resrat,mzrat,xpref2c,xpref2p,...
     xpref2d,xthreshdia,xthreshphy,xthreshpoc,xthresh,xkgraz,epsher,sigma1,unass,xremik,...
     xremip,nitrif,xsirem,xsiremlab,xsilab,xlam1,oxymin,ligand,kdca,nca);
system(cmd);
[names,equal,score] = textread('bli.dat','%s %s %f','headerlines',misfit-1);
fprintf('Max Chl           : %d\n',score(1)); 
fprintf('Date of Max Chl   : %d\n',score(2)); 
fprintf('Diatom at Max Chl : %d\n',score(3)); 
fprintf('Date of Max dChl  : %d\n',score(5)); 
fprintf('Production        : %d\n',score(6)); 
name_val= {'MaxChl (gChl/L)';'Date MaxChl (Julian day)';'Diatom (%)';'Date MaxDchl (Julian day)';'Production'};
    
% Param of the Sensitivity analysis of the bloom characteritics 
%----------------------------------------------------------------------

% Range of analysis : from param-100% to param+100%
max=20;                 % Numer of tested value per parameter
bloom=5;                % Number of bloom diagnostics

x=zeros(max*P(2),P(2));	% Table of biological Parameters
y=zeros(max*P(2),bloom);     % Table of bloom characteristics (results)
i=0 ;                   % Index of sensitivity runs (max=20*P(2))

%-------------------------------------------------------------------------------
% SENSITIVITY ANALYSIS OT THE BLOOM
%-------------------------------------------------------------------------------
% Loop on biological parameters 
for p=1:P(2) 
fprintf('---------------------------------------------\n');
fprintf('Parameter N°%d : %s...\n',p,name{p});
 for val=1:max
   i=i+1;
 % Defaut parameter values
   param=[wsbio xkmort ferat3 wsbio2 conc0 conc1 conc2 conc2m conc3 conc3m...
    xsizedia xsizephy concnnh4 concdnh4 xksi1 xksi2 xkdoc concfebac qnfelim qdfelim...
    pislope pislope2 excret excret2 bresp chlcnm chlcdm chlcmin fecnm fecdm...
    grosip wchl wchld mprat mprat2 mpratm part2 grazrat2 resrat2 mzrat2...
    xprefc xprefp xprefz xprefpoc xthresh2zoo xthresh2dia xthresh2phy xthresh2poc xthresh2 xkgraz2...
    epsher2 sigma2 unass2 grazflux part grazrat resrat mzrat xpref2c xpref2p...
    xpref2d xthreshdia xthreshphy xthreshpoc xthresh xkgraz epsher sigma1 unass xremik...
    xremip nitrif xsirem xsiremlab xsilab xlam1 oxymin ligand kdca nca];   
% Change one parameter at a time
   percent=(val-10)*10;
   param(p)=test(p)+test(p)*(percent/100);
% Write namelist and execute NEMO (bash script)
   cmd = sprintf('./script_run_pisces_sensib_all.sh %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d ',...         
     param(1),param(2),param(3),param(4),param(5),param(6),param(7),param(8),param(9),param(10),...
     param(11),param(12),param(13),param(14),param(15),param(16),param(17),param(18),param(19),param(20),...
     param(21),param(22),param(23),param(24),param(25),param(26),param(27),param(28),param(29),param(30),...
     param(31),param(32),param(33),param(34),param(35),param(36),param(37),param(38),param(39),param(40),...
     param(41),param(42),param(43),param(44),param(45),param(46),param(47),param(48),param(49),param(50),...
     param(51),param(52),param(53),param(54),param(55),param(56),param(57),param(58),param(59),param(60),...
     param(61),param(62),param(63),param(64),param(65),param(66),param(67),param(68),param(69),param(70),...
     param(71),param(72),param(73),param(74),param(75),param(76),param(77),param(78),param(79),param(80));
   system(cmd);
   % Read and save bloom descriptors
   [names,equal,score] = textread('bli.dat','%s %s %f','headerlines',misfit-1);
   for ii=1:P(2)
       x(i,ii)=param(ii);
   end
   y(i,1)=score(1);
   y(i,2)=score(2); 
   y(i,3)=score(3); 
   y(i,4)=score(5);
   y(i,5)=score(6);
 end
end

save sensib_003_resdata_all_xy name x y name_val
%load sensib_003_resdata_all_xy

save sensib_003_resdata_all_x.txt -ascii x  % saves matrix a into textfile.txt, values separated by spaces
save sensib_003_resdata_all_y.txt -ascii y
load sensib_003_resdata_all_x.txt           % loads your data creating a workspace variable called textfile
load sensib_003_resdata_all_y.txt
res_x=load('sensib_003_resdata_all_x.txt');     % loads your data into variable a
res_y=load('sensib_003_resdata_all_y.txt');     % loads your data into variable a




cstring='rgbcmykkrgbcmykk'; % color string

clf;
for val=1:4
     subplot(2,2,val); hold on;
     debut=1;
     for p=1:P(2)
        plot((1:max)',y(debut:debut+max-1,val)); grid on; title(name_val(val)); 
        debut=debut+max;
    end
end

legend(name)


cstring='rgbcmyk'; % color string

clf;
for val=1:4
     subplot(2,2,val); hold on;
     debut=1;
     for p=1:3
        plot((1:max)',res_y(debut:debut+max-1,val),cstring(mod(p,7))); grid on; title(name_val(val)); 
        debut=debut+max;
    end
end

legend(name)


clf;
plot(res_y(:,2),res_y(:,1),'x')
xlim([0 300])


clf;
plot(y(:,2),y(:,1),'x')
plot(y(:,3),y(:,1),'o')
plot(y(:,4),y(:,1),'x')
plot(y(:,5),y(:,1),'x')



% PLOT
%%%%%%%%%%%%%%%%%
cstring='rgbcmykkrgbcmykk'; % color string
max=20;


% All 80 param on one plot (One plot per bloom diag)
%----------------------------------------------------
clf;
val=5;
hold on;
debut=1;
for p=1:P(2)
  plot((1:max)',res_y(debut:debut+max-1,val),cstring(mod(p,7)+1)); grid on; title(name_val(val)); 
  debut=debut+max;
end

% 10 times 8 param on one plot (One plot per bloom diag)
%------------------------------------------------------

val=1;
%prem=1;
%debut=prem;
prem=prem+8;
clf;
for p=prem:(prem+7)
     hold on;
     plot((1:max)',res_y(debut:debut+max-1,val),cstring(mod(p,7)+1))
     grid on; title(name_val(val)); 
     debut=debut+max;
     ylim([0 1.5])
    end
legend(name(prem:(prem+7)))


prem=1;
debut=prem;
val=val+1;











