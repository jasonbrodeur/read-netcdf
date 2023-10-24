 %  MATLAB script  to inquire about variable names and read in all variables
%  from a netcdf file.  Uses native netcdf support in MATLAB 
%
%  Usage:  

% nc_readall
%
%  Warning: this reads in variables and assigns them to the same variable name in MATLAB as in the netcdf file
%           does not handle udunits, so time coordinate typically needs to be modified for use in MATLAB. 
%
% oid  file name or URL to a netcdf file

%%% One-time -- provide information on nc file structure
% oid='precip.mon.ltm.1x1.v7.1981-2010.nc';
% [pathstr, name, ext] = fileparts(oid);
% f = ncinfo(oid);
% nvars = length(f.Variables);
% for k = 1:nvars
%    varname=f.Variables(k).Name;
%    disp(['Reading:  ' varname]);
%    eval([varname ' = ncread(''' oid ''',''' varname ''');']);
% end

%% Loop through all .nc files in the directory and turn into monthly files.
%%% Identify all nc files
d = dir([pwd '\*.nc']);

for i = 1:1:length(d)
    oid = d(i).name; % name of nc file
    [pathstr, name, ext] = fileparts(oid); % split into name and extension
    %%% Load the file
    f = ncinfo(oid);
    nvars = length(f.Variables);
    for k = 1:nvars
        varname=f.Variables(k).Name;
        disp(['Reading:  ' varname]);
        eval([varname ' = ncread(''' oid ''',''' varname ''');']);
    end

    %%% Loop through all months - export excel and csv files for each month
    for j = 1:1:size(precip,3)
        tmp = [];
        tmp(2:size(lat,1)+1,1) = lat;
        tmp(1,2:size(lon,1)+1) = lon;
        tmp(2:size(lat,1)+1,2:size(lon,1)+1) = precip(:,:,j)';
        writematrix(tmp,[name '-mon' num2str(j) '.xlsx' ])
        writematrix(tmp,[name '-mon' num2str(j) '.csv' ])

    end
    clear lat long
end