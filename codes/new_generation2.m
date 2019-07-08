%------------------------------------------------------------------------
% Function definition:  new_generation
%  [set_n set_b val]=new_generation(ind,par,set_n,set_b,mis)
%------------------------------------------------------------------------
%
%  Create a new generation of parameters from a parental population
%            1) Tournament selection of the two parents
%            2) Uniform crossover between parental chromosoms
%            3) Elitism : the best fitted individual is conserved in the next generation
%
% Inputs : 	ind       	: number of individuals in the population
%					par		: caracteristic of the parameters to optimize (minimum value, number of bits, increment)
%					set_n 	: parameters values in numeric coding (parental population)
%					set_b 	: previous parameters values in binary coding (parental population)
%					mis   	: misfit values of the N individuals
%
% Outputs: set_n 	: parameters values in numeric coding (child population)
%					set_b 	: parameters values in binary coding (child population)
%               	val 		: misfit of the elite
%
% Sakina, 27 January 2011.
%--------------------------------------------------------------


function [set_n set_b val]=new_generation2(ind,par,set_n,set_b,mis)
% Create a new generation of parameters from a parental population
% call: new_generation(ind,par,set_n,set_b,mis)

[p1,p]=size(par);          % Number of parameters
length=sum(par(2,:));      % Chromosom (binary string) length
child= zeros(ind,length);  % Child chromosoms
eli=zeros(1,length);       % Elitism


for i=1:(ind-1)
% Tournament select the most fit parents
  %........................................
  % Select parents 'a', 'b', 'c', and 'd' for tournament
  a = floor(rand*ind)+1;
  b=a;
  while b==a
      b = floor(rand*ind)+1;  
  end
  c=a;
  while (c==a || c==b)
      c = floor(rand*ind)+1;  
  end  
  d=a;
  while (d==a || d==b  || d==c)
      d = floor(rand*ind)+1;  
  end
  % Tournament between 'a' and 'b' and between 'c' and 'd'
  if mis(b) < mis(1,a)
      a=b;
  end
  if mis(d) < mis(1,c)
      c=d;
  end  
  % Mate succesfull parents ('a' and 'c') to obtain child ('i')
  % Using uniform crossover
  %.............................................................
   %fprintf('Mating %d and %d for child %d,\n',a,c,i)
   for j=1:length
       temp=floor(rand*2);
       if temp==0
           child(i,j)=set_b(a,j);
       else
           child(i,j)=set_b(c,j);
       end
   end
 end
 
  % Elitism
  %..........
  
    [aa,bb]=min(mis(1,:));
    val=aa; % misfit of the elite
    
if not(bb==ind),
    for j=1:length
        eli(j)=set_b(bb,j);
    end
    for j=1:length
        set_b(ind,j)=eli(j);
    end
    
    str=int2str(eli);
    str(str==' ') = '';
    set_n(ind,:)=convert_to_numeric(str,par);
%     mmax=0;
%     for j=1:p
%         mmin=mmax+1;
%         mmax=mmin+par(2,j)-1;
%         bin2dec(int2str(eli(mmin:mmax))),
%         set_n2(ind,j)=bin2dec(int2str(eli(mmin:mmax)))*par(3,j)+par(1,j);
%     end

% 
%     mmax=0;
%     for j=1:p
%         mmin=mmax+1;
%         mmax=mmin+par(2,j)-1;
%         set_n2(ind,j)=bin2dec(int2str(eli(mmin:mmax)))*par(3,j)+par(1,j);
%     end
end


 % Renewal of the population with the children
 for i=1:(ind-1)
    mmax=0;
    for j=1:p
        mmin=mmax+1;
        mmax=mmin+par(2,j)-1;
        set_n(i,j)=bin2dec(int2str(child(i,mmin:mmax)))*par(3,j)+par(1,j);
    end
    for j=1:length
        set_b(i,j)=child(i,j);
    end
 end