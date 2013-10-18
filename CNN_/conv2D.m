%Convolution for 2 dimensional vectors by hand
%equivalent to conv2(A,B)

function result = conv2D(A, B)

    m = size(A, 1) - size(B, 1) + 1;
	n = size(B,1)-1;
	result = zeros(m,m); 
    B = fliplr(flipud(B));
	for i=1:size(A,1)-n
	    for j=1:size(A,2)-n
            result(i,j) = conv_pixel(A(i:i+n, j:j+n), B);	
	    end
	end
end

%Convolve a single pixel
function result = conv_pixel(A, B)
    m = size(A, 1);
	mult = A.*B;
	result = sum(sum(mult));
	
end