function out = IsSignificant(p1,m,p2,n)
X = p1.*m;
Y = p2.*n;

p11 = (X+1)./(m+2);
p22 = (Y+1)./(n+2);
q11 = 1-p11;
q22 = 1-p22;

dP = p11-p22;
warning('using 95% confidence intervals');

Za_2 = norminv(0.975,0,1);

dP_CI = Za_2*sqrt(((p11.*q11)./m)+((p22.*q22)./n));
out.IsSignificant = abs(dP)>dP_CI;
out.dP = dP;
end