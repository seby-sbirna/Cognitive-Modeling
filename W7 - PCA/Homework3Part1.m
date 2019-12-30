clc;
clearvars;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 26 OCT 2019
% Aleksander Frese (s163859) and 
% Sebastian Sbirna (190553)
% 02458 Cognitive Modeling w/ Tobias Andersen @ DTU
% Week 7 exercises
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load img and get dimensions
img = imread('MonaLisaBW.jpg');
%img = imread('rgbimg1.png'); % testing
img_dim = size(size(img));
if img_dim(2) == 3 % if the image has 3 color channels, then convert to gray
    img = rgb2gray(img);
    disp('Image is rgb! Converting to grayscale.')
end
img_size = size(img);
img_h = img_size(1);
img_w = img_size(2);

% set patch_size
patch_h = 10; % patch height
patch_w = 10; % patch width

% get nr of patches
hpatch = floor(img_w/patch_w); % horizontal patches
vpatch = floor(img_h/patch_h); % vertical patches

% avoid image cropping/clipping
%if mod(img_w,10) > 0
%    hpatch = hpatch + 1;
%end
%if mod(img_h,10) > 0
%    vpatch = vpatch + 1;
%end

% total number of patches we expect
npatches = hpatch * vpatch; 

% initialize array to hold n number of 10x10 patches
listPatches = zeros(patch_h, patch_w, npatches);

% transform img into array of 10x10 patches
cnt = 1;
for i = 1:vpatch
    for j = 1:hpatch
        top = (i-1)*patch_h+1; % top edge of current patch
        bottom = i*patch_h; % bottom edge
        left = (j-1)*patch_w+1; % left edge
        right = j*patch_w; % right edge
        listPatches(:,:,cnt) = img((top:bottom),(left:right));
        %listPatches(:,:,cnt) = img(((i-1)*patch_h+1:i*patch_h),((j-1)*patch_w+1:j*patch_w));
        cnt = cnt + 1;
    end
end

% output size check
listpatchsize = size(listPatches);
if listpatchsize(3) ~= npatches
    disp('Error! Did not get expected number of patches.');
end

%listPatches(:,:,2) % debugging

%reshaped_listPatches = zeros(1,100,npatches);
%for e = 1:npatches
%   reshaped_listPatches(:,:,e) = reshape(listPatches(:,:,e),1,100);
%end
    
%S = [];
%for e = 1:npatches
%    S = vertcat(S, reshaped_listPatches(:,:,e));
%end

% reshape patches and stack vertically
reshaped_listPatches = zeros(npatches,100);
for e = 1:npatches
    reshaped_listPatches(e,:) = reshape(listPatches(:,:,e),1,100);
end
S = reshaped_listPatches;

% perform PCA on S
% X = principal component coefficients = loadings.
% W = principal component scores = score
% eigvals = principal component variances = eigenvalues of cov(X)
% explained = the percentage of the total variance explained by each principal component
[X,W,eigvals,~,explained] = pca(S);

S_reconstructed = X*transpose(W);
%imagesc(S_reconstructed)

% transform 100x9120 matrix into 10x10x9120 3-dim matrix
reconstructed_listPatches = zeros(10,10,npatches);
for e = 1:npatches
    v = S_reconstructed(:,e); % get the column vector
    reconstructed_listPatches(:,:,e) = reshape(v,10,10);
end

% transform 10x10x9120 3-dim matrix back into image-space (result is
% cropped image)
img_reconstructed = zeros(vpatch*patch_h, hpatch*patch_w);
cnt = 1;
for i = 1:vpatch
    for j = 1:hpatch
        top = (i-1)*patch_h+1; % top edge of current patch
        bottom = i*patch_h; % bottom edge
        left = (j-1)*patch_w+1; % left edge
        right = j*patch_w; % right edge
        img_reconstructed((top:bottom),(left:right)) = reconstructed_listPatches(:,:,cnt);
        %img_reconstructed(((i-1)*patch_h+1:i*patch_h),((j-1)*patch_w+1:j*patch_w)) = reconstructed_listPatches(:,:,cnt);
        cnt = cnt + 1; % move to next part of img to be reconstructed
    end
end

figure(1)
subplot(1,2,1)
imagesc(img_reconstructed) % show reconstructed image
colormap(gray)
title('Reconstructed image')

subplot(1,2,2)
imagesc(img) % show original image
colormap(gray)
title('Original image')

% note: the difference between the original and reconstructed image is in
% fact negligible 


%%% How many eigenvalues does it take to explain 95% of the total variance?
t = 0;
idx = 1;
while t < 95
    t = t + explained(idx);
    idx = idx + 1;
end
disp(['Nr. of eigenvalues to explain 95%: ' num2str(idx)])
disp(['Total variance explained by first ' num2str(idx) ' eigenvalues: ' num2str(t)])


%%% Take 6 first pc's and transform to img space
% explanation of diff between image.m and imagesc.m: https://stackoverflow.com/a/33793160
% using imagesc for automatic scaling to use the full colormap
% imagesc(I) = image(I, CDataMapping='scaled')
figure(2)

% nr of PCs to include
n_pcs = 6;

% displaying properties
n_cols = 3; % 3 PCs per row
n_rows = ceil(n_pcs/n_cols); 

X_n = X(:,1:n_pcs); % get first n PCs
X_n = rescale(X_n,0,1); % rescale across all PCs to same scale
X_n = X_n*64; % scale up all PCs to matlab colormap range (0-64)

for pc = 1:n_pcs
   subplot(n_rows,n_cols,pc)
   %imagesc(reshape(X(:,1),10,10))
   %image(reshape(X(:,pc)*500,10,10))
   image(reshape(X_n(:,pc),10,10))
   colormap(gray)
   title(['PC' num2str(pc)])
   %colorbar
end

%%% Reconstruct S from XW^t using only the first six principal components
X_sub = X(:,(1:6)); % get first six PCs
W_sub = W(:,(1:6));
S_reconstructed_sub = X_sub*transpose(W_sub);

% transform 100x6 matrix into 10x10x6 3-dim matrix
reconstructed_listPatches_sub = zeros(10,10,npatches);
for e = 1:npatches
    v = S_reconstructed_sub(:,e); % get the column vector
    reconstructed_listPatches_sub(:,:,e) = reshape(v,10,10);  % vec2mat(v,patch_w);
end

img_reconstructed_sub = zeros(vpatch*patch_h, hpatch*patch_w);
cnt = 1; 
for i = 1:vpatch
    for j = 1:hpatch
        top = (i-1)*patch_h+1; % top edge of current patch
        bottom = i*patch_h; % bottom edge
        left = (j-1)*patch_w+1; % left edge
        right = j*patch_w; % right edge
        img_reconstructed_sub((top:bottom),(left:right)) = reconstructed_listPatches_sub(:,:,cnt);
        %img_reconstructed_sub(((i-1)*patch_h+1:i*patch_h),((j-1)*patch_w+1:j*patch_w)) = reconstructed_listPatches_sub(:,:,cnt);
        cnt = cnt + 1;
    end
end

figure(3)
subplot(1,2,1)
imagesc(img_reconstructed_sub) % show reconstructed image from first 6 PCs
colormap(gray)
title('Reconstructed image from first 6 PCs')

subplot(1,2,2)
imagesc(img) % show original image
colormap(gray)
title('Original image')

%%%%%%%%%%%%%%

