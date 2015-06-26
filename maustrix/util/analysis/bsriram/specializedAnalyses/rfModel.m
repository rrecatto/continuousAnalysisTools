function out = rfModel(rf,stim,mode)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% model of RF (either 1D or 2D)
% rf = nC-S where:
% C : Center
% S : Surround
% weight(C) = weight(S) = 1
% n : relative weight of center to surround
% 
% exp(-x^2/r^2) -> pi*r^2 weight


if ~exist('rf','var')&&~ismember(mode,{'default'})
    error('must specify rf');
end

if ~exist('stim','var')&&~ismember(mode,{'default'})
    error('must specify stim');
end

switch mode
    case 'default'
        dTheta = 0.1;
        thetaMin = -10; thetaMax = 10;
        
        
        RC = 1; % degree
        RS = 3; % degree
        ETA = 0.5;
        A = 1;
        
        FS = logspace(log10(0.01),log10(2),70);
        c = 1;
        m = 0.5;
        
        rf.thetaMin = thetaMin;
        rf.thetaMax = thetaMax;
        rf.dTheta = dTheta;
        rf.RC = RC;
        rf.RS = RS;
        rf.ETA = ETA;
        rf.A = A;
        
        stim.FS = FS;
        stim.m = m;
        stim.c = c;
        
        out = rfModel(rf,stim,'2D-dogRF');
    case '1D-DOG'
        x = rf.thetaMin:rf.dTheta:rf.thetaMax;
        xe = 3*rf.thetaMin:rf.dTheta:3*rf.thetaMax;
%         keyboard
        f1 = nan(length(rf.RC),length(rf.RS),length(rf.ETA),length(stim.FS));
        for i = 1:length(rf.RC)
            for j = 1:length(rf.RS)
                for k = 1:length(rf.ETA)
                    E = 1/(sqrt(pi)*rf.RC(i))*exp((-x.^2)/rf.RC(i)^2);
                    I = 1/(sqrt(pi)*rf.RS(i))*exp((-x.^2)/rf.RS(j)^2);
                    rfShape = rf.A*(E-rf.ETA(k)*I);
                    for l = 1:length(stim.FS)
                        sfStim = stim.m+stim.m*stim.c*sin(2*pi*stim.FS(l)*xe);
                        temp = conv(sfStim,rfShape,'valid');
                        f1(i,j,k,l) = range(temp);
                    end
                end
            end
        end
        out.f1 = f1;
        out.RC = rf.RC;out.RS = rf.RS;out.ETA = rf.ETA;out.FS = stim.FS;
    case '1D-DOG-analytic'
        f1 = nan(length(rf.RC),length(rf.RS),length(rf.ETA),length(stim.FS));
        for i = 1:length(rf.RC)
            for j = 1:length(rf.RS)
                for k = 1:length(rf.ETA)
                    f1(i,j,k,:) = abs(rf.A*(rf.ETA(k)*exp(-(pi*rf.RC(i)*stim.FS).^2)-exp(-(pi*rf.RS(j)*stim.FS).^2)));
                end
            end
        end
        out.f1 = f1;
        out.RC = rf.RC;out.RS = rf.RS;out.ETA = rf.ETA;out.FS = stim.FS;
    case '2D-DOG-conv'
        x = rf.thetaMin:rf.dTheta:rf.thetaMax;
        y = x; % +/- 10 degrees
        [X Y] = meshgrid(x,y);
        xe = 3*rf.thetaMin:rf.dTheta:3*rf.thetaMax;
        Xe = meshgrid(xe,y); % only for stim
        
        f1 = nan(length(rf.RC),length(rf.RS),length(rf.ETA),length(stim.FS));
        for i = 1:length(rf.RC)
            for j = 1:length(rf.RS)
                for k = 1:length(rf.ETA)
                    E = 1/(pi*rf.RC(i)*rf.RC(i))*exp((-X.^2-Y.^2)/rf.RC(i)^2);
                    I = 1/(pi*rf.RS(i)*rf.RS(i))*exp((-X.^2-Y.^2)/rf.RS(j)^2);
                    rfShape = rf.A*(rf.ETA(k)*E-I);
                    for l = 1:length(stim.FS)
                        sfStim = stim.m+stim.m*stim.c*sin(2*pi*stim.FS(l)*Xe);
                        temp = conv2(sfStim,rfShape,'valid');
                        f1(i,j,k,l) = range(temp);
                    end
                end
            end
        end
        out.f1 = f1;
        out.RC = rf.RC;out.RS = rf.RS;out.ETA = rf.ETA;out.FS = stim.FS;
    case '2D-DOG-loop'
        ft = 1;
        x = rf.thetaMin:rf.dTheta:rf.thetaMax;
        y = x;
        [X Y] = meshgrid(x,y);
        
        f1 = nan(length(rf.RC),length(rf.RS),length(rf.ETA),length(stim.FS));
        for i = 1:length(rf.RC)
            for j = 1:length(rf.RS)
                for k = 1:length(rf.ETA)
                    E = 1/(pi*rf.RC(i)*rf.RC(i))*exp((-X.^2-Y.^2)/rf.RC(i)^2);
                    I = 1/(pi*rf.RS(i)*rf.RS(i))*exp((-X.^2-Y.^2)/rf.RS(j)^2);
                    rfShape = rf.A*(rf.ETA(k)*E-I);
                    for l = 1:length(stim.FS)
                        % need atleast two cycles
                        whichSizeStim = max(2/stim.FS(l),2*rf.thetaMax);
                        xe = -whichSizeStim:rf.dTheta:whichSizeStim;
                        Xe = meshgrid(xe,y);
                        sfStim = stim.m+stim.m*stim.c*sin(2*pi*stim.FS(l)*Xe);
                        phasePerIncrement = 2*pi*stim.FS(l)*rf.dTheta;
                        t = 0:0.01:2; % 0 to 2 seconds in increments of hundreths of a second
                        response = nan(1,length(t));
                        for m = 1:length(t)
                            dPhase = mod(2*pi*ft*t(m),2*pi);
                            dIncrement = ceil(dPhase/phasePerIncrement)+1;
                            temp = rfShape.*sfStim(:,dIncrement:size(rfShape,1)+dIncrement-1);
                            response(m) = sum(temp(:));
                        end
                        f1(i,j,k,l) = range(response);
                    end
                end
            end
        end
        out.f1 = f1;
        out.RC = rf.RC;out.RS = rf.RS;out.ETA = rf.ETA;out.FS = stim.FS;
    case '2D-DOG'
        out = rfModel(rf,stim,'2D-DOG-conv');
    case '1D-DOG-useSensitivity-analytic'
        f1 = nan(length(rf.RC),length(rf.RS),length(rf.KC),length(rf.KS),length(stim.FS));
        for i = 1:length(rf.RC)
            for j = 1:length(rf.RS)
                for k = 1:length(rf.KC)
                    for l = 1:length(rf.KS)
                        for m = 1:length(stim.FS)
                            f1(i,j,k,l,m) = abs((rf.KC(k)*pi*rf.RC(i)^2*exp(-(pi*rf.RC(i)*stim.FS(m))^2))-(rf.KS(l)*pi*rf.RS(j)^2*exp(-(pi*rf.RS(j)*stim.FS(m))^2)));
                        end
                    end
                end
            end
        end
        out.f1 = f1;
        out.RC = rf.RC;out.RS = rf.RS;out.KC = rf.KC;out.KS = rf.KS;out.FS = stim.FS;
    case '1D-DOG-useSensitivity'
        x = rf.thetaMin:rf.dTheta:rf.thetaMax;
        xe = 3*rf.thetaMin:rf.dTheta:3*rf.thetaMax;
        f1 = nan(length(rf.RC),length(rf.RS),length(rf.KC),length(rf.KS),length(stim.FS));
        for i = 1:length(rf.RC)
            for j = 1:length(rf.RS)
                for k = 1:length(rf.KC)
                    for l = 1:length(rf.KS)
                        C = rf.KC(k)*sqrt(pi)*rf.RC(i)*exp((-x.^2)/rf.RC(i)^2); %(1/(sqrt(pi)*rf.RC(i)*rf.RC(i)))*
                        S = rf.KS(l)*sqrt(pi)*rf.RS(j)*exp((-x.^2)/rf.RS(j)^2); %(1/(sqrt(pi)*rf.RS(j)*rf.RS(j)))*
                        rfShape = C-S;
%                         figure;plot(x,rfShape)
                        for m = 1:length(stim.FS)
                            sfStim = stim.m+stim.m*stim.c*sin(2*pi*stim.FS(m)*xe);
                            temp = conv(sfStim,rfShape,'valid')*rf.dTheta;
                            f1(i,j,k,l,m) = range(temp);
                        end
                    end
                end
            end
        end
        out.f1 = f1;
        out.RC = rf.RC;out.RS = rf.RS;out.KC = rf.KC;out.KS = rf.KS;out.FS = stim.FS;
    otherwise
        error('unsupported mode');
end
end

