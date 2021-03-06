function startup_GISMO(gismopath)
% STARTUP_GISMO recursively adds paths for contributed codes that build on
% the GISMO suite. If the Antelope toolbox is already in the Matlab path,
% then the codes with Antelope dependencies are added as well.
%
% To add new paths to the contributed archives please
% read 'contributed_style_guide.txt' in the GISMO directory.

% Author: Michael West, Geophysical Institute, Univ. of Alaska Fairbanks
% Modified: Glenn Thompson Aug 2015 onwards

% CHECK COMPATIBILITY
% Should consider added a compatibility checkign mechanism at some point. 
% Not clear how best to do this. But given that GISMO uses features from
% recent releases and add-on toolboxes, it would be great to give users a
% heads up about such.


% GET PATHS TO DIRECTORIES IN GISMO
if ~exist('gismopath', 'var')
	%gismofile = which('GISMO/startup_GISMO');
	gismofile = which('startup_GISMO');
	gismopath = fileparts(gismofile); % first argout is the path
end

% ADD PATH TO CORE
addpath(fullfile(gismopath,'core'));

% ADD PATH TO PREVIOUS CORE - Commented out by CROWELL, no such path
% addpath(fullfile(gismopath,'core','deprecated'));

% ADD A PATH TO EACH DIRCTORY IN CONTRIBUTED
addContributed(gismopath,'contributed');

% ADD A PATH TO EACH DIRECTORY IN CONTRIBUTED_ANTELOPE
if exist('dbopen','file') && exist('trload_css','file'); %  test for antelope
  addContributed(gismopath,'contributed_antelope');
end

% ADD A PATH TO EACH DIRCTORY IN UAF_INTERNAL
addContributed(gismopath,'uaf_internal');

% ADD A PATH TO APPLICATIONS e.g. IceWeb
addpath(genpath(fullfile(gismopath,'applications')));

% ADD A PATH TO JAR FILES
javaaddpath(fullfile(gismopath,'contributed','iris_dmc_tools','IRIS-WS-2.0.15.jar'))
javaaddpath(fullfile(gismopath,'core','swarm.jar'))

% ADD PATH TO GISMO LIBRARY FUNCTIONS
addpath(fullfile(gismopath, 'libgismo'));

% ADD PATH TO TESTS
addpath(fullfile(gismopath, 'tests'));

%%
function addContributed(gismopath, contribDir)
% add each subdirectory within gismopath/contribDir/ to the matlab path
dirlist = dir(fullfile(gismopath,contribDir,''));
dirlist = removeHiddenFiles(dirlist);
addpath(fullfile(gismopath,contribDir));
for n = 1:numel(dirlist)
  subdir = dirlist(n).name;
  newpath = fullfile(gismopath,contribDir, subdir,'');
  if ~isdir(newpath), continue, end  %don't add loose files to the path
  if subdir(1)=='+', continue, end % don't add package directories
  addpath(newpath);
  
  disp(['Adding path:  ' newpath]);
end


function directoryList = removeHiddenFiles(directoryList)
%removes files that start with '.', which also includes '.', and '..'
startsWithPeriod = strncmp('.',{directoryList.name},1);
directoryList = directoryList(~startsWithPeriod);

