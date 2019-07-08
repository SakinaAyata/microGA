%
% Implementation of micro-Genetic Algorithm in Matlab
% For parameter optimization of marine ecosystem model
%
% Sakina Ayata
% 25 July 2011
% Last modifications : 27 Jan 2012
%-----------------------------------------------------


clear;
RandStream.setDefaultStream (RandStream('mt19937ar','seed',sum(100*clock)));

%------------------------------------------
% Quick demo with a polynomial function
%------------------------------------------

% Aim : to calibrate the three parameters {a1,a2,a3}
% of a simple polynomial function f(x) = a1 + a2.x + a3.x^2


%------------------------------------------
% Micro-Genetic Algorithm (uGA) principles
%------------------------------------------
% Reference: Caroll (1996) AIAA Journal 34, 338-346.
%       - binary coding of parameters
%       - tournament selection
%       - uniform cross-over
%       - elitism


%----------------------------------------------
% Micro-Genetic Algorithm (uGA) implementation
%----------------------------------------------




% Definition of the parameter space 'par' 
% ---------------------------------------------------
% The parameter search space has to be defined here as a matrix
% with for each parameter:
% [Minimal value; number of binary; digit;increament ]
fprintf('Defining the parameter space: ');
name= {'a1';'a2';'a3'};
par = [1 1 1;          % Minimal value,
       6 6 6;           %       number of binary digit,
       1 1 1];         %       and increament of parameter search
[p1,p]=size(par);       % Number of parameters
length=sum(par(2,:));   % Chromosom (binary string) length
fprintf('Optimization of %d parameters.\n',p);
bits=2^par(2,1);


% Define the parameters of the uGA
%-------------------------------------------------------------
fprintf('Defining the parameters of the uGA: ');
N = 100;              % Number of generations
                      % N>500, except for tests (N=5 for instance)
ind = max(4,p);       % Number of individual per generation
                      % set equal to the number of parameters to optimize
                      % with a minimal value of 4.
set_b = zeros(ind,length); % Parameter set (binary coding)
set_n = zeros(ind,p);      % Parameter set (numeric coding)
mis = zeros(2,ind);        % Misfit function (fitness)
mis2=zeros(1,ind);
evol=zeros(1,N);           % Evolution of best misfit
fprintf('%d generations, %d individuals.\n',N,ind);
tableau=zeros(50*N,p); mini=0;


% Algorithm
% -------------------------------------------------------------
fprintf('Runing the uGA...\n');
ii=1;
fprintf(' -> Parameters :         ');
fprintf(' %s  ',name{1:p});fprintf('\n');

 kmin=1;
 for k=kmin:N
 % Generate random initial population (binary & numeric coding)
 %-------------------------------------------------------------
 G=1;
 % INITIALIZE_POP
 [set_n set_b first_guess]=initialize_pop(ind,par,k,set_n,set_b,0);
 set_b;
 stop =0;

  % Repeat for X generations :
 while ~stop 
  
    G=G+1;
    
    % Assess  population by calculating misfit function

 % MISFIT_FUNCTION
 %mis=misfit_function_LOBSTER2(misfit,set_n,phyto_model,mini,G);
 
 mis=misfit_function_demo(set_n);

 
 mini=min(mis(1,:));
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
 

fprintf(' -> G %d : F = %f [%2.1f  %1.1f  %1.3f]\n',...
    k,min(mis(1,:)),set_n(1,1),set_n(1,2),set_n(1,3));
 

end

G;

 
fprintf(' -> G %d : F= %f [%2.1f  %1.1f  %1.3f]\n',...
     k,min(mis(1,:)),set_n(1,1),set_n(1,2),set_n(1,3));

clf;
hold on
plot(evol)
plot(evol,'*')
 

