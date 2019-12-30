
%load image of mona
I=imread('MonaLisaBW.jpg');

%I=imread('/Users/tobias/Dropbox/Newwork/Teaching/02458/02458_16/02458Exam16/02458Exam16Final/woodBW.jpg');

PatchSz = 10;
Npatches = floor(size(I)/PatchSz);
ImSz = Npatches* PatchSz;
I = double(I(1:Npatches(1)*PatchSz,1:Npatches(2)*PatchSz));


%show figure of b/w mona on screen
figure
imagesc(I)
colormap gray
axis equal

%transform image to a measurement x channel matrix
%DataMatrix is a collection of 10x10 pixel image patches
Indx=0;
DataMatrix=zeros(prod(Npatches),PatchSz^2);

for r=1:Npatches(1)
    for c=1:Npatches(2)
        
        Indx=Indx+1;
        
        DataMatrix(Indx,:)=reshape(I((r-1)*PatchSz+(1:PatchSz),(c-1)*PatchSz+(1:PatchSz)),[1 PatchSz^2]);
        
    end
end
        
% perform pca on the DataMatrix containing the image patches
% if you have matlab's stat toolbox you can use the commented line 
%[Coeff, Score, Latent] = princomp(DataMatrix);
% C=cov(DataMatrix);
% [V,D] = eig(C);
% Latent = flipud(diag(D));
% Coeff=fliplr(V);
% Score=(DataMatrix*Coeff);
%[Coeff, Score, Lat] = princomp(DataMatrix);
[Coeff, Score, Lat, TSQUARED, EXPLAINED] = pca(DataMatrix);

%Reconstruct the image from N_PC principal components
N_PC=6;
DataMatrixRe=(Score(:,1:N_PC)*Coeff(:,1:N_PC)');

Indx=0;

for r=1:Npatches(1)
    for c=1:Npatches(2)
        
        Indx=Indx+1;
        ImageRe((r-1)*PatchSz+(1:PatchSz),(c-1)*PatchSz+(1:PatchSz)) = reshape(DataMatrixRe(Indx,:),[PatchSz PatchSz]);
        
        
    end
end

%show the reconstructed image
figure
imagesc(ImageRe)
colormap gray
axis square

% show the first 6 principal components on the same scale
figure
SclCoeff=64*(Coeff-min(min(Coeff)))/(max(max(Coeff))-min(min(Coeff))); %scale

for p=1:6
    
    subplot(2,3,p)
    
    image(reshape(SclCoeff(:,p),[PatchSz PatchSz]));
    colormap gray
    axis square
end
    
    
