function res = isEyeCal(varargin)
%isEyeCal Checks if ini file in current directory is from a Eye Cal session
%   RES = isEyeCal checks the INI file in the current directory and 
%   returns 1 if it is an eye calibration session and 0 otherwise. By
%   default it assumes the .ini suffix is in lowercase. 
%
%   RES = isEyeCal(FILENAME) checks the file name FILENAME to see it 
%   it is an eye calibration session. Wildcards can also be used in
%   FILENAME.
%      e.g. res = isEyeCal('disco09050201.INI')
%   checks the specified file.
%      e.g. res = isEyeCal('*.INI')
%   checks files in the local directory with a .INI suffix.
%
%   Dependencies: None.

files = '*.ini';

if nargin > 0
	files = varargin{1};
end

[s,w] = system(['grep Calibration ' files]);

if s == 0
	res = 1;
else
	res = 0;
end
