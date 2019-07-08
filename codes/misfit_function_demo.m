%
% Function definition: misfit_function_demo
%
% Estimate the misfit function of a population of parameters
% (numeric coding)
%
% Sakina, 25 July 2011.
%--------------------------------------------------------------

function mis=misfit_function_demo(set_n)
% Estimate the misfit function of a population of parameters (numeric coding)
% call: misfit_function_demo(set_n)
[ind x]=size(set_n);
mis = zeros(2,ind);

% Theoretical observations
obs=zeros(50,1);

mod=zeros(50,1);
for kk=1:50
    obs(kk)=55 +3*kk+3*kk^2;
end

 for i = 1:ind,
   mis(1,i)=0;
   for kk=1:50,
     mod(kk)=set_n(i,1)+set_n(i,2)*kk+set_n(i,3)*kk^2;
     diff2=(obs(kk)-mod(kk))^2;
     mis(1,i)=mis(1,i)+diff2/50;
   end
 end 