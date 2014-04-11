function stopAction(handles)
%Function for stopping DAQ.py  

    setappdata(0,'running', false);
        
    %Code for communicating with python process
    fid = fopen(getpath('pipe','data'),'w');
    fwrite(fid,'quit');      %Write quit command to the pipe
    fclose(fid);             %Close pipe
            
    %Clean up, deleting the pipe
    arg = ['rm -f ',getpath('pipe','data')];
    system(arg);
    
    set(handles.run_btn,'String','Run');
    drawnow;

end

