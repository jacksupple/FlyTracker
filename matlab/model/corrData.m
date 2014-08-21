function [data] = corrData(data)
%Function for correlating blocks of data to the corresponding parameter
%file. 

size_ = size(data);

%Checking each datablock if there is a parameter file associated with it,
%if not it means that the later one has the parameter for the current
%block. %When parameters are split, it only separate the oldest block as it
%is done iteratively backwards so that there is no need to keep track of
%how many blocks there might be in one param file
for i=size_(2):-1:1
    if isempty(data{6,i})
        data = splitParams(data,i);
    end
end

end

%separate the last block of the parameter variable. Return the updated 
function [data] = splitParams(data,index)

    param = data{6,index+1};
    
    size_ = size(param.stim.layers);
    numLayers = size_(2);
    
    size_ = size(param.stim.layers(1).Param);
    numTrials = size_(2);
    
    currentBlock = param;
    prevBlock = param;
    done = false;
    
    for i=1:numLayers
        for j=numTrials-1:-1:1
            if param.stim.layers(i).Param(j).PauseTime > 0
                
                for k=1:numLayers
                    currentBlock.debug.stimulus.layers(k).settings = currentBlock.debug.stimulus.layers(k).settings(1:j); 
                    prevBlock.debug.stimulus.layers(k).settings = prevBlock.debug.stimulus.layers(k).settings(1:j); 
                    
                    currentBlock.stim.layers(k).settings = currentBlock.stim.layers(k).settings(1:j); 
                    prevBlock.stim.layers(k).settings = prevBlock.stim.layers(k).settings(1:j); 
                                        
                    currentBlock.stim.layers(k).Param = currentBlock.stim.layers(k).Param(1:j);
                    prevBlock.stim.layers(k).Param = prevBlock.stim.layers(k).Param(j+1:end);
                end
                
                done = true;
                break;
            end
        end
        
        if done
            break;
        end
        
    end

    data{6,index} = currentBlock;
    data{6,index+1} = prevBlock;
end
