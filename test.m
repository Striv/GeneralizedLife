spaceEdge = 10;
while 1
    clf;
    axis([0 spaceEdge+1 0 spaceEdge+1 0 spaceEdge+1]);
    mat = rand([10, 10, 10]);
    mat(mat < .8) = 0;
    mat(mat >= .8) = 1;
%     inds = find(mat);
    disp('about to draw');
        for i = 1:numel(mat)
            [x, y, z] = ind2sub([spaceEdge,spaceEdge,spaceEdge], i);
            voxel([x y z] - 1, [1, 1, 1], 'r', .125*mat(i));
        end
        pause;
end
