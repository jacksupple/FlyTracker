function [data] = formatData(data)
%Reformats the data such data the time intervall between each datapoint is
%made equal

size_ = size(data);

for k=1:size_(2)

    data_time = data{4,k};
    data_forward = data{1,k};
    data_ss = data{2,k};
    data_yaw = data{3,k};
    param = data{6,k};
    
    %%Find stimuli time
    tempSize = size(param.stim.layers);
    numLayers = tempSize(2);
    
    tempSize = size(param.stim.layers(1).Param);
    numTrials = tempSize(2);
    
    totTime = 0;
    
    for i=1:numLayers
        for j=1:numTrials
            tempTime = param.stim.layers(i).Param(j).Time+param.stim.layers(i).Param(j).PreStimTime+param.stim.layers(i).Param(j).PostStimTime;
        end
        if tempTime > totTime
            totTime = tempTime;
        end
    end
    
    stimuli_time = totTime*1000/160;
    
    %% zeros-vectors creation based on stimuli time
    time_vector = zeros(1,stimuli_time);
    forward = zeros(1,stimuli_time);
    ss = zeros(1,stimuli_time);
    yaw = zeros(1,stimuli_time);



    %% retiming
    counter=find(data_time);
    time_vector(round(data_time(counter))+1)=(data_time(counter));

    % Karin edit May'2014 (first element ==0)
    % Olga edit June'2014 (new counter)
    if data_time(1)==0
        forward(round(data_time(counter))+1) = data_forward(2:length(data_forward)); %put a forward position in a right place in forward vector
        ss(round(data_time(counter))+1) = data_ss(2:length(data_ss)); %put a ss position in a right place in forward vector
        yaw(round(data_time(counter))+1) = data_yaw(2:length(data_yaw)); %put a yaw position in a right place in forward vector

    else 
        forward(round(data_time(counter))+1) = data_forward;
        ss(round(data_time(counter))+1) = data_ss;
        yaw(round(data_time(counter))+1) = data_yaw;
    end
    
    data{1,k} = forward;
    data{2,k} = ss;
    data{3,k} = yaw;
    data{4,k} = time_vector;
    
end
    
    
end

