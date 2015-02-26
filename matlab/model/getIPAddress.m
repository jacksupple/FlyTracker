function ip = getIPAddress()
%Creator: Kristian Johansson - kristian.johansson86@gmail.com
%Spring 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Simple function for finding ip address of localhost.
    %Returns IP address as string
    
    [~,result] = system('ifconfig');
    
    starting = strfind(result,'inet addr:');
    ending = strfind(result,'  Bcast');
    
    start = starting(1)+length('inet addr:');
    
    ip = result(start:ending(1)-1);
end
