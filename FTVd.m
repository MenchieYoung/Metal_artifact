%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [U,iter] = FTVd1(H,Bn,mu,TVtype,opts)
%
% A fast algorithm for solving the TVL2 model:
%    min TV(u) + 0.5*mu*||H*U - Bn||_2^2.
% where H is a point spread function and H*U is 
% a convolution of U.
%
% Input: 
%   --- H is a PSF.
%   --- Bn is a 2D blurred and noisy image  
%   --- mu > 0 is a scalar
%   --- TVtype: TV discretization type.
%               1 - anisotropic: |U_x|+|U_y|; 
%               2 - isotropic: sqrt(|U_x|^2+|U_y|^2)
%   --- opts: a structure for options   
%          opts.tol   : tolerance  for inner iter {5.e-4}
%          opts.maxit : maximum inner iteration number {50}
%          opts.bmax  : maximum beta value {2^20}
%          opts.bmin  : minimum bata value {1}
%          opts.IncreaseRate: IncreaseRate {2}
%          opts.disp  : display flag = {0} 1
%
% Output:
%   --- U is the deblurred image
%   --- iter is the total number of inner iterations
%
% Written by Yilun Wang, Wotao Yin, and Yin Zhang
% CAAM, Rice University, Copyright (2007)
% Original:  03-16-2007 by Yin Zhang
% Revisions: June, 2007 by Yilun Wang
%            08-10-2007 by Wotao Yin

% initialization
[tol,maxit,beta_max,beta_min,IncreaseRate,idisp] = setopts(opts,mu);
[m n]=size(Bn);
U=Bn; iter = 0;
beta = beta_min;

% compute fixed quantities
[conjoDx,conjoDy,Nomin1,Denom1,Denom2] = getC(Bn,H);

Outiter = 0;
while beta <= beta_max; %%% Outer Iterations

    gamma   = beta/mu;
    Denom   = Denom1 + gamma*Denom2;
    vartol1 = tol*(beta_max/beta)^2;
    varmaxit = maxit/2;

    Outiter = Outiter + 1;
    for Inniter = 1:varmaxit

        % w-subprolem
        Ux = [diff(U,1,2)  zeros(m,1)]; % column diff
        Uy = [diff(U,1,1); zeros(1,n)]; %   row  diff

        switch TVtype
            case 1;   %|Du|_1=|u_x| + |u_y|
                Wx=sign(Ux).* max(abs(Ux)-1/beta,0);
                Wy=sign(Uy).* max(abs(Uy)-1/beta,0);
            case 2;   %\|Du\|=\sqrt(u_x^2+u_y^2)
                V = sqrt(Ux.*Ux + Uy.*Uy);
                S = max(V - 1/beta, 0);
                V(V==0) = 1; S = S./V;
                Wx = S.*Ux; Wy = S.*Uy;
            otherwise; error('TVtype must be 1 or 2');
        end

        % u-subproblem
        Up = U;
        Nomin2 = conjoDx.*fft2(Wx) + conjoDy.*fft2(Wy);
        FU = (Nomin1 + gamma*Nomin2)./Denom;
        U = real(ifft2(FU)); % compute new U

        % updating tolerance
        crit1 = norm(U-Up,'fro')/norm(U,'fro');
        if crit1 < vartol1; break; end;

    end
    iter = iter + Inniter;
    beta=IncreaseRate*beta;

    if idisp == 1;
        fprintf('Outer %2i: beta = %6.2e ',Outiter,beta);
        fprintf('crit1 = %6.2e (Inniter %i)\n',crit1,Inniter);
    end

end;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [conjoDx,conjoDy,Nomin1,Denom1,Denom2] = getC(Bn,H);
% compute fixed quantities
sizeB = size(Bn);
otfDx = psf2otf([1,-1],sizeB);
otfDy = psf2otf([1;-1],sizeB);
conjoDx = conj(otfDx);
conjoDy = conj(otfDy);
otfH  = psf2otf(H,sizeB);
Nomin1 = conj(otfH).*fft2(Bn);
Denom1 = abs(otfH).^2;
Denom2 = abs(otfDx).^2 + abs(otfDy ).^2;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [tol,maxit,beta_max,beta_min,IncreaseRate,idisp] = ...
    setopts(opts,mu);

% define default option fields
tol  = 5.e-4;
maxit = 50;
beta_max = min(2^20,100*mu);
beta_min = 1;
IncreaseRate = 2;
idisp = 0;

% change to specified option fields if exist
if ~isempty(opts);
    if ~isa(opts,'struct'); error('L1pfi: opts not a struct'); end
    if isfield(opts,'maxit'); maxit = opts.maxit; end
    if isfield(opts,'disp');  idisp = opts.disp;  end
    if isfield(opts,'tolx');    tol = opts.tol;   end
    if isfield(opts,'bmax'); beta_max=opts.bmax;  end
    if isfield(opts,'bmin'); beta_min=opts.bmin;  end
    if isfield(opts,'IncreaseRate'); IncreaseRate=opts.IncreaseRate; end
end;
