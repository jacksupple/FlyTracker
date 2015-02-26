function [velocities] = calcVelocity(data,block)
%Creator: Kristian Johansson - kristian.johansson86@gmail.com
%Spring 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function that calculates velocties, by doing so the first data point is 
%removed as there is no way of knowing when this was started

    velocities = cell(4,1);
    
    len = length(data{1,block});
    forvel = zeros(1,len);
    sidevel = zeros(1,len);
    yawvel = zeros(1,len);
    
    velocities{4,1} = data{4,block}(1:end);
    
    for i=2:len
        %dt = delta time
        dt = (data{4,block}(i)-data{4,block}(i-1));
        
        %if dt is zero, the previous velocity is written over using the
        %delta sum between the last three positions
        if dt == 0
            dt = (data{4,block}(i)-data{4,block}(i-2));
            forvel(i-1) = (data{1,block}(i)-data{1,block}(i-2))/dt;
            sidevel(i-1) = (data{2,block}(i)-data{2,block}(i-2))/dt;
            yawvel(i-1) = (data{3,block}(i)-data{3,block}(i-2))/dt;
        else
            forvel(i) = (data{1,block}(i)-data{1,block}(i-1))/dt;
            sidevel(i) = (data{2,block}(i)-data{2,block}(i-1))/dt;
            yawvel(i) = (data{3,block}(i)-data{3,block}(i-1))/dt;
        end
                
    end
    
    velocities{1,1} = forvel;
    velocities{2,1} = sidevel;
    velocities{3,1} = (180/pi).*yawvel; %Convert to degrees from rad
    velocities{4,1} = (1/1000).*data{4,block}; %Convert time to seconds
end