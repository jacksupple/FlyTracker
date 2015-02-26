function [path] = getpath(file,folder)
%%Creator: Kristian Johansson - kristian.johansson86@gmail.com
%%Spring 2014
%Returns correct path for given file and type, only the relative paths are
%hardcoded because they are not subjects of change

tmp = mfilename('fullpath'); %Returns path of current m-file

prefixpy = [tmp(1:end-length(mfilename)),'python/'];
prefixview = [tmp(1:end-length(mfilename)),'matlab/view/'];
prefixmodel = [tmp(1:end-length(mfilename)),'matlab/model/'];
prefix = [tmp(1:end-length(mfilename)),'data/'];
prefiximg = [tmp(1:end-length(mfilename)),'images/'];

if strcmp(folder,'py')
    path = [prefixpy,file];
elseif strcmp(folder,'view')
    path = [prefixview,file];
elseif strcmp(folder,'model')
    path = [prefixmodel,file];
elseif strcmp(folder,'data')
    path = [prefix,file];
elseif strcmp(folder,'img')
    path = [prefiximg,file];
elseif strcmp(folder,'')
    path = [tmp(1:end-length(mfilename)),file];
end

end

