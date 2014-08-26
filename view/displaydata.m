function [] = displaydata(data,handles,blocksize,toPlot,nrDatapoints)
%DISPLAYDATA Function that displays the data which is provided as input to
%the function. Assumes that there are axes-handles. 


    config = getappdata(0,'config');
    
    vel = get(handles.vel_menu,'Checked');
    cumpos = get(handles.cumpos,'Checked');
    deltapos = get(handles.dp_menu,'Checked');
    [x,y] = calc2DPath(data,1);
    
    %Data is already in degrees
    data{3,1} = data{3,1};%(180/pi).*data{3,1};
    fulldata = cell(4,1);
    
    %toPlot is the blocknumber that is to be plot, also this if-statement
    %calculates which ever way of plotting has been selected
    if strcmp(vel,'on')
        fulldata = calcVelocity(data,toPlot);
    elseif strcmp(cumpos,'on')
        fulldata{1,1} = cumsum(data{1,toPlot});
        fulldata{2,1} = cumsum(data{2,toPlot});
        fulldata{3,1} = cumsum(data{3,toPlot});
        fulldata{4,1} = data{4,toPlot};
    elseif strcmp(deltapos,'on')
        for k=1:4
            fulldata{k,1} = data{k,toPlot};
        end
    end

    %Plot for forward velocity, time x.001 to convert it to seconds
    block = blocksize(2);
    %plot(handles.axes1,.001.*fulldata{4,1},fulldata{config.forwardAxis,1});
    
    if length(fulldata{4,1}) > nrDatapoints
    x_ = fulldata{4,1}(end-nrDatapoints+1:end);
    
    y1 = fulldata{config.forwardAxis,1}(end-nrDatapoints+1:end);
    y2 = fulldata{config.sideAxis,1}(end-nrDatapoints+1:end);
    y3 = fulldata{3,1}(end-nrDatapoints+1:end);
    
    else
        x_ = fulldata{4,1};    
        y1 = fulldata{config.forwardAxis,1};
        y2 = fulldata{config.sideAxis,1};
        y3 = fulldata{3,1};
    end    
    
    plot(handles.axes1,.001.*x_,y1);
    title_ = strcat('Block',' ',num2str(block),': forward position');
    title(handles.axes1,title_);
    axis(handles.axes1,'auto');
    hold(handles.axes1,'on');
    
    
    %Plot for sideway velocity, time x.001 to convert it to seconds
    plot(handles.axes2,.001.*x_,y2);
    title_ = strcat('Block',' ',num2str(1),': sideway position');
    title(handles.axes2,title_);
    axis(handles.axes2,'auto');
    hold(handles.axes2,'on');
    
    %Plot for yaw velocity, time x.001 to convert it to seconds
    plot(handles.axes3,.001.*x_,y3);
    title_ = strcat('Block',' ',num2str(block),': angle position');
    title(handles.axes3,title_);
    axis(handles.axes3,'auto');
    
    hold(handles.axes3,'on');
    
    %if ~isempty(fulldata{1,1})
        
        plot(handles.axes4,x,y);
        title(handles.axes4,'2D-map');
        xlabel(handles.axes4,'Forward position (mm)');
        ylabel(handles.axes4,'Sideway position (mm)');
        
        min_ = min(min(x),min(y));
        max_ = max(max(x),max(y));
        
        %if ~isnan(min_) & ~isnan(max_) & min_ < max_ 
            axis([min_ max_ min_ max_]);
            axis square;
        %end
    %end
    
    if strcmp(vel,'on')
        titles = {'Forward velocity','Sideway velocity','Yaw velocity'};
        y_axis = {'Velocity (m/s)','Velocity (m/s)','Velocity (degrees/s)'};
        setplotdescription(handles,titles,y_axis);
    else
        titles = {'Forward position','Sideway position','Yaw position'};
        y_axis = {'Position (mm)','Position (mm)','Position (degrees)'};
        setplotdescription(handles,titles,y_axis);
    end
  
end
    
