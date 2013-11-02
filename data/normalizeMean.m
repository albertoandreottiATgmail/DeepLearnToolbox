%Max normalization - move the range of the signal to the [-1, 1] range
%TODO: DC removal.
function normalized = normalizeMean(samples)
    
       average = 0.98;	
       peak = 2;
       normalized = (samples .- average)/(2*peak);

end