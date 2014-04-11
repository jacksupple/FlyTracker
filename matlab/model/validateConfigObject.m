function [ valid ] = validateConfigObject(config)
%Function that validates the config object to make sure that all necessary
%fields are set and that all values are within in their domain. This to make sure
%that an experiment cant be run without a correct configuration
%
%Returns True if valid, False otherwise

    valid = true;
    
    %Port must be a number above 1024 and lower than 65536, savepath must
    %be a valid directory. Mice.txt must exist as that holds map for which
    %mouse is which
    try
        valid = (config.port < 65536) && (config.port >1024) && exist(config.savepath,'dir') && exist('mice.txt','file');
    catch e
        valid = false;
    end
end

