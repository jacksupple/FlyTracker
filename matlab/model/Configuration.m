classdef Configuration < handle
    %Configuration class, object that holds all information that needs to
    %be stored between sessions but in particular all calibration values.
    
    properties (GetAccess = 'public',SetAccess = 'private')
        trigger;
        port;
        timer;
        runnable;
        time;
        savepath;
        pwd;
        beta_
        alpha_;
        theta_; %In radians
        plotting;
        radius;
        forwardAxis;
        sideAxis;
    end
    
    methods (Access = 'public')
        
        %Constructor for the config object setting default values which are
        %later updated to user custom values
        function this = Configuration()
            this.port = 4444;
            this.trigger = 'no';
            this.runnable = true;
            this.time = 3000;
            this.savepath = getpath('','data');
            this.pwd = '';
            this.alpha_ = 1;
            this.beta_ = 1;
            this.radius = 1;
            this.theta_ = 0;
            this.plotting = 'cumsum';
            this.forwardAxis = 1;
            this.sideAxis = 2;
        end   
        
        %%%%%%%%%%SETTERS%%%%%%%%%%%%%%%%
        function setNetworkTrigger(this,t)
            this.trigger = t;
        end
        
        function setRadius(this,r)
            if r > 0
                this.radius = r;
            else
                errordlg('Radius must be a positive real number');
            end
        end
        
        function setAngle(this,a)
            if a > -180
                this.theta_ = a*(pi/180); %Convert to radians for future calculations
            else
                errordlg('Angle must be a positive real number');
            end
        end
        
        function setRunnable(this,bool)
            this.runnable = bool;
        end
        
        function setPath(this,path)
            %Path must exist
            if exist(path,'dir')
                this.savepath = path;
            end
        end
        
        function setPw(this,p)
            this.pwd = p;
        end
        
        function setTime(this,t)
            %Time must be a positive integer
            if str2num(t) > 1
                this.time = t;
            else
                this.time = 3000;
            end
            
        end
        
        function setPlotting(this,p)
            this.plotting = p;
        end
        
        function setPort(this,p)
            %Validates portnumber before setting it
            if str2num(p) > 1024 && str2num(p) < 65535    
                this.port = str2num(p);
            else
                this.port = 4444;
            end
        end
        
        function setAlpha(this,a)
            this.alpha_ = a;
        end
        
        function setBeta(this,b)
            this.beta_ = b;
        end
        
        %Each axis can only be 1 or 2 and exclusively so
        function flipAxis(this,forw)
            this.forwardAxis = forw;
            this.sideAxis = 3-forw;
        end
    end
    
end

