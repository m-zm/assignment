
function im2 = RBFImageWarp(im, psrc, pdst)

% input: im, psrc, pdst

%const value
sigma2 = 1000;

%resolve coeff_mat
%use guuassian rbf : g(r) = exp(-r^2/sigma2)
len = length(psrc);
move_vec = pdst - psrc;
src_x_mat = psrc(:,1);
src_y_mat = psrc(:,2);
dist_x_mat = repmat(src_x_mat,1,len) - repmat(src_x_mat,1,len)';
dist_y_mat = repmat(src_y_mat,1,len) - repmat(src_y_mat,1,len)';
dist_mat = dist_x_mat.*dist_x_mat + dist_y_mat.*dist_y_mat;
weight_mat = guassian_rbf(dist_mat, sigma2);
coeff_mat = weight_mat\move_vec;

%test
%error is the distance between \
%original destination and caculated destination
error = zeros(len,2);
for l=1:len
    test_src = psrc(l,:);
    test_dist_mat = repmat(test_src, len, 1) - psrc;
    test_dist_vec = sum(test_dist_mat.*test_dist_mat, 2);
    test_weight_vec = guassian_rbf(test_dist_vec, sigma2);
    test_dst = test_weight_vec' * coeff_mat + test_src;
    error(l,:) = test_dst - pdst(l,:);
end
error

%% basic image manipulations
% get image (matrix) size
[h, w, dim] = size(im);

im2 = zeros(h, w, dim, 'uint8');

%% use loop to warp image
for i=1:h
    for j=1:w
        dist_mat = repmat([i, j], len, 1) - psrc;
        dist_vec = sum(dist_mat.*dist_mat, 2);
        weight_vec = guassian_rbf(dist_vec, sigma2);
        move = weight_vec' * coeff_mat;
        dst_x = floor(move(1)) + i;
        dst_y = floor(move(2)) + j;
        if(dst_x > 0 && dst_x <= w && dst_y > 0 && dst_y <= h)
            im2(dst_x, dst_y, :) = im(i, j, :);
        end
    end
end
