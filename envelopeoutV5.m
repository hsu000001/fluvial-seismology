function[] = envelopeoutV4();

% 18 november 2014
% envelopeout: basic steps for examining seismic data downloaded from
% IRIS to get envelope, using Hilbert function
% v5 edits code for public consumption - more useful comments, removal of 
% derogatory comments, etc.

% 23 november 2010 lhsu
% make plots to see what is going on
% V3 uses env.m (hilbert), not envelope.m (matlab exchange, peaks)
% This gives one value, not up and down envelopes

% write it out in matlab instead of as text file
% 28 october 2010 lhsu

% (0) read .out file
% (a) butterworth filter for 1-10 hz 4 pole?
% (b) for hourly bins, find envelope, use hilbert fuction
% (c) write file: station year day hour envelope value (commented out)
% (d) plot

% required functions: env.m, readsac.m (Rob Porrit)

% open file to write out
% fid = fopen('envelopeout.txt', 'a+');

% navigate to directory with data
cd('/auto/proj/lhsu/data/sslb/2009/runmat');
pathname = pwd;

maxdata = (24*10) + 1; % 10 days (in hours)

list_files = dir('.');
%read each of those strings
%files = cellstr(list_files);

%get number of files
n = length(list_files);

for i = 8:8  % adjust this for the number of files, such as 1:n
    
    % create a matrix for the envelope values of correct size in hours
    envmat = NaN(maxdata, 1);   
    
    % parse some info out of the file name (files from IRIS)
    cd(pathname);
    name = list_files(i,1).name
    
    jday = name(6:8);
    jhour = name(10:11);
    jmin = name(13:14);
    
    station = name(24:30);
    
    [t,y,header] = readsac(name);
    % read in data using rob porrit's code

    y=y./1e9; % go from nm/s -> m/s 
    % this is in sac code but doesn't work
    
    dt=t(2)-t(1); % get delta t
    
    % apply butterworth filter to get 1-9 Hz
    % bandpass
    
    freq = 1/dt;
    
    Wn = [1/(freq/2) 9/(freq/2)]; %1-9 Hz window
    
    [b, a] = butter(2, Wn);
    
    filty = filtfilt(b,a,y);  % two pass filter
    
    % split into hours
    
    % how many points in one hour
    % 1 hr * 60 min/hr * 60 sec/min * (freq) pts/sec
 
    numptshour = 1*60*60*freq;
    
    k = 1;
    
    for j = 1:numptshour:length(y)
    
        hour = int8((j-1)/numptshour);     
       
        if j+numptshour < length(y)
            
            endindex = (j+numptshour)-1;
            
            dat = filty(j:(int32(endindex)));      
        else
            break
        end
         
        % find envelope value
        [envvalue] = env(dat);
        
        % calculate hourly mean value of the envelope
        envmean = nanmean(envvalue);
                
        %envmat(k,1) = cellstr(jday);
        %envmat(k,2) = cellstr(hour);
        envmat(k,1) = envmean;
       
        k = k+1;
    % write out
    %    fprintf(fid, '%s, %s, %s, %d, %12.6e, %12.6e\n', ...
    %        name, station, jday, hour, upmean, downmean); 
    
    %     h = figure;
    %     
    subplot(3,1,1)
      plot(y)
    subplot(3,1,2)
      plot(filty)
    subplot(3,1,3)
      plot(envmat)

    end
%     cd('/auto/proj/lhsu/output/envelopeplot/2009sslb');
%     save([name 'env.mat'],'envmat');   
    
    
    %print(h, '-djpeg');
      
    clear envmat;
end

%status = fclose('all');
   
    
end