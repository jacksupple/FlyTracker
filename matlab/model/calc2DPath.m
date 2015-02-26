function [x,y] = calc2DPath(data,block)
%Creator: Kristian Johansson - kristian.johansson86@gmail.com
%Spring 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CALC2DPATH Function that calculates a 2D path given delta coordinates for
%the fly

len = length(data{3,block});
x = zeros(1,len);
y = zeros(1,len);

if len > 0

    forward = data{1,block};
    side = data{2,block};
    yaw = cumsum(data{3,block});

    x(1) = forward(1);
    y(1) = side(1);

    for i=2:len

        x(i) = x(i-1)+cos(yaw(i-1))*side(i)-forward(i)*sin(yaw(i-1));
        y(i) = y(i-1)+sin(yaw(i-1))*side(i)+forward(i)*cos(yaw(i-1));
    end

end

x = transpose(x);
y = transpose(y);

end

