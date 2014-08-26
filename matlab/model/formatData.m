function [data_new] = formatData(data,k)
% %UNTITLED Summary of this function goes here
% %   Detailed explanation goes here
% 
% %% basic parametres
% size_ = size(data); %size of dada from trackfly; size(2) - number of coulumns based on number of trials
% experiment_time = 3000; %in msec (based on stimuli in flyfly); in flyfly data are frames (data in frames/160 = data in seec) 
% delta = 000; %delta (for the case of mistake in experiment_time calculation)
% stimuli_time = experiment_time+delta; 
% data_new = cell(4,1);
% 
% %% parametres taken from flytrack
% data_time = data{4,k};
% data_forward = data{1,k};
% data_ss = data{2,k};
% data_yaw = data{3,k};
% 
% %% zeros-vectors creation based on stimuli time
% time_vector = zeros(1,stimuli_time);
% forward = zeros(1,stimuli_time);
% ss = zeros(1,stimuli_time);
% yaw = zeros(1,stimuli_time);
% 
% %% retiming
% counter=find(data_time);
% time_vector(round(data_time(counter))+1)=(data_time(counter));
% 
% % Karin edit May'2014 (first element ==0)
% % Olga edit June'2014 (new counter)
% if data_time(1)==0
%     forward(round(data_time(counter))+1) = data_forward(2:length(data_forward)); %put a forward position in a right place in forward vector
%     ss(round(data_time(counter))+1) = data_ss(2:length(data_ss)); %put a ss position in a right place in forward vector
%     yaw(round(data_time(counter))+1) = data_yaw(2:length(data_yaw)); %put a yaw position in a right place in forward vector
% else 
%     forward(round(data_time(counter))+1) = data_forward;
%     ss(round(data_time(counter))+1) = data_ss;
%     yaw(round(data_time(counter))+1) = data_yaw;
% end
% 
% length(data_forward)
% length(forward)
% length(counter)
% % end Karin edit
% 
% %% calculation of a cumulative sum of elements in vectors
% time = cumsum(time_vector);
% forward = cumsum(forward);
% ss = cumsum(ss);
% yaw = cumsum(yaw);
% 
% %% create a matrix with retimed data for saving
% 
% data_new{1,1} = forward;
% data_new{2,1} = ss;
% data_new{3,1} = yaw;
% data_new{4,1} = time_vector;

end
