% loads images, runs fastICA, and saves the results

im_name_pref = 'mixedimage_';   % unnumbered part of image filenames
im_format = 'bmp';              % image format suffix
n = 4;                          % number of images

figure
% load images
for i=1:n
  im = imread(sprintf('%s%d.%s',im_name_pref,i,im_format));
  subplot(2,n,i)
  imagesc(im)
  X(i,:) = double(im(:));
end

W = fastICA(X)
S = W*X;

% save results
for i=1:n
  im = reshape(S(i,:),size(im));
  subplot(2,n,n+i)
  imagesc(im)
  imwrite(im/255,sprintf('%s%d_sep.%s',im_name_pref,i,im_format));
end
