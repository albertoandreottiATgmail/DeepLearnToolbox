%Convolution for 3 dimensional vectors using conv2
%equivalent to convn(A,B, 'valid')

function result = convn_valid(A, B)

    m = size(A, 1) - size(B, 1) + 1;
    numWorkers = 2;
	
	
	%each worker will write its output to specific part of the output
    %chunkSize = size(A,3)/numWorkers;
    %result = pararrayfun(numWorkers,  @(i)convadd(A, flipdim(B,3), m, i, chunkSize), 0:numWorkers-1, "ErrorHandler" , @eh);
	result = zeros(m, m);
	B = flipdim(B,3);
    for j=1:size(A, 3)  
	    %result += conv2(A(:,:,j),B(:,:,j), 'valid');
		result += conv2(A(:,:,j),B(:,:,j), 'valid');
	end
	
end