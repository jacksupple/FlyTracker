classdef Calibrate
    %CALIBRATION class - object that encapsulates calibration data and
    %perform necessary calculations on these.
    
    %Instance variables of the Calibrate object, public
    properties
        config;
        alphas;
        betas;
        dists;
        handles;
        numTrials;
        avgErr;
        forwards;
        sides;
        errs1;
        errs2;
        latest;
    end
    
    methods
        
        %Constructor that takes one parameter, the handle object of the GUI
        function this = Calibrate(h)
            this.config = getappdata(0,'config');
            this.dists = [];
            this.errs1 = [];
            this.errs2 = [];
            this.forwards = [];
            this.sides = [];
            this.handles = h;
            this.alphas = [];
            this.numTrials = 0;
            this.latest = '';
            this.avgErr = 0;
        end
        
        %Calibrates yaw rotation
        function [this] = calibrateYaw(this,m,a)
            this.alphas(end+1) = this.calcAlpha(m,a);
            this.dists(end+1) = m;
            
            temp = mean(this.alphas).*this.dists;
            temp = a./temp;
            
            temp = abs(1-temp);
            
            this.avgErr = mean(temp);
            this.numTrials = this.numTrials + 1;
            this.latest = 'yaw';
        end
        
        %Calibrates the two different pure translation movements 
        function [this] = calibrateTranslation(this,m,a,type)
            this.betas(end+1) = this.calcAlpha(m,a);
            this.latest = type;
            if strcmp(type,'side')
                this.sides(end+1) = m;
                this.errs1 = mean(this.betas).*this.sides;
                this.errs1 = a./this.errs1;
                
                this.errs1 = abs(1-this.errs1);
            elseif strcmp(type,'forward')
                this.forwards(end+1) = m;
                this.errs2 = mean(this.betas).*this.forwards;
                this.errs2 = a./this.errs2;
                
                this.errs2 = abs(1-this.errs2);
            else
                
            end
            
            temp = [this.errs1,this.errs2];
            
            this.avgErr = mean(temp);
            this.numTrials = this.numTrials + 1;
        end
        
        %Calculates the calibration factor
        function value = calcAlpha(this,measuredDist, actualDist)
            value = actualDist./(measuredDist);
        end
        
        %Function for removing latest calibration run, only works if there
        %is at least one run existing
        function this = removeLatest(this)
            
            if this.numTrials > 0
                if strcmp(this.latest,'side')
                    this.betas = this.betas(1:end-1);
                    this.sides = this.sides(1:end-1);
                    this.errs1 = this.errs1(1:end-1);
                    temp = [this.errs1,this.errs2];

                    this.avgErr = mean(temp);
                elseif strcmp(this.latest,'forward')
                    this.betas = this.betas(1:end-1);
                    this.forwards = this.forwards(1:end-1);
                    this.errs2 = this.errs2(1:end-1);
                    temp = [this.errs1,this.errs2];
                    this.avgErr = mean(temp);
                elseif strcmp(this.latest,'yaw')
                    this.dists = this.dists(1:end-1);
                    this.alphas = this.alphas(1:end-1);
                end

                this.numTrials = this.numTrials - 1;
            end
        end
        
    end
end

