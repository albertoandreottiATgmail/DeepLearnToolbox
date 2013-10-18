function avgnet = cnnavg(avgnet, net)
    n = numel(net.layers);
    inputmaps = 1;

    for l = 2 : n   %  for each layer
	    if strcmp(net.layers{l}.type, 'c')
            for j = 1 : net.layers{l}.outputmaps   %  for each output map
                %  create temp output map
                for i = 1 : inputmaps   %  for each input map
                    %  convolve with corresponding kernel and add to temp output map
                    avgnet.layers{l}.k{i}{j} = (avgnet.layers{l}.k{i}{j} + net.layers{l}.k{i}{j})/2;
                end
			end
		%elseif strcmp(net.layers{l}.type, 's')
		    for j = 1 : numel(net.layers{l}.b)
                avgnet.layers{l}.b{j} = (net.layers{l}.b{j} + avgnet.layers{l}.b{j})/2;
			end
		end
	end
	
	avgnet.ffW = (avgnet.ffW + net.ffW)/2;
	avgnet.ffb = (avgnet.ffb + net.ffb)/2;
end