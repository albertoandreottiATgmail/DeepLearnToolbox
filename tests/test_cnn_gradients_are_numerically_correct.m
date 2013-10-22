function test_cnn_gradients_are_numerically_correct
batch_x = rand(28,28,5);
batch_y = zeros(10, 5);

[a b] = max(rand(10,5));
for i=1:size(a,2)
    batch_y(b(i), i) = 1;
end

cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 2, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 2, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %subsampling layer
};
cnn = cnnsetup(cnn, batch_x, batch_y);

cnn = cnnff(cnn, batch_x);
cnn = cnnbp(cnn, batch_y);
cnnnumgradcheck(cnn, batch_x, batch_y);