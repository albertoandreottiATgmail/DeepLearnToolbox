function net = cnnff(net, x)
    n = numel(net.layers);
    net.layers{1}.a{1} = x;
    inputmaps = 1;

    for l = 2 : n   %  for each layer
        if strcmp(net.layers{l}.type, 'c')
            %  !!below can probably be handled by insane matrix operations
            for j = 1 : net.layers{l}.outputmaps   %  for each output map
                %  create temp output map
                z = zeros(size(net.layers{l - 1}.a{1}) - [net.layers{l}.kernelsize - 1 net.layers{l}.kernelsize - 1 0]);
                for i = 1 : inputmaps   %  for each input map
                    %  convolve with corresponding kernel and add to temp output map
                    z = z + convn(net.layers{l - 1}.a{i}, net.layers{l}.k{i}{j}, 'valid');
                end
                %  add bias, pass through nonlinearity
                net.layers{l}.a{j} = sigm(z + net.layers{l}.b{j});
            end
            %  set number of input maps to this layers number of outputmaps
            inputmaps = net.layers{l}.outputmaps;
        elseif strcmp(net.layers{l}.type, 's')
            %  downsample
	     for j = 1 : inputmaps
                xscale = net.layers{l}.xscale;
                yscale = net.layers{l}.yscale;
                z = convn(net.layers{l - 1}.a{j}, ones(xscale, yscale) / (xscale*yscale), 'valid');   %  !! replace with variable
                net.layers{l}.a{j} = z(1 : xscale : end, 1 : yscale : end, :);
            end
        end
    end

    %  concatenate all end layer feature maps into vector
    net.fv = [];
    for j = 1 : numel(net.layers{n}.a)
        sa = size(net.layers{n}.a{j});
        net.fv = [net.fv; reshape(net.layers{n}.a{j}, sa(1) * sa(2), sa(3))];
    end

    %  feedforward into output perceptrons
    inPut = net.ffW * net.fv + repmat(net.ffb, 1, size(net.fv, 2))
    for i=1:size(inPut, 2)
        net.o(:, i) = (e.^inPut(:, i))/sum(e.^inPut(:, i));
    end
    

end
