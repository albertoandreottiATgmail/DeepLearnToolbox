function net = cnntrain(net, x, y, opts)
    m = size(x, 3);
    numbatches = m / opts.batchsize;
    if rem(numbatches, 1) ~= 0
        error('numbatches not integer');
    end
    net.rL = [];
    net.currepoch = 1;

    for i = 1 : opts.numepochs
        disp(['epoch ' num2str(i) '/' num2str(opts.numepochs)]);
        tic;
        kk = randperm(m);
       
        badCount = totalCount = 0;
        
        for l = 1 : numbatches
            batch_x = x(:, :, kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));
            batch_y = y(:,    kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize))

            net = cnnff(net, batch_x);
            [~, bad] = cnntest(net, batch_x, batch_y)
            
            badCount = badCount + size(bad, 2);
            totalCount = totalCount + size(batch_x, 3);
            errorSoFar = badCount/totalCount

            fflush(stdout);
            net = cnnbp(net, batch_y);
            net = cnnapplygrads(net, opts);

            if isempty(net.rL)
                net.rL(1) = net.L;
            end
            net.rL(end + 1) = 0.99 * net.rL(end) + 0.01 * net.L;
        end
        toc;
        %TODO: make this configurable
        opts.alpha = opts.alpha*0.90;
        net.currepoch = net.currepoch + 1;
    end
end

