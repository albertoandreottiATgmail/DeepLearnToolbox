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
    mult = mult(:);
	[vals, idx] = sort(abs(mult));
	result = 0.0;
	for i=1:size(mult,1)
	    
		if result*mult(idx(i))<0 && result/mult(idx(i)) > -0.7
		    temp = mult(idx(i));
			mult(idx(i)) = mult(end);
			mult (end) = temp;
		end
		result += round(mult(idx(i))*1e5)/1e5;
	end
	
end