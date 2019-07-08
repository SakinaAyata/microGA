%------------------------------------------------------------------------
% Function definition:  [set_n set_b]=initialize_pop(ind,par,k,set_n,set_b)
%------------------------------------------------------------------------
%
% Generate random initial population (both in binary & numeric coding)
%            1) Generate random parameters in numeric coding
%            2) Convert them in binary coding
%
% Inputs : 	ind       	: number of individuals in the population
%					par		: caracteristic of the parameters to optimize (minimum value, number of bits, increment)
%               	k 			: number of generation
%					set_n 	: previous parameters values in numeric coding
%					set_b 	: previous parameters values in binary coding
%
% Outputs: set_n 	: parameters values in numeric coding
%					set_b 	: parameters values in binary coding
%
% Sakina, 27 January 2011.
%--------------------------------------------------------------

function [set_n set_b first_guess]=initialize_pop(ind,par,k,set_n,set_b,first_guess)
% Generate random initial population of parameters (both binary & numeric coding)
% call: initialize_pop(ind,par,k,set_n,set_b)

% Number of parameters to initialize
%--------------------------------------------------------------
[p1,p]=size(par);           
tempp=zeros(1,p);

if k==1
  % If first generation : no place to keep for the elite
    if first_guess 
        max=ind-1; %save a place fot the first_guess
        first_guess=0;
    else
        max=ind; %save a place fot the elite
    end
% otherwise : save a place fot the elite
else
    max=ind-1;
end

%Generation of a random population or parameters
% --------------------------------------------------------------
for i = 1:max,
    ini=0;
    for j = 1:p,
        tempp(j)=rand(1);
        set_n(i,j)=par(3,j)*floor(tempp(j)*2^par(2,j))+par(1,j);
        bstr=dec2bin(floor(tempp(j)*2^par(2,j)),par(2,j));
        for kk=1:par(2,j)
            set_b(i,ini+kk)=bin2dec(bstr(kk));
        end
        ini=ini+par(2,j);
     end
end

end

