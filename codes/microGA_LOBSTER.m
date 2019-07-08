%
% Implementation of micro-Genetic Algorithm in Matlab
% For parameter optimization of marine ecosystem model
%
% Sakina Ayata
% 25 July 2011
% Last modifications : 27 Jan 2012
%-----------------------------------------------------


%------------------------------------------
% Micro-Genetic Algorithm (uGA) principles
%------------------------------------------

% References for uGA
%.....................
% Caroll (1996) AIAA Journal 34, 338-346.
% Schartau & Oschlies (2003) Journ Mar Res 61, 765-793.
% Rokonuzzama & Sakai (2010) Comp & Geotch 37, 573-579.
% Wards et al. (2010) Journ Mar Sci 81, 34-43.

% Characteristic of the uGA implemented here
%.............................................
%       - binary coding of parameters
%       - tournament selection
%       - uniform cross-over
%       - elitism


%----------------------------------------------
% Micro-Genetic Algorithm (uGA) implementation
%----------------------------------------------
 

% If the microGA is re-run and should restart from the last elite
% set restart to 1, otherwise set it to 0 (no restart)
 restart=1;     % if restart = true
 restart=0;     % if restart = false

fprintf('******************************************************\n');
if not(restart),  clear, restart=0; 
else
    fprintf('*          RESTART AFTER %d GENERATIONS              *\n',k);
    fprintf('******************************************************\n'); 
end

    
phyto_model=11;

RandStream.setDefaultStream (RandStream('mt19937ar','seed',sum(100*clock)));

% First_guess
% ---------------------------------------------------
% If the microGA is run from a first_guess as initial param values
% set first_guess to 1, otherwise set it to 0 (no first_guess)
% by default, no first_guess should be used
first_guess=1;   % with first guess
first_guess=0;   % without first guess

% If you want to use a first guess (first_guess=1)
% The values of this first guess should be defined here
elite_n=[1.1 0.6 18e-7 4.22];
   
% Misfit function used for the optimization
% ---------------------------------------------------
% The model produces an output file named bli.dat (see the routine 
% misfit_function_LOBSTER2.m) with the values of several misfit functions.
% At a given line L of the output file bli.dat is writen the value
% of the misfit funtion number L. Please define L here:
misfit=93;
    
fprintf('\n**************LOBSTER phyto_model %d ',phyto_model);
fprintf('********************************\n');
fprintf('Choice of misfit function number %d.\n',misfit);

    
% Definition of the parameter space 'par' 
% ---------------------------------------------------
% The parameter search space has to be defined here as a matrix
% with for each parameter:
% [Minimal value; number of binary; digit;increament ]
fprintf('Defining the parameter space: ');
  name= {'alpha';'mu';'g'};
  par = [ 0.3   0.1   0.1;
          6     6     6 ;
          0.2   0.1   0.1];
   
[p1,p]=size(par);      % Number of parameters
length=sum(par(2,:));  % Chromosom (binary string) length
fprintf('Optimization of %d parameters.\n',p);
bits=2^par(2,1);

% Define the parameters of the uGA
%-------------------------------------------------------------
fprintf('Defining the parameters of the uGA: ');
N = 10;               % Number of generations
                      % N>500, except for tests (N=5 for instance)
ind = max(4,p);       % Number of individual per generation
                      % set equal to the number of parameters to optimize
                      % with a minimal value of 4.
if not(restart),  set_b = zeros(ind,length); end% Parameter set (binary coding)
if not(restart),  set_n = zeros(ind,p); end     % Parameter set (numeric coding)
mis = zeros(2,ind);       % Misfit function (fitness)
mis2=zeros(1,ind);
evol=zeros(1,N);          % Evolution of best misfit
fprintf('%d generations, %d individuals.\n',N,ind);
if not(restart),  tableau=zeros(50*N,p); mini=0; end

% Algorithm
% -------------------------------------------------------------
fprintf('Runing the uGA...\n');
if not(restart), ii=1; end
fprintf(' -> Parameters :         ');
fprintf(' %s  ',name{1:p});fprintf('\n');

 if not(restart), kmin=1; else kmin=2; end

 for k=kmin:N
 % Generate random initial population (binary & numeric coding)
 %-------------------------------------------------------------
 G=1;
 % INITIALIZE_POP
if (first_guess)
  fprintf(' ->  First guess                   [%2.1f  %1.1f  %1.3f ]\n',...
  elite_n(1),elite_n(2),elite_n(3),elite_n(4));
  elite_b=convert_to_binary(elite_n,par);
        for j=1:length, set_b(ind,j)=str2double(elite_b(j)); end
        for j=1:p, set_n(ind,j)=elite_n(j); end
end
 [set_n set_b first_guess]=initialize_pop(ind,par,k,set_n,set_b,first_guess);
 set_b;
 stop =0;

  % Repeat for X generations :
 while ~stop 
  
    G=G+1;
    
    % Assess  population by calculating misfit function
    % MISFIT_FUNCTION
       %mis=misfit_function_LOBSTER(misfit,set_n,phyto_model);
        mis=misfit_function_LOBSTER2(misfit,set_n,phyto_model,mini,G);
        mini=min(mis(1,:));
        %mis(1,:)',
    % Save all misfit evaluation
       for kk=1:ind
           for kkk=1:p
           tableau(ii,kkk)=set_n(kk,kkk);
           end
           tableau(ii,kkk+1)=mis(1,kk);
           ii=ii+1;
       end
       
    % Creation of the new generation (children)
    % NEW_GENERATION
       [set_n set_b evol(k)]=new_generation2(ind,par,set_n,set_b,mis);
       %set_n,
    % Terminate search if all individuals are identicals
    stop=1;
    for i=2:ind
      stop=stop&isequal(set_n(1,:),set_n(i,:));
    end
 end
 

fprintf(' -> G %d : F%d = %f [%2.1f  %1.1f  %1.3f]\n',...
    k,misfit,min(mis(1,:)),set_n(1,1),set_n(1,2),set_n(1,3));
 

end

G;

 
fprintf(' -> G %d : F%d = %f [%2.1f  %1.1f  %1.3f]\n',...
     k,misfit,min(mis(1,:)),set_n(1,1),set_n(1,2),set_n(1,3));

hold on
plot(evol)
plot(evol,'*')
 


% uGA characteristics
%%%%%%%%%%%%%%%%%%%%%%%

fprintf('\n Total number of individuals = %d.\n',ii-1);


 clf;
 format='';
for i=1:2*p
    for j=1:bits
        format=strcat(format,'%f\t');
    end
    format=strcat(format,'\n');
end
filename=strcat('file_res2_',int2str(phyto_model),'.dat');
fileID = fopen(filename,'r+');
res2=dlmread(filename);


%res2=zeros(2*p,bits);
 for x=2:ii-1,
     for y=1:p
       val=int8((tableau(x,y)-par(1,y))/par(3,y)+1);
%        if res2(y+p,val) == 0
%           res2(y+p,val) = 1;
%           res2(y,val)=tableau(x,p+1);
%        elseif res2(y,val)>tableau(x,p+1)
%           res2(y,val)=tableau(x,p+1); 
       res2(y,val) = min(res2(y,val),tableau(x,p+1));
      end
  end



fprintf(fileID,format ,res2);

 clf;
% plot(evol)%; plot(evol,'*')
% clf; 
  subplot(3,3,1); stairs(res2(1,:));  grid on; title(name(1))
  subplot(3,3,2); stairs(res2(2,:));  grid on; title(name(2))
  subplot(3,3,3); stairs(res2(3,:));  grid on; title(name(3))
  subplot(3,3,4); stairs(res2(4,:));  grid on; title(name(4))
  if phyto_model>11 
     subplot(3,3,5); stairs(res2(5,:));  grid on; title(name(5))
  elseif phyto_model>12 
    subplot(3,3,6); stairs(res2(6,:));  grid on; title(name(6))
 %subplot(3,3,7); stairs(res2(7,:));  grid on; title(name(7))
  end
  

  



 
