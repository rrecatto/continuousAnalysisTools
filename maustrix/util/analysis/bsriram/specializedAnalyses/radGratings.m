function out = radGratings(rf,stim,mode)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% model of RF (either 1D or 2D)
% rf = (C-S)* where:
% C : Kc*(1/(sqrt(pi)*rc)*exp((-x.^2)/rc^2))
% S : Ks*(1/(sqrt(pi)*rs)*exp((-x.^2)/rs^2))
% 
% exp(-x^2/r^2) -> pi*r^2 weight



%% actual calculation

if ~exist('rf','var')&&~ismember(mode,{'default'})
    error('must specify rf');
end

if ~exist('stim','var')&&~ismember(mode,{'default'})
    error('must specify stim');
end

switch mode
    case '1D-DOG-MCLikeModel'
        x = rf.thetaMin:rf.dTheta:rf.thetaMax;
        xStim = 3*rf.thetaMin:rf.dTheta:3*rf.thetaMax;
        
        rc = rf.RC;
        rs = rf.RS;
        if isfield(rf,'RE')
            re = rf.RE;
            Ke = rf.KE;
            c50 = rf.C50;
        else
            re = 1;
            Ke = 0;
            c50 = 0.5;
        end
        if isfield(rf,'ETA')
            Kc = 1;
            Ks = rf.ETA*rc/rs;
            Eta = rf.ETA;
            out.rf = rf;
            out.rf.KC = Kc;
            out.rf.KS = Ks;
        else
            Kc = rf.KC;
            Ks = rf.KS;
            Eta = (Ks*rs)/(Kc*rc);
            out.rf = rf;
            out.rf.ETA = Eta;
        end
        
        maskRs = stim.maskRs;
        switch class(stim.FS)
            case 'char'
                switch stim.FS
                    case 'optimalSF'
                        stimSF = stim;
                        stimSF.FS = logspace(log10(0.005),log10(0.5),100);
                        outSF = rfModel(rf,stimSF,'1D-DOG-useSensitivity-analytic');
                        if Eta<0.1
                            % find peak f1
                            f1SF = squeeze(outSF.f1);
                            peakF1 = max(f1SF);
                            % 95% 
                            which = f1SF>(0.90*peakF1);
                            whichFs = stimSF.FS(which);
                            chosenFs = max(whichFs);
                            maxF1 = f1SF(max(find(which)));
                        else
                            [maxF1 which] = max(squeeze(outSF.f1));
                            chosenFs = stimSF.FS(which);                            
                        end
%                         figure; semilogx((stimSF.FS),(squeeze(outSF.f1)),'k');
%                         hold on;
%                         plot(chosenFs,maxF1,'k*','markersize',5');
%                         keyboard
                        out.chosenFs = chosenFs;
                    case 'twiceOptimalSF'
                        stimSF = stim;
                        stimSF.FS = logspace(log10(0.005),log10(0.5),100);
                        outSF = rfModel(rf,stimSF,'1D-DOG');
                        if Eta<0.1
                            % find peak f1
                            f1SF = squeeze(outSF.f1);
                            peakF1 = max(f1SF);
                            % 95% 
                            which = f1SF>(0.95*f1SF);
                            whichFs = stimSF.FS(which);
                            chosenFs = max(whichFs);
                        else
                            [junk which] = max(squeeze(outSF.f1));
                            chosenFs = stimSF.FS(which);
                        end
                        chosenFs = 2*chosenFs;
                        stimSF.FS = chosenFs;
%                         outSFTwiceOpt = rfModel(rf,stimSF,'1D-DOG-analytic');
%                         figure; plot(stimSF.FS,squeeze(outSF.f1));
%                         hold on;
%                         plot(chosenFs,squeeze(outSFTwiceOpt.f1),'k*');
                        out.chosenFs = chosenFs;
                end
                fs = chosenFs;
            case 'double'
                fs = stim.FS;
                out.chosenFs = fs;
        end
        
        % get sf data
        stimSF = stim;
        stimSF.FS = logspace(log10(0.005),log10(0.5),100);
        outSF = rfModel(rf,stimSF,'1D-DOG-useSensitivity');
        out.SFTuning.FS = stimSF.FS;
        out.SFTuning.F1 = squeeze(outSF.f1);
        out.SFTuning.chosenFS = out.chosenFs;
        
        stimSF.FS = out.chosenFs;
        outSF = rfModel(rf,stimSF,'1D-DOG-useSensitivity');
        out.SFTuning.chosenF1 = squeeze(outSF.f1);
        
        % do the radius data
        C = Kc*sqrt(pi)*rc*exp((-x.^2)/rc^2);
        S = Ks*sqrt(pi)*rs*exp((-x.^2)/rs^2);
        E = Ke*sqrt(pi)*re*exp((-x.^2)/re^2);
        EStim = Ke*sqrt(pi)*re*exp((-xStim.^2)/re^2);
        RF = C-S;
        
        f1 = nan(length(maskRs),1);
        f1Lin = f1;
        cSuppression = f1;
        gratStim = stim.m*stim.c*sin(2*pi*fs*xStim);
        
        for i = 1:length(maskRs)
            mask = abs(x)<maskRs(i);
            maskStim = abs(xStim)<maskRs(i);
            maskedRF =RF.*double(mask);
          
            temp = conv(gratStim,maskedRF,'valid')*rf.dTheta;
            
            maskedStim = gratStim.*double(maskStim);
            cSuppression(i) = sqrt(sum((maskedStim.*maskedStim.*EStim)*(rf.dTheta)^3));
            f1Lin(i) = range(temp);
            f1(i) = range(temp)*(c50/(c50+cSuppression(i)));
        end
        out.f1Lin = f1Lin;
        out.cSuppression = cSuppression;
        out.f1 = f1;
    case '1D-DOG'
        x = rf.thetaMin:rf.dTheta:rf.thetaMax;
        xStim = 3*rf.thetaMin:rf.dTheta:3*rf.thetaMax;
        
        rc = rf.RC;
        rs = rf.RS;
        if isfield(rf,'ETA')
            Kc = 1;
            Ks = rf.ETA*rc/rs;
            Eta = rf.ETA;
            out.rf = rf;
            out.rf.KC = Kc;
            out.rf.KS = Ks;
        else
            Kc = rf.KC;
            Ks = rf.KS;
            Eta = (Ks*rs)/(Kc*rc);
            out.rf = rf;
            out.rf.ETA = Eta;
        end
        
        maskRs = stim.maskRs;
        switch class(stim.FS)
            case 'char'
                switch stim.FS
                    case 'optimalSF'
                        stimSF = stim;
                        stimSF.FS = logspace(log10(0.005),log10(0.5),100);
                        outSF = rfModel(rf,stimSF,'1D-DOG-useSensitivity-analytic');
                        if Eta<0.1
                            % find peak f1
                            f1SF = squeeze(outSF.f1);
                            peakF1 = max(f1SF);
                            % 95% 
                            which = f1SF>(0.90*peakF1);
                            whichFs = stimSF.FS(which);
                            chosenFs = max(whichFs);
                            maxF1 = f1SF(max(find(which)));
                        else
                            [maxF1 which] = max(squeeze(outSF.f1));
                            chosenFs = stimSF.FS(which);                            
                        end
%                         figure; semilogx((stimSF.FS),(squeeze(outSF.f1)),'k');
%                         hold on;
%                         plot(chosenFs,maxF1,'k*','markersize',5');
%                         keyboard
                        out.chosenFs = chosenFs;
                    case 'twiceOptimalSF'
                        stimSF = stim;
                        stimSF.FS = logspace(log10(0.005),log10(0.5),100);
                        outSF = rfModel(rf,stimSF,'1D-DOG');
                        if Eta<0.1
                            % find peak f1
                            f1SF = squeeze(outSF.f1);
                            peakF1 = max(f1SF);
                            % 95% 
                            which = f1SF>(0.95*f1SF);
                            whichFs = stimSF.FS(which);
                            chosenFs = max(whichFs);
                        else
                            [junk which] = max(squeeze(outSF.f1));
                            chosenFs = stimSF.FS(which);
                        end
                        chosenFs = 2*chosenFs;
                        stimSF.FS = chosenFs;
%                         outSFTwiceOpt = rfModel(rf,stimSF,'1D-DOG-analytic');
%                         figure; plot(stimSF.FS,squeeze(outSF.f1));
%                         hold on;
%                         plot(chosenFs,squeeze(outSFTwiceOpt.f1),'k*');
                        out.chosenFs = chosenFs;
                end
                fs = chosenFs;
            case 'double'
                fs = stim.FS;
                out.chosenFs = fs;
        end
        
        % get sf data
        stimSF = stim;
        stimSF.FS = logspace(log10(0.005),log10(0.5),100);
        outSF = rfModel(rf,stimSF,'1D-DOG-useSensitivity');
        out.SFTuning.FS = stimSF.FS;
        out.SFTuning.F1 = squeeze(outSF.f1);
        out.SFTuning.chosenFS = out.chosenFs;
        
        stimSF.FS = out.chosenFs;
        outSF = rfModel(rf,stimSF,'1D-DOG-useSensitivity');
        out.SFTuning.chosenF1 = squeeze(outSF.f1);
        
        % do the radius data
        C = Kc*sqrt(pi)*rc*exp((-x.^2)/rc^2);
        S = Ks*sqrt(pi)*rs*exp((-x.^2)/rs^2);
        RF = C-S;
        
        f1 = nan(length(maskRs),1);
        f1Lin = f1;
%         cSuppression = f1;
        gratStim = stim.m*stim.c*sin(2*pi*fs*xStim);
        
        for i = 1:length(maskRs)
            mask = abs(x)<maskRs(i);
%             maskStim = abs(xStim)<maskRs(i);
            maskedRF =RF.*double(mask);
          
            temp = conv(gratStim,maskedRF,'valid')*rf.dTheta;
            
%             maskedStim = gratStim.*double(maskStim);
%             cSuppression(i) = sqrt(sum((maskedStim.*maskedStim.*EStim)*(rf.dTheta)^3));
            f1Lin(i) = range(temp);
%             f1(i) = range(temp)*(c50/(c50+cSuppression(i)));
            f1(i) = f1Lin(i);
        end
%         out.f1Lin = f1Lin;
%         out.cSuppression = cSuppression;
        out.f1 = f1;
    otherwise
        error('unsupported mode');
end
end
