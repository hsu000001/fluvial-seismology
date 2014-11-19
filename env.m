function y=env(y);
% output envelope

% Courtesy Emily Brodsky
% uses hilbert function. tracks the power of the signal. 
% has phase information, preserves frequency information.

i=sqrt(-1); % just FYI I guess

yh=hilbert(y); % NOTE MATLAB MAKES THE ANAYLTIC SIGNAL IN ONE GO
y=abs(yh);
