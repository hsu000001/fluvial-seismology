function y=env(y);
% output envelope

% Courtesy Emily Brodsky

i=sqrt(-1);

yh=hilbert(y); % NOTE MATLAB MAKES THE ANAYLTIC SIGNAL IN ONE GO
y=abs(yh);
