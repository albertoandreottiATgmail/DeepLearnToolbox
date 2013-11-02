function test_cnn_gradients_are_numerically_correct
batch_x = rand(28,28,5);
batch_y = rand(10,5);
cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 2, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'xscale', 2, 'yscale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 2, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'xscale', 2, 'yscale', 2) %subsampling layer
};
cnn = cnnsetup(cnn, batch_x, batch_y);

cnn = cnnff(cnn, batch_x);
cnn = cnnbp(cnn, batch_y);
cnnnumgradcheck(cnn, batch_x, batch_y);

%Now for the big network

batch_x = rand(39,607,5);
batch_y = zeros(3,5);

[a b] = max(rand(3,5));
for i=1:size(a,2)
    batch_y(b(i), i) = 1;
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

cnn = cnnsetup(cnn, batch_x, batch_y);

cnn = cnnff(cnn, batch_x);
cnn = cnnbp(cnn, batch_y);
cnnnumgradcheck(cnn, batch_x, batch_y);
