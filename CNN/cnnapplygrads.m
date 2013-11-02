function net = cnnapplygrads(net, opts)
    limit = 1e-4;
    for l = 2 : numel(net.layers)
        if strcmp(net.layers{l}.type, 'c')
            for j = 1 : numel(net.layers{l}.a)
                for ii = 1 : numel(net.layers{l - 1}.a)
                    if net.currepoch == 1
                        while (sum(abs(net.layers{l}.dk{ii}{j}))/numel(net.layers{l}.dk{ii}{j}))<limit
                           net.layers{l}.dk{ii}{j} = net.layers{l}.dk{ii}{j}*10;
                        end
                    end

                    net.layers{l}.k{ii}{j} = net.layers{l}.k{ii}{j} - opts.alpha * net.layers{l}.dk{ii}{j};
                end
                net.layers{l}.b{j} = net.layers{l}.b{j} - opts.alpha * net.layers{l}.db{j};
            end
        end
    end

    net.ffW = net.ffW - opts.alpha * net.dffW;
    net.ffb = net.ffb - opts.alpha * net.dffb;
end
