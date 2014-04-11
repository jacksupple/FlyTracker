function [data] = readData(handles,filename, mode)
%READDATA
%Reads data from temporar data files and store it in appropriate manner.
%The handles sent with it is that of the GUI so data also can be plotted in
%the main window.
%The filename is that of the file that all data will be written to
%**************************************************************************
%Precondition: data is saved to text as JSON-strings of python dictionaries
%or matlab structs. Any structue which are initialized with the same syntax
%would work however as long as the string representation is the same

tic;

fid = NaN;

running = true;
setappdata(0,'running',running);

output = '';
p = getpath('tempdata.txt','data');

%Init data cells
fulldata = cell(4,1);
data = cell(5,1);

while ~exist(p,'file') && running
    running = getappdata(0,'running');
    %Pause to be able to listen for stop-btn as matlab lacks threading
    pause(.001);
end

if exist(p,'file')
    fid = fopen(p,'r');
end

while running
    
    output = '';
    a = 0;
    
    %100 is the number of samples plotted at the same time, slightly
    %arbitrary number but can be changed. Lower will mean a more continous
    %flow but demands more resources and vice versa
    while a < 100
        a = a+1;
        chunk = fgets(fid);
        
        if strfind(chunk,'kill')
            break
        elseif strfind(chunk,'pause')
            [~,temp] = calcdata(output,mode);
            
            if cumsum(fulldata{1,1}) == 0 | cumsum(fulldata{2,1}) == 0
                errordlg('One of the sensors did not record any data so the current block was not saved');
                for i=1:4
                    data{i,1} = [0];
                end
                
%                 data{1,1} = [0];
%                 data{2,1} = [0];
%                 data{3,1} = [0];
%                 data{4,1} = [0];
            else
                
                if isempty(data{1,1})
                    for k=1:4
                        data{k,1} = [fulldata{k,1},temp{k,1}];
                    end
%                     data{1,1} = [fulldata{1,1},temp{1,1}];
%                     data{2,1} = [fulldata{2,1},temp{2,1}];
%                     data{3,1} = [fulldata{3,1},temp{3,1}];
%                     data{4,1} = [fulldata{4,1},temp{4,1}];
                else
                    index = size(data);                
                    
                    for j=1:4
                        data{j,index(2)+1} = [fulldata{j,1},temp{j,1}];
                    end
                    
%                     data{1,index(2)+1} = [fulldata{1,1},temp{1,1}];
%                     data{2,index(2)+1} = [fulldata{2,1},temp{2,1}];
%                     data{3,index(2)+1} = [fulldata{3,1},temp{3,1}];
%                     data{4,index(2)+1} = [fulldata{4,1},temp{4,1}];
                end

                fulldata = cell(4,1);
                output = '';
            end
            break;
        end
            
        if chunk ~= -1 
            output = strcat(output,chunk);
        else
            %Pause to be able to listen for stop-btn as matlab lacks threading
            pause(0.001);
        end
        
        if strcmp(mode,'recovery') & chunk == -1
            running = false;
            setappdata(0,'running',running);
        end
    end
        
    [~,temp] = calcdata(output,mode);    
    
    fulldata{1,1} = [fulldata{1,1},temp{1,1}];
    fulldata{2,1} = [fulldata{2,1},temp{2,1}];
    fulldata{3,1} = [fulldata{3,1},temp{3,1}];
    fulldata{4,1} = [fulldata{4,1},temp{4,1}];
    
    %For determining which block is being plotted
    size_ = size(data);
    
    if ~strcmp(mode,'calibration')
        displaydata(fulldata,handles,size_,1);
    end
    
    if strfind(chunk,'kill')
        break
    end
    
    running = getappdata(0,'running');
    
end 

if isempty(data{1,1})
    data = fulldata;
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

t_ = toc;

['Elapsed recording time is ',num2str(t_),' seconds']

end