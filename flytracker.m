function [] = flytracker()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

temp = mfilename('fullpath');
%Produce multiple mouse cursors for the sensors so that the desktop mouse is usable
%If errors are discovered check that the id of the mice are still valid
cmd = ['bash ',temp(1:end-10),'multimouse.sh'];
system(cmd);
MainApp;

end

