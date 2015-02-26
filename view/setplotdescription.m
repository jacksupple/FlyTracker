function [] = setplotdescription(handles,titles,y_axis)
%Creator: Kristian Johansson - kristian.johansson86@gmail.com
%Spring 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SETPLOTDESCRIPTION
%Function that sets the correct title and axis-labels for each plot
%corresponding to the selected plotting
%Input: handles - handles object beloning to the main window
%       titles - cell with titles for each of the three graphs
%       y_axis - cell with labels for each of the three graphs' y-axis

    title(handles.axes1,titles(1));
    xlabel(handles.axes1,'Time (s)');
    ylabel(handles.axes1,y_axis(1));

    title(handles.axes2,titles(2));
    xlabel(handles.axes2,'Time (s)');
    ylabel(handles.axes2,y_axis(2));

    title(handles.axes3,titles(3));
    xlabel(handles.axes3,'Time (s)');
    ylabel(handles.axes3,y_axis(3));
    
end

