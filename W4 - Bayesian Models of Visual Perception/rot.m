function rot(AZ,EL)
% rot(AZ,EL)
% Matlab 5 version of rot.m using cameratoolbar, see rot_matlab4 for older
% self-made rotation code for matlab 4 version
 
if nargin==2,
  view(AZ,EL);
end
cameratoolbar('setmode','orbit');

