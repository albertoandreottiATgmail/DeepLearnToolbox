function [ CC, FBE, frames ] = mfcc( speech, fs, Tw, Ts, alpha, window, R, M, N, L )
% mfcc routine is not part of this toolbox 
% You can find this online here,
% http://www.mathworks.com/matlabcentral/fileexchange/32849-htk-mfcc-matlab
% Install it and put it in your path.

error( sprintf('\nTo use this routine you will have to download \nand install the MFCC toolbox from: \nhttp://www.mathworks.com/matlabcentral/fileexchange/32849-htk-mfcc-matlab\nPlease remember to remove the placeholder file once you install the toolbox.') );