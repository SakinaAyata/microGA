%
% Function definition: misfit_function
%
% Estimate the misfit function of a population of parameters
% (numeric coding)
%
% Sakina, 25 July 2011.
%--------------------------------------------------------------

function mis=misfit_function_LOBSTER2(m,set_n,phyto_model,mini,G)
% Estimate the misfit function of a population of parameters (numeric coding)
% call: misfit_function(set_n)
[ind x]=size(set_n);
mis = zeros(2,ind);

     
for i = 1:ind 
    %if ((G==1) && isequal(set_n(1,:),set_n(i,:)))
    %    mis(1,i)=mini;
    %else
% Definition of default and optimized parameters
   % Nutrients
   akno3   =  0.7e-6;    % nitrate limitation half-saturation value  [mol/l]
   aknh4   =  0.001e-6;  % ammonium limitation half-saturation value [mol/l]
   psinut  =  3;         % inhibition of nitrate uptake by ammonium
   taunn   =  0.05;      % nitrification rate                        [d-1]

   % Phytoplankton
   alpha   =  set_n(i,1);%1.82; % P-I slpe! = 60/33*1  [d-1.gC/gChl.(W/m2)-1]
   tmumax  =  set_n(i,2);%1; % maximal phytoplankton growth rate       [d-1]
   rgamma  =  0.05;      % phytoplankton exudation fraction             [%]
   tmminp  =  set_n(i,3);%0.05; % minimal phytoplancton mortality rate  [d-1]

   % Zooplankton
   aks     =  1.e-6;      % Kg : half-saturation constant for grazing [molN/l]
   taus    =  0.8;  % g : specific maximal grazing rate    [d-1]
   rpaz    =  0.7;        % non-assimilated phytoplankton by zooplancton [%]
   tauzn   =  0.07;       % lambdaZ : zooplancton  excretion rate [d-1]
   tmminz  =  0.12e6;     % minimal zooplankton mortality rate [(molN/l)-1 d-1]
   rppz    =  0.8;        % zooplankton  preference for phytoplankton [%]
   fdbod   =  0.5;     % zooplankton mortality fraction to detritus

   % DOM and detritus
   taudomn = 0.006;      % DOM breakdown rate                   [d-1]
   fnratio = 0.75;       % Ammonium/DOM redistribution ratio
   vsed    = 3;          % detritus sedimentation speed        [m.d-1]
   taudn   = 0.05;       % detritus breakdown rate           [d-1]
   
  
   % Additional parameters for phytoplankton
    qzero      =  0.05;      % Minimum of the phytoplanktonic Q=N/C ratio
    qmax       =  0.2;       % Maximum of the phytoplanktonic Q=N/C ratio
    rhomax     =  tmumax*qmax; %(Ross & Geider, 2010)!0.06    ! Max uptake
    zeta       =  3;       % Cost of nitrogen assimilation
    chlcnmax   =  0.033;   %Maximum Chl/C in nanophytoplankton
    chlcnmin   =  0.005;   % Minimum Chl/C in nanophytoplankton
    chlnmax    =  2;       % Maximum Chl/N in nanophytoplankton
    if (phyto_model ==12)
      zeta       =  set_n(i,5);%3;       % Cost of nitrogen assimilation
    elseif (phyto_model==13 || phyto_model==14)
      zeta       =  set_n(i,5);%3;  % Cost of nitrogen assimilation
      chlnmax    =  set_n(i,6);%2;  % Maximum Chl/N in nanophytoplankton
    end


   
  % cmd = sprintf('./script_run_lobster2_opti %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d',...
    cmd = sprintf('./script_run_lobster2_opti_2year %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d',...
       akno3,aknh4,psinut,taunn,alpha,tmumax,rgamma,tmminp,aks,taus,...
       rpaz,tauzn,tmminz,rppz,fdbod,taudomn,fnratio,vsed,taudn,phyto_model,...
       qzero,qmax,rhomax,zeta,chlcnmax,chlcnmin,chlnmax);

   system(cmd);
   [names,equal,score] = textread('bli.dat','%s %s %f');%,'headerlines',1);
   mis(1,i)=score(m+4);
   mis(2,i)=score(1);
    %end
end

end

