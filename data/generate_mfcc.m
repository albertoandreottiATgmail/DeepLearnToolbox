%this script will crawl the MFCC data from VoxForge to generate the en_de_it.mat file 
%containing MFCCs for the three languages English, Deutsch and Italian.
%this file assumes VoiceBox is in your Octave/Matlab's path.

en_endpoint = 'http://www.repository.voxforge1.org/downloads/SpeechCorpus/Trunk/Audio/Original/44.1kHz_16bit/';
de_endpoint = 'http://www.repository.voxforge1.org/downloads/de/Trunk/Audio/Original/48kHz_16bit/';
it_endpoint = 'http://www.repository.voxforge1.org/downloads/it/Trunk/Audio/Original/48kHz_16bit/';
endpoint = de_endpoint;
%with data so far, 700 -> it, 450 -> de, 90 -> en
%mean, std: (0.85, 0.93)-> it,(0.95,0.98)-> de , (1.16, 1.35) -> en
limit = 450;

flist = urlread(endpoint);

[s,e] = regexp(flist, ">([a-zA-Z0-9]*-[a-zA-Z0-9]*)+\.tgz<");
%truncate the amount of data to be crawled
s = s(1:min(limit, size(s,2)));
e = e(1:min(limit, size(s,2)));

confirm_recursive_rmdir(0)
filename = "de.mat";
    
function data = fetch_data(flist, endpoint, anfang, ende, id)
    
    Tw = 25;           % analysis frame duration (ms)
    Ts = 8.33;         % analysis frame shift (ms)
    alpha = 0.97;      % preemphasis coefficient
    R = [20 3500];    % frequency range to consider
    M = 39;            % number of filterbank channels 
    C = 39;            % number of cepstral coefficients
    L = 55;            % cepstral sine lifter parameter
       
    % hamming window (see Eq. (5.2) on p.73 of [1])
    hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));

    %print(int2str(id));  
    %at each step fetch a file from the corpus
    currfile = flist(anfang + 1: ende - 1);
    currdir = strcat("temp", int2str(id));
    cd('/home/ubuntu/DeepLearnToolbox/data'); 
    mkdir(currdir);cd(currdir);
    data = zeros(C, 1);
    status = urlwrite(strcat(endpoint, currfile), currfile);
 	
    read_size = 0;
    %Unzip the mfc files to temp dir and add them to the dataset.
    %TODO: only working in Linux?.
    untar(currfile); cd(currfile(1:end-4)); 
	
    a = fileattrib ('wav');
    b = fileattrib ('flac');
    
    if (a) 
	    cd wav;
	    mfcs = ls("*.wav");
    elseif(b)
	    cd flac;
	    system('sh ~/DeepLearnToolbox/convToWav.sh')
	    mfcs = ls("*.wav");
    end
    
    for j=1:size(mfcs,1)
        
        % Read speech samples, sampling rate and precision from file
        [speech, fs, nbits ] = wavread(strtrim(mfcs(j, :)));
	       
        % Feature extraction (feature vectors as columns)
        [MFCCs, FBEs, frames ] = mfcc(normalizeMax(speech), fs, Tw, Ts, alpha, hamming, R, M, C, L );

	 %Check that the computed values are healthy
        if (sum(sum(isnan(FBEs)))==0 && max(max(FBEs))<70 && min(min(FBEs))>-70)
            data = [data, FBEs];
        end

    end
    cd ../../..
    rmdir(currdir, "s");
end

%here goes what to put in the output when the function fails.
function retcode = eh(error)
    a = error
    dbstack
    %cd ../../..
    retcode = zeros(26,1);	
end

mfccs = pararrayfun(numWorkers = 15,
                    @(anfang, ende, id)fetch_data(flist, endpoint, anfang, ende, id), %currying with anonym funct
                    s, e, 1:size(s,2), %parameters for the function
                    "ErrorHandler" , @eh);

read_size = size(mfccs)
rmdir('temp*', "s");
save("-mat4-binary", filename, "mfccs");