zzz = rand(12,12,8);
hhh = rand(8, 8, 8);
convn_valid(zzz, hhh) - convnfft(zzz,hhh, 'valid')
convn(zzz, hhh, 'valid') - convnfft(zzz,hhh, 'valid')

zzz = rand(12,12);
hhh = rand(8, 8);
conv2D(zzz, hhh) - convnfft(zzz,hhh, 'valid')
conv2(zzz, hhh, 'valid') - convnfft(zzz,hhh, 'valid')