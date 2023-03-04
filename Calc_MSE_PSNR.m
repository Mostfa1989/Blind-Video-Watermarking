function [MSE, PSNR] = Calc_MSE_PSNR(clean,denoised)
% Calculate MSE and PSNR.
N = prod(size(clean));
clean = double(clean(:,:,:)); denoised = double(denoised(:,:,:));
t1 = sum((clean-denoised).^2);
MSE=0.0;
PSNR=0.0;
MSE = sqrt(t1/N);
PSNR = 20*log10(max(clean)/MSE);

%fprintf('MSE = %0.4f\n',MSE);
%fprintf('PSNR = %0.4f\n',PSNR);

