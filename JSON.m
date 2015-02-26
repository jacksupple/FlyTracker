classdef JSON < handle
    % v = JSON.parse(jsonString) converts a JSON string to a MATLAB value.
    %
    % This started out as a recursive descent parser, but JSON is so simple
    % that most of the parser collapsed out.
    %
    % In the service of speed, simplicity, and laziness, this code is NOT a
    % validator. Its purpose is to convert correct JSON strings to MATLAB
    % values. It does not reject all malformed JSON.
    
    % Copyright 2013 The MathWorks, Inc.
    
    % Edited by Kristian Johansson March 2014
    % Removed most of the code due to it being incredibly slow, it is no
    % longer a multipurpose json-parser but only parse strings of the
    % structure: {var1:param1,var2:param2....}, dict objects in Python for
    % example    
    
    properties (Access = private)
        json % the string
        index % position in the string
    end
    
    methods(Static)
        % This is the one method you should call from outside the file.
        % JSON.parse(string)... that should be familiar to Javascrpt
        % programmers
        
        %Converts json-string to struct
        function value = parse(JSONstring)
            string_ = JSONstring(2:end-1);
            
            commas = strfind(string_,',');
            vars = cell(2,length(commas)+1);
            
            temp = string_(1:commas(1)-1);
            colon = strfind(temp,':');
            vars{1,1} = temp(2:colon(1)-2);
            vars{2,1} = temp(colon(1)+1:end);
            
            for i=2:length(commas)
                temp = string_(commas(i-1)+1:commas(i)-1);
                colon = strfind(temp,':');
                vars{1,i} = temp(3:colon(1)-2);
                vars{2,i} = temp(colon(1)+1:end);
            end
            
            temp = string_(commas(length(commas))+1:end);
            colon = strfind(temp,':');
            vars{1,length(commas)+1} = temp(3:colon(1)-2);
            vars{2,length(commas)+1} = temp(colon(1)+1:end);
            
            value = struct;
            
            for i=1:length(commas)+1
                value.(vars{1,i}) = str2double(vars{2,i});                
            end        
        end
    end
    
end
