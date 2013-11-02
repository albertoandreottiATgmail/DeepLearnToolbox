function net = test_language_CNN

%Set up dataset
winsize = 607;
mfccnum = 39;

%Which fraction of the whole dataset will be used for training?
train_fraction = 0.97;

files = ["en.mat"; "it.mat"; "de.mat"];
usable = intmax;


for i=1:size(files,1)
    load(files(i, :));
    usable = min(usable, floor(size(mfccs, 2)/winsize));
    clear mfccs
end


%Reduce the amount of data according to memory available
usable = floor(0.75*usable);

%Clean memory often while preparing the dataset
for i=1:size(files,1)
       load(files(i, :));
	label = zeros(3, 1); label(i, 1)=1;
	if !exist('train_x')
	    train_x = reshape(mfccs(:, 1:(usable*winsize)), mfccnum, winsize, []);
           train_y = zeros(3, usable) + label;
	    clear mfccs
	else
	    reshaped = reshape(mfccs(:, 1:usable*winsize), mfccnum, winsize, []);
	    clear mfccs	
	    train_x = cat(3, train_x, reshaped);
           clear reshaped
	    train_y = cat(2, train_y, zeros(3, usable) + label);
	end
       clear mfccs	
end

%scaling/mean normalization 
average = 0.98;	
train_x = train_x .-average;
train_x = train_x/8;


%shuffle the training set, perhaps not necesary as it is done in the cnn
n = rand(size(train_x, 3),1); 
[nn index] = sort(n); 
train_x = train_x(:,:,index); 
train_y = train_y(:,index);

%The rest of the dataset goes for testing
e = size(train_x, 3);
s = floor(e*train_fraction);

test_x(:,:,1:(e-s+1)) = train_x(:,:,s:e);
test_y(:, 1:(e-s+1)) = train_y(:, s:e);

percentage_class1 = sum(train_y(1, :))/size(train_y,2)
percentage_class2 = sum(train_y(2, :))/size(train_y,2)
percentage_class3 = sum(train_y(3, :))/size(train_y,2)

isNanX = sum(sum(sum(isnan(train_x))))
isNanY = sum(sum(isnan(train_y)))

DataSetSize = size(train_x, 3)

pause


if !isOctave() 
  rng(0)
end

cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 6) %convolution layer
    struct('type', 's', 'xscale', 2, 'yscale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 6) %convolution layer
    struct('type', 's', 'xscale', 2, 'yscale', 2) %subsampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 6) %convolution layer
    struct('type', 's', 'xscale', 1, 'yscale', 143) %subsampling layer
};


opts.alpha = .6;
opts.batchsize = 2;
opts.numepochs = 8;

%Force the number of batches(totalbtch) to be a multiple of the batchsize
totalbtch = floor((size(train_x,3)*train_fraction)/(opts.batchsize))*opts.batchsize;

cnn = cnnsetup(cnn, train_x(:,:, 1:totalbtch), train_y(:,1:totalbtch));
cnn = cnntrain(cnn, train_x(:,:, 1:totalbtch), train_y(:,1:totalbtch), opts);

[er, bad] = cnntest(cnn, test_x, test_y);
er
%plot mean squared error
%figure; plot(cnn.rL);
net = cnn;
er

