function [data] = readData(handles,filename, mode)
%READDATA
%Reads data from temporary data files and store it in appropriate manner.
%The handles sent with it is that of the GUI so data also can be plotted in
%the main window.
%The filename is that of the file that all data will be written to
%**************************************************************************
%Precondition: data is saved to text as JSON-strings of python dictionaries
%or matlab structs. Any structue which are initialized with the same syntax
%would work however as long as the string representation is the same

tic;

fid = NaN;

freq = 100;
running = true;
setappdata(0,'running',running);
size_ = [0,1];
newBlock = false;
nr_ = 1;

output = '';
p = getpath('tempdata.txt','data');
%p = getpath('tempdata/tempdata0.txt','data');

%Init data cells
fulldata = cell(4,1);
data = cell(6,1);

while ~exist(p,'file') && running
    running = getappdata(0,'running');
    
    %Pause to be able to listen for stop-btn
    pause(.001);
end

if exist(p,'file')
    fid = fopen(p,'r');
end

if strcmp('recovery',mode)
    n = 0;
    tline = fgetl(fid);
    
    while ischar(tline)
        tline = fgetl(fid);
        n = n+1;
    end
    
    fclose(fid);
    fid = fopen(p,'r');
    
    waitbar_ = waitbar(0,'Please wait...');
    steps = n;
    step = 0;
end

while running
    
    output = '';
    a = 0;
    
    %100 is the number of samples plotted at the same time, slightly
    %arbitrary number but can be changed. Lower will mean a more continous
    %flow but demands more resources and vice versa
    while a < freq
        a = a+1;
        chunk = fgets(fid);
        
        if strfind(chunk,'kill')
            break
        elseif strfind(chunk,'quit')
            [~,temp] = calcdata(output,mode);
            newBlock = true;
            
            %if cumsum(fulldata{1,1}) == 0 | cumsum(fulldata{2,1}) == 0
            %    errordlg('One of the sensors did not record any data so the current block was not saved');
            %    for i=1:4
            %        data{i,1} = [0];
            %    end
            %else
                index = size(data);
                
                for j=1:4
                    data{j,index(2)} = [fulldata{j,1},temp{j,1}];
                    data{j,index(2)+1} = [];
                end
                              
                if ~strcmp(mode,'recovery') && get(handles.cbmerge,'value')
                    stim = mergeClient(10000);
                    data{6,index(2)} = stim;
                    
                end
                
                fulldata = cell(4,1);
                output = '';
            %end
            break;
        elseif strfind(chunk,'pause')
            [~,temp] = calcdata(output,mode);
            newBlock = true;
            
%             if cumsum(fulldata{1,1}) == 0 | cumsum(fulldata{2,1}) == 0
%                 errordlg('One of the sensors did not record any data so the current block was not saved');
%                 for i=1:4
%                     data{i,1} = [0];
%                 end
%             else
                index = size(data);
                
                for j=1:4
                    data{j,index(2)} = [fulldata{j,1},temp{j,1}];
                    data{j,index(2)+1} = [];
                end
                              
                fulldata = cell(4,1);
                output = '';
%            end
            break;
        end
            
        if chunk ~= -1 
            output = strcat(output,chunk);
            
            if newBlock
                cla(handles.axes1);
                cla(handles.axes2);
                cla(handles.axes3);
                cla(handles.axes4);
                newBlock = false;
            end       
            
        else
            %Pause to be able to listen for stop-btn as matlab lacks threading
            pause(0.001);
        end
        
        if strfind(chunk,'newfile')
            nextfile = ['tempdata/tempdata',int2str(nr_),'.txt'];
            p = getpath(nextfile,'data');
            
            if exist(p,'file')
                fid = fopen(p,'r');
                nr_ = nr_ + 1;
            end
        end
        
        if strcmp(mode,'recovery') & chunk == -1
            running = false;
            setappdata(0,'running',running);
        end
    end
        
    [~,temp] = calcdata(output,mode);   
    
    
    if strcmp('recovery',mode)
        %close(waitbar_);
        %waitbar_ = waitbar(0,'Please wait...');
        step = step+freq;
        if step < steps
            waitbar(step/steps,waitbar_);
        end
    end
    
    fulldata{1,1} = [fulldata{1,1},temp{1,1}];
    fulldata{2,1} = [fulldata{2,1},temp{2,1}];
    fulldata{3,1} = [fulldata{3,1},temp{3,1}];
    fulldata{4,1} = [fulldata{4,1},temp{4,1}];
    
    %For determining which block is being plotted
    size_ = size(data);
    
    if ~strcmp(mode,'calibration')
        displaydata(fulldata,handles,1,freq,'noteven');
    end
    
    if strfind(chunk,'kill')
        break
    end
    
    running = getappdata(0,'running');
end 

% if isempty(data{1,1})
%     data = fulldata;
% end

if isempty(data{5,end})% || data{5,end} == -1
    data = data(1:6,1:end-1);
end

%If merging is activated the data file should be correlated with its
%corresponding parameter data retrieved from flyfly. 
if ~strcmp(mode,'recovery') 
    
    if getappdata(0,'merge')
        data = corrData(data);
        data = reformatData(data);
    end
    
else
    close(waitbar_);    
end

%If recording was aborted before data could be recorded fid is NaN
if ~isnan(fid) 
    fclose(fid);
    
    %Fetch and save block starting times
    fid = fopen(getpath('blocktime.txt','data'),'r');
    
    size_ = size(data);
    blocks = size_(2);
   
    for k=1:blocks
        line = fgets(fid);
        data{5,k} = line;
    end
    
    fclose(fid);
    
    if ~strcmp(mode,'calibration')
        
        config = getappdata(0,'config');
        
        if config.forwardAxis == 2
            temp1 = data{1,1};
            data{1,1} = data{2,1};
            data{2,1} = temp1;
        end
        
        save(filename,'data');
        setappdata(0,'data',data);

        temp = cell(1,blocks);

        for i=1:blocks        
            temp{1,i} = strcat('Block ',num2str(i));
        end

        set(handles.pop,'visible','on');
        set(handles.pop,'String',temp);
        set(handles.pop,'Value',blocks);
    end    
end

delete(getpath('blocktime.txt','data'));
delete(getpath('tempdata.txt','data'));
%rmdir(getpath('tempdata','data'));

t_ = toc;

['Elapsed recording time is ',num2str(t_),' seconds']

end