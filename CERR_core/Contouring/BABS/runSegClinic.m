function success = runSegClinic(inputDicomPath,outputDicomPath,sessionPath,algorithm,varargin)
% function success = runSegClinic(inputDicomPath,outputDicomPath,sessionPath,algorithm,varargin)
%
% This function serves as a wrapper for different types of segmentations.
%
% INPUT: 
% inputDicomPath - path to input DICOM directory which needs to be segmented.
% outputDicomPath - path to write DICOM RTSTRUCT for resulting segmentation.
% sessionPath - path to write temporary segmentation metadata.
% algorithm - string which specifies segmentation algorith
% varargin - additional algorithm-specific inputs
%
% Following directories are created within the session directory:
% --- ctCERR: contains CERR file/s of input DICOM.
% --- segmentedOrigCERR: CERR file with resulting segmentation fused with 
% original CERR file.
% --- segResultCERR: CERR file with segmentation. Note that CERR file can
% be cropped based on initial segmentation.
%
% EXAMPLE: to run BABS segmentation
% inputDicomPath = '';
% outputDicomPath = ''; 
% sessionPath = '';
% algorithm = 'BABS';
% babsPath = '';
% success = runSegClinic(inputDicomPath,outputDicomPath,sessionPath,algorithm,babsPath);
%
%
% APA, 12/14/2018


% Create session directory to write segmentation metadata
dateTimeV = clock;
randNum = 1000.*rand;
sessionDir = ['session',num2str(dateTimeV(4)), num2str(dateTimeV(5)),...
    num2str(dateTimeV(6)), num2str(randNum)];

fullSessionPath = fullfile(sessionPath,sessionDir);

% Create directories to write CERR files
mkdir(fullSessionPath)
cerrPath = fullfile(fullSessionPath,'ctCERR');
mkdir(cerrPath)
outputCERRPath = fullfile(fullSessionPath,'segmentedOrigCERR');
mkdir(outputCERRPath)
segResultCERRRPath = fullfile(fullSessionPath,'segResultCERR');
mkdir(segResultCERRRPath)

% Import DICOM to CERR
importDICOM(inputDicomPath,cerrPath);

switch algorithm
    
    case 'BABS'        
        
        babsPath = varargin{1};
        success = babsSegmentation(cerrPath,fullSessionPath,babsPath,segResultCERRRPath);
        
        
    case 'MRIprostDeepLabV3'
        
        
end

% Export the RTSTRUCT file
exportCERRtoDICOM(cerrPath,segResultCERRRPath,outputCERRPath,outputDicomPath)

% Remove session directory
rmdir(fullSessionPath, 's')

