function [message] = mergeClient(port)
%Creator: Kristian Johansson - kristian.johansson86@gmail.com
%Spring 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This is a client application that reads and the converts the parameter
%data sent from flyfly. If flyfly is not used as software for generating
%visual stimuli the following demands are set on the parameter format:
%Struct object with fields that are either struct, numerical, logical or
%function handle
    
    import java.net.Socket
    import java.io.*
    
    %Make sure this is the same host address as the computer that holds
    %flyfly
    host = '130.238.33.123';
    
    number_of_retries = 20;
    retry = 0;
    input_socket = [];
    message = [];

    fprintf(1,'Connecting to FlyFly...\n');
    
    %% Opens up a socket that reads the parameter data
    while true
       
        retry = retry + 1;
                
        if ((number_of_retries > 0) && (retry > number_of_retries))
            fprintf(1, 'Too many retries\n');
            break;
        end
        
        try
            % throws if unable to connect
            input_socket = Socket(host, port);
            
            % get a buffered data input stream from the socket
            input_stream   = input_socket.getInputStream;
            d_input_stream = DataInputStream(input_stream);
            
            pause(2);
            % read data from the socket - wait a short time first
            bytes_available = input_stream.available;
                        
            fprintf(1, 'Reading %d bytes\n', bytes_available);
            
            message = zeros(1, bytes_available, 'uint8');
            i = 1;
            while input_stream.available > 0
                message(i) = d_input_stream.readDouble;
                i = i+1;
            end
            
            input_socket.close;
            
            % cleanup
            input_socket.close;
            disp('Parameter merging was successfull!');
            break;
             
        catch e
            e.message;
            if ~isempty(input_socket)
                input_socket.close;
            end
            
            % pause before retrying
            pause(1);
        end
    end
    
    %Converting the byte array to a nested matlab struct
    message = deserialize(transpose(message));
    
    %Display so the user know when deserialzation is done
    disp(message);
end