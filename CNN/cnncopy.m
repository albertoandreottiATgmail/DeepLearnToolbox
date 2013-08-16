function cpnet = cnncopy(cpnet, net)

    n = numel(net.layers);
    inputmaps = 1;

    for l = 2 : n   %  for each layer
	    if strcmp(net.layers{l}.type, 'c')
            for j = 1 : net.layers{l}.outputmaps   %  for each output map
                %  create temp output map
                for i = 1 : inputmaps   %  for each input map
                    %  convolve with corresponding kernel and add to temp output map
                    cpnet.layers{l}.k{i}{j} = net.layers{l}.k{i}{j};
                end
			end
		%elseif strcmp(net.layers{l}.type, 's')
		    for j = 1 : numel(net.layers{l}.b)
                cpnet.layers{l}.b{j} = net.layers{l}.b{j};
			end
		end
	end
	
	cpnet.ffW = net.ffW;
	cpnet.ffb = net.ffb;
    
end