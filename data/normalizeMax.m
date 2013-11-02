%Max normalization - move the range of the signal to the [-1, 1] range

function normalized = normalizeMax(samples, fs)
    
	%DC removal
    samples = filter([1 -1], [1 -0.95], samples);
    
	[vals, ~] = sort(samples);
	%Take the average of the top 5
	k = 5;
    normalized = samples/mean(vals(end-k:end));

end

