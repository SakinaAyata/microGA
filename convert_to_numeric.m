
% Sakina, 22 novembre 2011
%
% convert_to_numeric.m
%

%-----------------------------------------
% objectif
%-----------------------------------------
%
% On dispose d'un jeu de paramètre :
% elite_b = set_b(p,:);
% ou bien donner directement les valeurs :
% elite_b =  [1     1     1     1     1     0     0     0     0     1     1 1     0     1 1     0     1     1     0     1     0     0     1     0];
%
% que l'on veut convertir en équivalent binaire  :
% elite_n = ???
%


%-----------------------------------------
% Définition de la fonction
%-----------------------------------------

function elite_n=convert_to_numeric(elite_b,par)
[pp1,pp]=size(par);      % Number of parameters
 [xx,length]=size(elite_b);    % Chromosom (binary string) length
 elite_n=zeros(1,pp);
 
 mmax=0;
  for j=1:pp
     mmin=mmax+1;
     mmax=mmin+par(2,j)-1;
     elite_n(j)=bin2dec(elite_b(mmin:mmax))*par(3,j)+par(1,j);
  end
  
 
end


% Utilisation
%--------------
% elite_n=[12.9 0.8 0.056 2.0]
% bli=convert_to_binary(elite_n,par)
% blibli=convert_to_numeric(bli,par)
