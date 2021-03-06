function [rhsu] = VarCoeffDGrhs1D(x,Avar,u,h,k,m,N,Ma,S,VtoE,maxvel,time)
% function [rhsu] = VarCoeffDGrhs1D(x,Avar,u,h,k,m,N,Ma,S,VtoE,maxvel)
% Purpose  : Evaluate the RHS of Burgers equations using a DG method
Imat = eye(m+1); 
ue = zeros(N+2,2);
AvarE= zeros(N+2,2);

% Extend data and assign boundary conditions
[ue] = extendDG(u(VtoE),'P',0,'P',0);
%[AvarE] = extendDG(ue(VtoE),'P',0,'P',0);
[AvarE] = extendDG(Avar(VtoE),'P',0,'P',0);

% Compute numerical fluxes at interfaces
fluxr = VarCoeffSFCF(AvarE(2,2:N+1),AvarE(1,3:N+2),ue(2,2:N+1),ue(1,3:N+2),0,maxvel); 
fluxl = VarCoeffSFCF(AvarE(2,1:N),AvarE(1,2:N+1),ue(2,1:N),ue(1,2:N+1),0,maxvel);

% Compute right hand side of the variable coefficient equation
ru = -S'*(Avar.*u) + (Imat(:,m+1)*fluxr(1,:) - Imat(:,1)*fluxl(1,:));
rhsu = (h/2*Ma)\ru;

return
