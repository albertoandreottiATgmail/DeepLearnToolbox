function test_language_CNN

%Set up dataset
winsize = 610;
files = ["en.mat"; "it.mat"; "de.mat"];
%train_x = rand(26, 610, 30);
%train_y = rand(1, 3, 300);

for i=1:size(files,1)
    load(files(i, :));
	usable = floor(size(mfccs, 2)/winsize);
	label = zeros(1,3); label(i)=1;
	
	if !exist('train_x')
	    train_x = reshape(mfccs(:, 1:(usable*winsize)), 26, winsize, []);
	    train_y = zeros(1, 3, usable).+ label;
	else
	    train_x = cat(3, train_x, reshape(mfccs(:, 1:usable*winsize), 26, winsize, []));
	    train_y = cat(3, train_y, zeros(1, 3, usable).+ label);
	end
	%clean memory
	clear mfccs
end
%% ex1 Train a 6c-2s-12c-2s Convolutional neural network 
%will run 1 epoch in about 200 second and get around 11% error. 
%With 100 epochs you'll get around 1.2% error
if !isOctave() 
rng(0)
end

cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'xscale', 2, 'yscale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 6) %convolution layer
    struct('type', 's', 'xscale', 2, 'yscale', 2) %subsampling layer
	struct('type', 'c', 'outputmaps', 12, 'kernelsize', 3) %convolution layer
	struct('type', 's', 'xscale', 1, 'yscale', 147) %subsampling layer
};


opts.alpha = 1;
opts.batchsize = 50;
opts.numepochs = 1;

totalbtch = floor(size(train_x,3)/opts.batchsize)*opts.batchsize;

cnn = cnnsetup(cnn, train_x(:,:, 1:totalbtch), train_y);
cnn = cnntrain(cnn, train_x(:,:, 1:totalbtch), train_y, opts);

[er, bad] = cnntest(cnn, test_x, test_y);
er
%plot mean squared error
%figure; plot(cnn.rL);
er
assert(er<0.12, 'Too big error');
